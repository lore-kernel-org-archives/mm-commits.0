From: akpm@linux-foundation.org
Subject: [to-be-updated]
 s390-boot-add-dfltcc=-kernel-command-line-parameter.patch removed from -mm
 tree
Date: Thu, 16 Jan 2020 18:49:48 -0800
Message-ID: <20200117024948.5_4tZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388282AbgAQCtu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 21:49:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rpurdie@rpsys.net, josef@toxicpanda.com, iii@linux.ibm.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com, edward6@linux.ibm.com, dsterba@suse.com, clm@fb.com, borntraeger@de.ibm.com, zaslonko@linux.ibm.com


The patch titled
     Subject: s390/boot: add dfltcc= kernel command line parameter
has been removed from the -mm tree.  Its filename was
     s390-boot-add-dfltcc=-kernel-command-line-parameter.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: s390/boot: add dfltcc= kernel command line parameter

Add the new kernel command line parameter 'dfltcc=' to configure s390 zlib
hardware support.

Format: { on | off | def_only | inf_only | always }
 on:       s390 zlib hardware support for compression on
           level 1 and decompression (default)
 off:      No s390 zlib hardware support
 def_only: s390 zlib hardware support for deflate
           only (compression on level 1)
 inf_only: s390 zlib hardware support for inflate
           only (decompression)
 always:   Same as 'on' but ignores the selected compression
           level always using hardware support (used for debugging)

Link: http://lkml.kernel.org/r/20191209152948.37080-5-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Eduard Shishkin <edward6@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   12 ++++++++++++
 arch/s390/boot/ipl_parm.c                       |   14 ++++++++++++++
 arch/s390/include/asm/setup.h                   |    7 +++++++
 arch/s390/kernel/setup.c                        |    1 +
 lib/zlib_dfltcc/dfltcc.c                        |    5 ++++-
 lib/zlib_dfltcc/dfltcc.h                        |    1 +
 lib/zlib_dfltcc/dfltcc_deflate.c                |    6 ++++++
 lib/zlib_dfltcc/dfltcc_inflate.c                |    6 ++++++
 lib/zlib_dfltcc/dfltcc_util.h                   |    5 +++++
 9 files changed, 56 insertions(+), 1 deletion(-)

--- a/arch/s390/boot/ipl_parm.c~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/arch/s390/boot/ipl_parm.c
@@ -14,6 +14,7 @@
 char __bootdata(early_command_line)[COMMAND_LINE_SIZE];
 struct ipl_parameter_block __bootdata_preserved(ipl_block);
 int __bootdata_preserved(ipl_block_valid);
+unsigned int __bootdata_preserved(zlib_dfltcc_support) = ZLIB_DFLTCC_FULL;
 
 unsigned long __bootdata(vmalloc_size) = VMALLOC_DEFAULT_SIZE;
 unsigned long __bootdata(memory_end);
@@ -229,6 +230,19 @@ void parse_boot_command_line(void)
 		if (!strcmp(param, "vmalloc") && val)
 			vmalloc_size = round_up(memparse(val, NULL), PAGE_SIZE);
 
