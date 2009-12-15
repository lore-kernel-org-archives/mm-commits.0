From: akpm@linux-foundation.org
Subject: [folded] crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:12:11 -0800
Message-ID: <200912150112.nBF1CCBP024625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853AbZLOBNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Joakim.Tjernlund@transmode.se, mm-commits@vger.kernel.org


The patch titled
     crc32-minor-optimizations-and-cleanup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch

This patch was dropped because it was folded into crc32-minor-optimizations-and-cleanup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crc32-minor-optimizations-and-cleanup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

may as well depukify it a bit while we're there.



WARNING: plain inline is preferred over __inline__
#22: FILE: lib/crc32.c:47:
+static __inline__ u32

ERROR: space prohibited after that open square bracket '['
#26: FILE: lib/crc32.c:51:
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)

ERROR: space prohibited before that close square bracket ']'
#26: FILE: lib/crc32.c:51:
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)

ERROR: Macros with complex values should be enclosed in parenthesis
#26: FILE: lib/crc32.c:51:
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)

ERROR: space prohibited after that open square bracket '['
#28: FILE: lib/crc32.c:53:
+#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)

ERROR: Macros with complex values should be enclosed in parenthesis
#28: FILE: lib/crc32.c:53:
+#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)

ERROR: spaces required around that '=' (ctx:WxV)
#30: FILE: lib/crc32.c:55:
+	const u32 *b =(u32 *)buf;
 	             ^

ERROR: space required before the open parenthesis '('
#34: FILE: lib/crc32.c:59:
+	if(unlikely(((long)b)&3 && len)) {

ERROR: space required before the open parenthesis '('
#53: FILE: lib/crc32.c:78:
+	if(len) {

total: 8 errors, 1 warnings, 145 lines checked

./patches/crc32-minor-optimizations-and-cleanup.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/crc32.c~crc32-minor-optimizations-and-cleanup-checkpatch-fixes lib/crc32.c
--- a/lib/crc32.c~crc32-minor-optimizations-and-cleanup-checkpatch-fixes
+++ a/lib/crc32.c
@@ -44,19 +44,19 @@ MODULE_LICENSE("GPL");
 
 #if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
 
-static __inline__ u32
+static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
+#  define DO_CRC(x) crc = tab[(crc ^ (x)) & 255 ] ^ (crc >> 8)
 # else
-#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
+#  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
 # endif
-	const u32 *b =(u32 *)buf;
+	const u32 *b = (const u32 *)buf;
 	size_t    rem_len;
 
 	/* Align it */
-	if(unlikely(((long)b)&3 && len)) {
+	if (unlikely((long)b & 3 && len)) {
 		u8 *p = (u8 *)b;
 		do {
 			DO_CRC(*p++);
@@ -75,7 +75,7 @@ crc32_body(u32 crc, unsigned char const 
 	}
 	len = rem_len;
 	/* And the last few bytes */
-	if(len) {
+	if (len) {
 		u8 *p = (u8 *)(b + 1) - 1;
 		do {
 			DO_CRC(*++p); /* use pre increment for speed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
errh-add-helper-function-to-simplify-pointer-error-checking.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim.patch
blackfin-sd-host-controller-driver.patch
crc32-minor-optimizations-and-cleanup.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

