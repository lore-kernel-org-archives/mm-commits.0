From: akpm@linux-foundation.org
Subject: + proc-check-vma-vm_file-before-dereferencing.patch added to -mm tree
Date: Mon, 15 Oct 2012 15:03:52 -0700
Message-ID: <20121015220353.5BCCC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47167 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab2JOWDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 18:03:54 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so692213vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 15:03:53 -0700 (PDT)
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

7b540d0646ce ("proc_map_files_readdir(): don't bother with grabbing
files") switched proc_map_files_readdir() to use @f_mode directly instead of
grabbing @file reference, but same time the test for @vm_file presence was
lost leading to nil dereference.  The patch brings the test back.

The all proc_map_files feature is CONFIG_CHECKPOINT_RESTORE wrapped
(which is set to 'n' by default) so the bug doesn't affect regular
kernels.

The regression is 3.7-rc1 only as far as I can tell.

[gorcunov@openvz.org: provided changelog]
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