+		if (!strcmp(param, "dfltcc")) {
+			if (!strcmp(val, "off"))
+				zlib_dfltcc_support = ZLIB_DFLTCC_DISABLED;
+			else if (!strcmp(val, "on"))
+				zlib_dfltcc_support = ZLIB_DFLTCC_FULL;
+			else if (!strcmp(val, "def_only"))
+				zlib_dfltcc_support = ZLIB_DFLTCC_DEFLATE_ONLY;
+			else if (!strcmp(val, "inf_only"))
+				zlib_dfltcc_support = ZLIB_DFLTCC_INFLATE_ONLY;
+			else if (!strcmp(val, "always"))
+				zlib_dfltcc_support = ZLIB_DFLTCC_FULL_DEBUG;
+		}
+
 		if (!strcmp(param, "noexec")) {
 			rc = kstrtobool(val, &enabled);
 			if (!rc && !enabled)
--- a/arch/s390/include/asm/setup.h~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/arch/s390/include/asm/setup.h
@@ -79,6 +79,13 @@ struct parmarea {
 	char command_line[ARCH_COMMAND_LINE_SIZE];	/* 0x10480 */
 };
 
+extern unsigned int zlib_dfltcc_support;
+#define ZLIB_DFLTCC_DISABLED		0
+#define ZLIB_DFLTCC_FULL		1
+#define ZLIB_DFLTCC_DEFLATE_ONLY	2
+#define ZLIB_DFLTCC_INFLATE_ONLY	3
+#define ZLIB_DFLTCC_FULL_DEBUG		4
+
 extern int noexec_disabled;
 extern int memory_end_set;
 extern unsigned long memory_end;
--- a/arch/s390/kernel/setup.c~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/arch/s390/kernel/setup.c
@@ -111,6 +111,7 @@ unsigned long __bootdata_preserved(__ete
 unsigned long __bootdata_preserved(__sdma);
 unsigned long __bootdata_preserved(__edma);
 unsigned long __bootdata_preserved(__kaslr_offset);
+unsigned int __bootdata_preserved(zlib_dfltcc_support);
 
 unsigned long VMALLOC_START;
 EXPORT_SYMBOL(VMALLOC_START);
--- a/Documentation/admin-guide/kernel-parameters.txt~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -834,6 +834,18 @@
 			dump out devices still on the deferred probe list after
 			retrying.
 
+	dfltcc=		[HW,S390]
+			Format: { on | off | def_only | inf_only | always }
+			on:       s390 zlib hardware support for compression on
+			          level 1 and decompression (default)
+			off:      No s390 zlib hardware support
+			def_only: s390 zlib hardware support for deflate
+			          only (compression on level 1)
+			inf_only: s390 zlib hardware support for inflate
+			          only (decompression)
+			always:   Same as 'on' but ignores the selected compression
+			          level always using hardware support (used for debugging)
+
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
--- a/lib/zlib_dfltcc/dfltcc.c~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/lib/zlib_dfltcc/dfltcc.c
@@ -44,7 +44,10 @@ void dfltcc_reset(
     dfltcc_state->param.nt = 1;
 
     /* Initialize tuning parameters */
-    dfltcc_state->level_mask = DFLTCC_LEVEL_MASK;
+    if (zlib_dfltcc_support == ZLIB_DFLTCC_FULL_DEBUG)
+        dfltcc_state->level_mask = DFLTCC_LEVEL_MASK_DEBUG;
+    else
+        dfltcc_state->level_mask = DFLTCC_LEVEL_MASK;
     dfltcc_state->block_size = DFLTCC_BLOCK_SIZE;
     dfltcc_state->block_threshold = DFLTCC_FIRST_FHT_BLOCK_SIZE;
     dfltcc_state->dht_threshold = DFLTCC_DHT_MIN_SAMPLE_SIZE;
--- a/lib/zlib_dfltcc/dfltcc_deflate.c~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -3,6 +3,7 @@
 #include "../zlib_deflate/defutil.h"
 #include "dfltcc_util.h"
 #include "dfltcc.h"
+#include <asm/setup.h>
 #include <linux/zutil.h>
 
 /*
@@ -15,6 +16,11 @@ int dfltcc_can_deflate(
     deflate_state *state = (deflate_state *)strm->state;
     struct dfltcc_state *dfltcc_state = GET_DFLTCC_STATE(state);
 
+    /* Check for kernel dfltcc command line parameter */
+    if (zlib_dfltcc_support == ZLIB_DFLTCC_DISABLED ||
+            zlib_dfltcc_support == ZLIB_DFLTCC_INFLATE_ONLY)
+        return 0;
+
     /* Unsupported compression settings */
     if (!dfltcc_are_params_ok(state->level, state->w_bits, state->strategy,
                               dfltcc_state->level_mask))
--- a/lib/zlib_dfltcc/dfltcc.h~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/lib/zlib_dfltcc/dfltcc.h
@@ -8,6 +8,7 @@
  * Tuning parameters.
  */
 #define DFLTCC_LEVEL_MASK 0x2 /* DFLTCC compression for level 1 only */
+#define DFLTCC_LEVEL_MASK_DEBUG 0x3fe /* DFLTCC compression for all levels */
 #define DFLTCC_BLOCK_SIZE 1048576
 #define DFLTCC_FIRST_FHT_BLOCK_SIZE 4096
 #define DFLTCC_DHT_MIN_SAMPLE_SIZE 4096
--- a/lib/zlib_dfltcc/dfltcc_inflate.c~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -3,6 +3,7 @@
 #include "../zlib_inflate/inflate.h"
 #include "dfltcc_util.h"
 #include "dfltcc.h"
+#include <asm/setup.h>
 #include <linux/zutil.h>
 
 /*
@@ -15,6 +16,11 @@ int dfltcc_can_inflate(
     struct inflate_state *state = (struct inflate_state *)strm->state;
     struct dfltcc_state *dfltcc_state = GET_DFLTCC_STATE(state);
 
+    /* Check for kernel dfltcc command line parameter */
+    if (zlib_dfltcc_support == ZLIB_DFLTCC_DISABLED ||
+            zlib_dfltcc_support == ZLIB_DFLTCC_DEFLATE_ONLY)
+        return 0;
+
     /* Unsupported compression settings */
     if (state->wbits != HB_BITS)
         return 0;
--- a/lib/zlib_dfltcc/dfltcc_util.h~s390-boot-add-dfltcc=-kernel-command-line-parameter
+++ a/lib/zlib_dfltcc/dfltcc_util.h
@@ -3,6 +3,7 @@
 #define DFLTCC_UTIL_H
 
 #include <linux/zutil.h>
+#include <asm/setup.h>
 
 /*
  * C wrapper for the DEFLATE CONVERSION CALL instruction.
@@ -104,6 +105,10 @@ static inline int is_dfltcc_enabled(void
     uint64_t facilities[(DFLTCC_FACILITY / 64) + 1];
     register char r0 __asm__("r0");
 
+    /* Check for kernel dfltcc command line parameter */
+    if (zlib_dfltcc_support == ZLIB_DFLTCC_DISABLED)
+        return 0;
+
     memset(facilities, 0, sizeof(facilities));
     r0 = sizeof(facilities) / sizeof(facilities[0]) - 1;
     __asm__ volatile("stfle %[facilities]\n"
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are

lib-zlib-add-zlib_deflate_dfltcc_enabled-function.patch
btrfs-use-larger-zlib-buffer-for-s390-hardware-compression.patch
