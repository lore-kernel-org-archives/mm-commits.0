From: akpm@linux-foundation.org
Subject: [merged] tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:55 -0700
Message-ID: <55355197.I8vBbggsKb2mY2vm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbDTTOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: tomoyo: reduce mmap_sem hold for mm->exe_file
has been removed from the -mm tree.  Its filename was
     tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: tomoyo: reduce mmap_sem hold for mm->exe_file

The mm->exe_file is currently serialized with mmap_sem (shared) in order
to both safely (1) read the file and (2) compute the realpath by calling
tomoyo_realpath_from_path, making it an absolute overkill.  Good users
will, on the other hand, make use of the more standard get_mm_exe_file(),
requiring only holding the mmap_sem to read the value, and relying on
reference

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/tomoyo/util.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file security/tomoyo/util.c
--- a/security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file
+++ a/security/tomoyo/util.c
@@ -948,15 +948,18 @@ bool tomoyo_path_matches_pattern(const s
  */
 const char *tomoyo_get_exe(void)
 {
+	struct file *exe_file;
+	const char *cp;
 	struct mm_struct *mm = current->mm;
-	const char *cp = NULL;
 
 	if (!mm)
 		return NULL;
-	down_read(&mm->mmap_sem);
-	if (mm->exe_file)
-		cp = tomoyo_realpath_from_path(&mm->exe_file->f_path);
-	up_read(&mm->mmap_sem);
+	exe_file = get_mm_exe_file(mm);
+	if (!exe_file)
+		return NULL;
+
+	cp = tomoyo_realpath_from_path(&exe_file->f_path);
+	fput(exe_file);
 	return cp;
 }
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch
linux-next.patch

