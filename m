From: akpm@linux-foundation.org
Subject: [merged] exec-setup_arg_pages-fails-to-return-errors.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:10 -0800
Message-ID: <200911131927.nADJRAKP029978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbZKMT1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, serue@us.ibm.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     exec: setup_arg_pages() fails to return errors
has been removed from the -mm tree.  Its filename was
     exec-setup_arg_pages-fails-to-return-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


diff -puN fs/exec.c~exec-setup_arg_pages-fails-to-return-errors fs/exec.c
--- a/fs/exec.c~exec-setup_arg_pages-fails-to-return-errors
+++ a/fs/exec.c
@@ -624,10 +624,8 @@ int setup_arg_pages(struct linux_binprm 
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
@@ -641,7 +639,7 @@ int setup_arg_pages(struct linux_binprm 
 
 out_unlock:
 	up_write(&mm->mmap_sem);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(setup_arg_pages);
 
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch

