From: akpm@linux-foundation.org
Subject: [folded] reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:20:11 -0800
Message-ID: <201002032020.o13KKBjm016723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab0BCUUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     From: Edward Shishkin <edward.shishkin@gmail.com>
has been removed from the -mm tree.  Its filename was
     reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Edward Shishkin <edward.shishkin@gmail.com>


This is a multi-part message in MIME format.
--------------010200050204000200080203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Laurent Riffard wrote:
> Hi Edward,
>

Hello Laurent.

> This patch is buggy, isn't it ?
>

Yes, sorry, my fault..
I have sent the fixup already to the list yesterday..
Resending for you and Akpm.
Andrew, please apply.

Thanks.
Edward.

> I've got 2 reiser4 FS in my /etc/fstab:
>
> /dev/vglinux1/lvkernel-r4 /home/laurent/kernel reiser4 defaults,noatime,nodiratime,tmgr.atom_max_size=2048 0 0
> /dev/disk/by-uuid/b8dbe880-b664-49aa-8050-bddc91fd5e49 /mnt/diske reiser4 noauto,users,noatime,nodiratime 0 0
>
> The first FS can't be mounted:
>
> [  235.078342] reiser4[mount(4205)]: parse_options (fs/reiser4/init_super.c:253)[nikita-2307]:
> [  235.078345] WARNING: Unrecognized option: "tmgr.atom_max_size=2048"
>

--------------010200050204000200080203
Content-Type: text/plain;
 name="reiser4-reduce-frame-size-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-reduce-frame-size-fix.patch"

. Fix up the bug in reiser4_init_super_data():
  The pointer "p" to opt_desc structure is not
  incremented.
  Pass "&p" instead of "p" to push_sb_field_opts(),
  which is supposed to increment the pointer.
. Modify macros PUSH_OPT, OPT_ARRAY_CHECK to accept
  arguments.

Signed-off-by Edward Shsihkin <edward.shishkin@gmail.com>
---
 1 file changed, 16 insertions(+), 12 deletions(-)


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/init_super.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN fs/reiser4/init_super.c~reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup
+++ a/fs/reiser4/init_super.c
@@ -293,27 +293,27 @@ static int parse_options(char *opt_strin
 #define MAX_NR_OPTIONS (30)
 
 #if REISER4_DEBUG
-#  define OPT_ARRAY_CHECK if ((p) > (opts) + MAX_NR_OPTIONS) {		\
+#  define OPT_ARRAY_CHECK(opt, array)					\
+	if ((opt) > (array) + MAX_NR_OPTIONS) {				\
 		warning("zam-1046", "opt array is overloaded"); break;	\
 	}
 #else
-#   define OPT_ARRAY_CHECK noop
+#   define OPT_ARRAY_CHECK(opt, array) noop
 #endif
 
-#define PUSH_OPT(...)				\
+#define PUSH_OPT(opt, array, ...)		\
 do {						\
 	struct opt_desc o = __VA_ARGS__;	\
-	OPT_ARRAY_CHECK;			\
-	*p ++ = o;				\
+	OPT_ARRAY_CHECK(opt, array);		\
+	*(opt) ++ = o;				\
 } while (0)
 
-#define PUSH_SB_FIELD_OPT(field, format) PUSH_OPT(SB_FIELD_OPT(field, format))
-#define PUSH_BIT_OPT(name, bit) PUSH_OPT(BIT_OPT(name, bit))
-
-static noinline void push_sb_field_opts(struct opt_desc *p,
+static noinline void push_sb_field_opts(struct opt_desc **p,
 					struct opt_desc *opts,
 					reiser4_super_info_data *sbinfo)
 {
+#define PUSH_SB_FIELD_OPT(field, format)		\
+	PUSH_OPT(*p, opts, SB_FIELD_OPT(field, format))
 	/*
 	 * tmgr.atom_max_size=N
 	 * Atoms containing more than N blocks will be forced to commit. N is
@@ -441,8 +441,12 @@ int reiser4_init_super_data(struct super
 	/* initialize structure describing reiser4 mount options */
 	p = opts;
 
-	push_sb_field_opts(p, opts, sbinfo);
+	push_sb_field_opts(&p, opts, sbinfo);
 	/* turn on BSD-style gid assignment */
+
+#define PUSH_BIT_OPT(name, bit)			\
+	PUSH_OPT(p, opts, BIT_OPT(name, bit))
+
 	PUSH_BIT_OPT("bsdgroups", REISER4_BSD_GID);
 	/* turn on 32 bit times */
 	PUSH_BIT_OPT("32bittimes", REISER4_32_BIT_TIMES);
@@ -456,7 +460,7 @@ int reiser4_init_super_data(struct super
 	/* disable use of write barriers in the reiser4 log writer. */
 	PUSH_BIT_OPT("no_write_barrier", REISER4_NO_WRITE_BARRIER);
 
-	PUSH_OPT(
+	PUSH_OPT(p, opts,
 	{
 		/*
 		 * tree traversal readahead parameters:
@@ -482,7 +486,7 @@ int reiser4_init_super_data(struct super
 	);
 
 	/* What to do in case of fs error */
-	PUSH_OPT(
+	PUSH_OPT(p, opts,
 	{
 		.name = "onerror",
 		.type = OPT_ONEOF,
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-improve-writeback_inodes_wb.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-writeback_inodes-implementation.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

