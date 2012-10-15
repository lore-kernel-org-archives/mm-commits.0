From: akpm@linux-foundation.org
Subject: + proc-check-vma-vm_file-before-dereferencing.patch added to -mm tree
Date: Mon, 15 Oct 2012 14:41:40 -0700
Message-ID: <20121015214141.351725C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62333 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab2JOVln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 17:41:43 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so345881fae.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 14:41:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, gorcunov@openvz.org, viro@zeniv.linux.org.uk


The patch titled
     From: Stanislav Kinsbursky <skinsbursky@parallels.com>
has been added to the -mm tree.  Its filename is
     proc-check-vma-vm_file-before-dereferencing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: proc: check vma->vm_file before dereferencing

Needs a changelog

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~proc-check-vma-vm_file-before-dereferencing fs/proc/base.c
--- a/fs/proc/base.c~proc-check-vma-vm_file-before-dereferencing
+++ a/fs/proc/base.c
@@ -1770,8 +1770,9 @@ static struct dentry *proc_map_files_loo
 	if (!vma)
 		goto out_no_vma;
 
-	result = proc_map_files_instantiate(dir, dentry, task,
-			(void *)(unsigned long)vma->vm_file->f_mode);
+	if (vma->vm_file)
+		result = proc_map_files_instantiate(dir, dentry, task,
+				(void *)(unsigned long)vma->vm_file->f_mode);
 
 out_no_vma:
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

proc-check-vma-vm_file-before-dereferencing.patch

