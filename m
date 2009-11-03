From: akpm@linux-foundation.org
Subject: + exec-setup_arg_pages-fails-to-return-errors.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:59:04 -0800
Message-ID: <200911030659.nA36x4C5013818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZKCG7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, serue@us.ibm.com, xiyou.wangcong@gmail.com


The patch titled
     exec: setup_arg_pages() fails to return errors
has been added to the -mm tree.  Its filename is
     exec-setup_arg_pages-fails-to-return-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: setup_arg_pages() fails to return errors
From: Anton Blanchard <anton@samba.org>

In setup_arg_pages we work hard to assign a value to ret, but on exit we
always return 0.

Also remove a now duplicated exit path and branch to out_unlock instead.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~exec-setup_arg_pages-fails-to-return-errors fs/exec.c
--- a/fs/exec.c~exec-setup_arg_pages-fails-to-return-errors
+++ a/fs/exec.c
@@ -623,10 +623,8 @@ int setup_arg_pages(struct linux_binprm 
 	/* Move stack pages down in memory. */
 	if (stack_shift) {
 		ret = shift_arg_pages(vma, stack_shift);
-		if (ret) {
-			up_write(&mm->mmap_sem);
-			return ret;
-		}
+		if (ret)
+			goto out_unlock;
 	}
 
 #ifdef CONFIG_STACK_GROWSUP
@@ -640,7 +638,7 @@ int setup_arg_pages(struct linux_binprm 
 
 out_unlock:
 	up_write(&mm->mmap_sem);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(setup_arg_pages);
 
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
exec-setup_arg_pages-fails-to-return-errors.patch

