From: akpm@linux-foundation.org
Subject: + reiser4-use-dynamic-lattice-for-adaptive-compression.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:32:29 -0800
Message-ID: <200702280632.l1S6WXLi008914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42071 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXB1Gcj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4: use dynamic lattice for adaptive compression  modes
has been added to the -mm tree.  Its filename is
     reiser4-use-dynamic-lattice-for-adaptive-compression.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: use dynamic lattice for adaptive compression  modes
From: Edward Shishkin <edward@namesys.com>

Use one dynamic lattice instead of many static lattices with various factors
for adaptive compression modes.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/init_super.c                    |    2 
 fs/reiser4/plugin/compress/compress_mode.c |  122 +++++++++----------
 fs/reiser4/plugin/file/cryptcompress.c     |    3 
 fs/reiser4/plugin/file/cryptcompress.h     |   39 +++++-
 fs/reiser4/plugin/file/file_conversion.c   |    2 
 fs/reiser4/plugin/plugin.h                 |   10 -
 6 files changed, 105 insertions(+), 73 deletions(-)

diff -puN fs/reiser4/init_super.c~reiser4-use-dynamic-lattice-for-adaptive-compression fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-use-dynamic-lattice-for-adaptive-compression
+++ a/fs/reiser4/init_super.c
@@ -649,7 +649,7 @@ static struct {
 	},
 	[PSET_COMPRESSION_MODE] = {
 		.type = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
-		.id = COL_16_COMPRESSION_MODE_ID
+		.id = CONVX_COMPRESSION_MODE_ID
 	},
 	[PSET_CLUSTER] = {
 		.type = REISER4_CLUSTER_PLUGIN_TYPE,
diff -puN fs/reiser4/plugin/compress/compress_mode.c~reiser4-use-dynamic-lattice-for-adaptive-compression fs/reiser4/plugin/compress/compress_mode.c
--- a/fs/reiser4/plugin/compress/compress_mode.c~reiser4-use-dynamic-lattice-for-adaptive-compression
+++ a/fs/reiser4/plugin/compress/compress_mode.c
@@ -9,11 +9,6 @@
 #include "../../inode.h"
 #include "../plugin.h"
 
-static int should_deflate_test(struct inode * inode, cloff_t index)
-{
-	return !test_bit(0, &index);
-}
-
 static int should_deflate_none(struct inode * inode, cloff_t index)
 {
 	return 0;
@@ -24,62 +19,57 @@ static int should_deflate_common(struct 
 	return compression_is_on(cryptcompress_inode_data(inode));
 }
 
-static int turn_off_compression(struct inode *inode, cloff_t index)
+static int discard_hook_ultim(struct inode *inode, cloff_t index)
 {
-	toggle_compression(cryptcompress_inode_data(inode), 0);
+	turn_off_compression(cryptcompress_inode_data(inode));
+	return 0;
+}
+
+static int discard_hook_lattd(struct inode *inode, cloff_t index)
+{
+	cryptcompress_info_t * info = cryptcompress_inode_data(inode);
+
+	assert("edward-1462",
+	       get_lattice_factor(info) >= MIN_LATTICE_FACTOR &&
+	       get_lattice_factor(info) <= MAX_LATTICE_FACTOR);
+
+	turn_off_compression(info);
+	if (get_lattice_factor(info) < MAX_LATTICE_FACTOR)
+		set_lattice_factor(info, get_lattice_factor(info) << 1);
 	return 0;
 }
 
-static int turn_on_compression(struct inode *inode, cloff_t index)
+static int accept_hook_lattd(struct inode *inode, cloff_t index)
 {
-	toggle_compression(cryptcompress_inode_data(inode), 1);
+	turn_on_compression(cryptcompress_inode_data(inode));
+	set_lattice_factor(cryptcompress_inode_data(inode), MIN_LATTICE_FACTOR);
 	return 0;
 }
 
-/* Check on lattice (COL) of some sparseness factor,
-   the family of adaptive compression modes which define
-   the following behavior:
+/* Check on dynamic lattice, the adaptive compression modes which
+   defines the following behavior:
 
    Compression is on: try to compress everything and turn
    it off, whenever cluster is incompressible.
 
    Compression is off: try to compress clusters of indexes
    k * FACTOR (k = 0, 1, 2, ...) and turn it on, if some of
-   them is compressible. */
+   them is compressible. If incompressible, then increase FACTOR */
 
 /* check if @index belongs to one-dimensional lattice
    of sparce factor @factor */
-static int check_on_lattice(cloff_t index, int factor)
+static int is_on_lattice(cloff_t index, int factor)
 {
 	return (factor ? index % factor == 0: index == 0);
 }
 
-#define DEFINE_CHECK_ON_LATTICE(FACTOR)                                 \
-	static int check_on_lattice_ ## FACTOR (struct inode * inode,   \
-						cloff_t index)		\
-{                                                                       \
-	return should_deflate_common(inode, index) ||			\
-		check_on_lattice(index, FACTOR);			\
-}
-
-#define SUPPORT_COL_COMPRESSION_MODE(FACTOR, LABEL)                     \
-[COL_ ## FACTOR ## _COMPRESSION_MODE_ID] = {                            \
-	.h = {                                                          \
-		.type_id = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,        \
-		.id = COL_ ## FACTOR ## _COMPRESSION_MODE_ID,           \
-		.pops = NULL,                                           \
-		.label = LABEL,                                         \
-		.desc = LABEL,                                          \
-		.linkage = {NULL, NULL}                                 \
-	},                                                              \
-	.should_deflate = check_on_lattice_ ## FACTOR,                  \
-	.accept_hook =  turn_on_compression,                            \
-	.discard_hook = turn_off_compression                            \
-}
-
-DEFINE_CHECK_ON_LATTICE(8)
-DEFINE_CHECK_ON_LATTICE(16)
-DEFINE_CHECK_ON_LATTICE(32)
+static int should_deflate_lattd(struct inode * inode, cloff_t index)
+{
+	return should_deflate_common(inode, index) ||
+		is_on_lattice(index,
+			      get_lattice_factor
+			      (cryptcompress_inode_data(inode)));
+}
 
 /* compression mode_plugins */
 compression_mode_plugin compression_mode_plugins[LAST_COMPRESSION_MODE_ID] = {
@@ -96,28 +86,37 @@ compression_mode_plugin compression_mode
 		.accept_hook = NULL,
 		.discard_hook = NULL
 	},
-	/* Check-on-lattice adaptive compression modes.
-	   Turn compression on/off in flush time */
-	SUPPORT_COL_COMPRESSION_MODE(8, "col8"),
-	SUPPORT_COL_COMPRESSION_MODE(16, "col16"),
-	SUPPORT_COL_COMPRESSION_MODE(32, "col32"),
-	/* In this mode items will be converted to extents and management
-	   will be passed to (classic) unix file plugin as soon as ->write()
-	   detects that the first complete logical cluster (of index #0) is
-	   incompressible. */
-	[CONVX_COMPRESSION_MODE_ID] = {
+	/* Check-on-dynamic-lattice adaptive compression mode */
+	[LATTD_COMPRESSION_MODE_ID] = {
 		.h = {
 			.type_id = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
-			.id = CONVX_COMPRESSION_MODE_ID,
+			.id = LATTD_COMPRESSION_MODE_ID,
 			.pops = NULL,
-			.label = "conv",
-			.desc = "Convert to extent",
+			.label = "lattd",
+			.desc = "Check on dynamic lattice",
+			.linkage = {NULL, NULL}
+		},
+		.should_deflate = should_deflate_lattd,
+		.accept_hook = accept_hook_lattd,
+		.discard_hook = discard_hook_lattd
+	},
+	/* Check-ultimately compression mode:
+	   Turn off compression forever as soon as we meet
+	   incompressible data */
+	[ULTIM_COMPRESSION_MODE_ID] = {
+		.h = {
+			.type_id = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
+			.id = ULTIM_COMPRESSION_MODE_ID,
+			.pops = NULL,
+			.label = "ultim",
+			.desc = "Check ultimately",
 			.linkage = {NULL, NULL}
 		},
 		.should_deflate = should_deflate_common,
 		.accept_hook = NULL,
-		.discard_hook = NULL
+		.discard_hook = discard_hook_ultim
 	},
+	/* Force-to-compress-everything compression mode */
 	[FORCE_COMPRESSION_MODE_ID] = {
 		.h = {
 			.type_id = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
@@ -131,16 +130,21 @@ compression_mode_plugin compression_mode
 		.accept_hook = NULL,
 		.discard_hook = NULL
 	},
-	[TEST_COMPRESSION_MODE_ID] = {
+	/* Convert-to-extent compression mode.
+	   In this mode items will be converted to extents and management
+	   will be passed to (classic) unix file plugin as soon as ->write()
+	   detects that the first complete logical cluster (of index #0) is
+	   incompressible. */
+	[CONVX_COMPRESSION_MODE_ID] = {
 		.h = {
 			.type_id = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
-			.id = TEST_COMPRESSION_MODE_ID,
+			.id = CONVX_COMPRESSION_MODE_ID,
 			.pops = NULL,
-			.label = "test", /* This mode is for benchmarks only */
-			.desc = "Don't compress odd clusters",
+			.label = "conv",
+			.desc = "Convert to extent",
 			.linkage = {NULL, NULL}
 		},
-		.should_deflate = should_deflate_test,
+		.should_deflate = should_deflate_common,
 		.accept_hook = NULL,
 		.discard_hook = NULL
 	}
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-dynamic-lattice-for-adaptive-compression fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-dynamic-lattice-for-adaptive-compression
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -38,7 +38,8 @@ void init_inode_data_cryptcompress(struc
 
 	memset(data, 0, sizeof(*data));
 
-	toggle_compression(data, 1);
+	turn_on_compression(data);
+	set_lattice_factor(data, MIN_LATTICE_FACTOR);
 	init_inode_ordering(inode, crd, create);
 }
 
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-use-dynamic-lattice-for-adaptive-compression fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-use-dynamic-lattice-for-adaptive-compression
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -10,12 +10,14 @@
 
 #include <linux/pagemap.h>
 
-#define MIN_CLUSTER_SIZE PAGE_CACHE_SIZE
 #define MIN_CLUSTER_SHIFT PAGE_CACHE_SHIFT
 #define MAX_CLUSTER_SHIFT 16
 #define MAX_CLUSTER_NRPAGES (1U << MAX_CLUSTER_SHIFT >> PAGE_CACHE_SHIFT)
 #define DC_CHECKSUM_SIZE 4
 
+#define MIN_LATTICE_FACTOR 1
+#define MAX_LATTICE_FACTOR 32
+
 /* this mask contains all non-standard plugins that might
    be present in reiser4-specific part of inode managed by
    cryptcompress file plugin */
@@ -446,23 +448,50 @@ static inline void dec_keyload_count(cry
 /* cryptcompress specific part of reiser4_inode */
 typedef struct cryptcompress_info {
 	crypto_stat_t *crypt;
-	int compress_toggle;      /* current status of compressibility
-				     is set by compression mode plugin */
+	/* the following 2 fields are controlled by compression mode plugin */
+	int compress_toggle; /* current status of compressibility */
+	int lattice_factor;  /* factor of dynamic lattice. FIXME: Have a
+				compression_toggle to keep the factor */
 #if REISER4_DEBUG
 	int pgcount;              /* number of captured pages */
 #endif
 } cryptcompress_info_t;
 
-static inline void toggle_compression (cryptcompress_info_t * info, int val)
+static inline void set_compression_toggle (cryptcompress_info_t * info, int val)
 {
 	info->compress_toggle = val;
 }
 
-static inline int compression_is_on (cryptcompress_info_t * info)
+static inline int get_compression_toggle (cryptcompress_info_t * info)
 {
 	return info->compress_toggle;
 }
 
+static inline int compression_is_on(cryptcompress_info_t * info)
+{
+	return get_compression_toggle(info) == 1;
+}
+
+static inline void turn_on_compression(cryptcompress_info_t * info)
+{
+	set_compression_toggle(info, 1);
+}
+
+static inline void turn_off_compression(cryptcompress_info_t * info)
+{
+	set_compression_toggle(info, 0);
+}
+
+static inline void set_lattice_factor(cryptcompress_info_t * info, int val)
+{
+	info->lattice_factor = val;
+}
+
+static inline int get_lattice_factor(cryptcompress_info_t * info)
+{
+	return info->lattice_factor;
+}
+
 cryptcompress_info_t *cryptcompress_inode_data(const struct inode *);
 int equal_to_rdk(znode *, const reiser4_key *);
 int goto_right_neighbor(coord_t *, lock_handle *);
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-use-dynamic-lattice-for-adaptive-compression fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-use-dynamic-lattice-for-adaptive-compression
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -187,7 +187,7 @@ static int disable_conversion_no_update_
 	       force_plugin_pset(inode,
 				 PSET_COMPRESSION_MODE,
 				 (reiser4_plugin *)compression_mode_plugin_by_id
-				 (COL_8_COMPRESSION_MODE_ID));
+				 (LATTD_COMPRESSION_MODE_ID));
 	assert("edward-1500",
 	       ergo(!result, disabled_conversion_inode_ok(inode)));
 	return result;
diff -puN fs/reiser4/plugin/plugin.h~reiser4-use-dynamic-lattice-for-adaptive-compression fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-use-dynamic-lattice-for-adaptive-compression
+++ a/fs/reiser4/plugin/plugin.h
@@ -727,13 +727,11 @@ typedef enum {
 /* builtin compression mode plugins */
 typedef enum {
 	NONE_COMPRESSION_MODE_ID,
-	COL_8_COMPRESSION_MODE_ID,
-	COL_16_COMPRESSION_MODE_ID,
-	COL_32_COMPRESSION_MODE_ID,
-	CONVX_COMPRESSION_MODE_ID,
+	LATTD_COMPRESSION_MODE_ID,
+	ULTIM_COMPRESSION_MODE_ID,
 	FORCE_COMPRESSION_MODE_ID,
-	TEST_COMPRESSION_MODE_ID,
-  	LAST_COMPRESSION_MODE_ID
+	CONVX_COMPRESSION_MODE_ID,
+	LAST_COMPRESSION_MODE_ID
 } reiser4_compression_mode_id;
 
 /* builtin cluster plugins */
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
reiser4-vs-git-block3.patch
