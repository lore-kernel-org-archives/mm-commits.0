From: akpm@linux-foundation.org
Subject: [folded-merged]
 tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 12:10:48 -0700
Message-ID: <55300938.VENFuylgp/U34sbr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbDPTKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbueso@suse.de, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch

This patch was dropped because it was folded into tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes

Sumeone needs to buy a tab key.


WARNING: please, no spaces at the start of a line
#29: FILE: security/tomoyo/util.c:951:
+       struct file *exe_file;$

WARNING: please, no spaces at the start of a line
#30: FILE: security/tomoyo/util.c:952:
+       const char *cp;$

WARNING: please, no spaces at the start of a line
#31: FILE: security/tomoyo/util.c:953:
+       struct mm_struct *mm = current->mm;$

WARNING: please, no spaces at the start of a line
#40: FILE: security/tomoyo/util.c:955:
+       if (!mm)$

WARNING: suspect code indent for conditional statements (7, 15)
#40: FILE: security/tomoyo/util.c:955:
+       if (!mm)
+	       return NULL;

WARNING: please, no spaces at the start of a line
#42: FILE: security/tomoyo/util.c:957:
+       exe_file = get_mm_exe_file(mm);$

WARNING: please, no spaces at the start of a line
#43: FILE: security/tomoyo/util.c:958:
+       if (!exe_file)$

WARNING: suspect code indent for conditional statements (7, 15)
#43: FILE: security/tomoyo/util.c:958:
+       if (!exe_file)
+	       return NULL;

WARNING: please, no spaces at the start of a line
#46: FILE: security/tomoyo/util.c:961:
+       cp = tomoyo_realpath_from_path(&exe_file->f_path);$

WARNING: please, no spaces at the start of a line
#47: FILE: security/tomoyo/util.c:962:
+       fput(exe_file);$

WARNING: please, no spaces at the start of a line
#48: FILE: security/tomoyo/util.c:963:
+       return cp;$

total: 0 errors, 11 warnings, 28 lines checked

./patches/tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: James Morris <jmorris@namei.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/tomoyo/util.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes security/tomoyo/util.c
--- a/security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes
+++ a/security/tomoyo/util.c
@@ -948,19 +948,19 @@ bool tomoyo_path_matches_pattern(const s
  */
 const char *tomoyo_get_exe(void)
 {
-       struct file *exe_file;
-       const char *cp;
-       struct mm_struct *mm = current->mm;
+	struct file *exe_file;
+	const char *cp;
+	struct mm_struct *mm = current->mm;
 
-       if (!mm)
-	       return NULL;
-       exe_file = get_mm_exe_file(mm);
-       if (!exe_file)
-	       return NULL;
+	if (!mm)
+		return NULL;
+	exe_file = get_mm_exe_file(mm);
+	if (!exe_file)
+		return NULL;
 
-       cp = tomoyo_realpath_from_path(&exe_file->f_path);
-       fput(exe_file);
-       return cp;
+	cp = tomoyo_realpath_from_path(&exe_file->f_path);
+	fput(exe_file);
+	return cp;
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes.patch
kernel-forkc-avoid-division-by-zero.patch
doc-sysctl-kerneltxt-document-threads-max.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling.patch
kconfig-use-macros-which-are-already-defined.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch
documentation-spi-spidev_testc-fix-warning.patch

