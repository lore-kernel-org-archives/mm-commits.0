From: akpm@linux-foundation.org
Subject: + tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch added to -mm
 tree
Date: Wed, 04 Mar 2015 14:28:59 -0800
Message-ID: <54f7872b.9J02PeiSPsvi9805%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbbCDW3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:29:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: tomoyo: reduce mmap_sem hold for mm->exe_file
has been added to the -mm tree.  Its filename is
     tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: tomoyo: reduce mmap_sem hold for mm->exe_file

The mm->exe_file is currently serialized with mmap_sem (shared) in order
to both safely (1) read the file and (2) compute the realpath by calling
tomoyo_realpath_from_path, making it an absolute overkill.  Good users
will, on the other hand, make use of the more standard get_mm_exe_file(),
requiring only holding the mmap_sem to read the value, and relying on
reference

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/tomoyo/util.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file security/tomoyo/util.c
--- a/security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file
+++ a/security/tomoyo/util.c
@@ -948,16 +948,19 @@ bool tomoyo_path_matches_pattern(const s
  */
 const char *tomoyo_get_exe(void)
 {
-	struct mm_struct *mm = current->mm;
-	const char *cp = NULL;
+       struct file *exe_file;
+       const char *cp;
+       struct mm_struct *mm = current->mm;
 
-	if (!mm)
-		return NULL;
-	down_read(&mm->mmap_sem);
-	if (mm->exe_file)
-		cp = tomoyo_realpath_from_path(&mm->exe_file->f_path);
-	up_read(&mm->mmap_sem);
-	return cp;
+       if (!mm)
+	       return NULL;
+       exe_file = get_mm_exe_file(mm);
+       if (!exe_file)
+	       return NULL;
+
+       cp = tomoyo_realpath_from_path(&exe_file->f_path);
+       fput(exe_file);
+       return cp;
 }
 
 /**
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
arc-do-not-export-symbols-in-troubleshootc.patch
linux-next.patch
tile-elf-reorganize-notify_exec.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch
powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch

