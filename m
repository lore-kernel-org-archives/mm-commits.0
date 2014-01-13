From: akpm@linux-foundation.org
Subject: +
 exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch added
 to -mm tree
Date: Mon, 13 Jan 2014 12:03:12 -0800
Message-ID: <52d44680.vhFsOe7cO8Nedgup%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaAMUDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 15:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, oleg@redhat.com, zhang.yi20@zte.com.cn

Subject: + exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch added to -mm tree
To: zhang.yi20@zte.com.cn,oleg@redhat.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 12:03:12 -0800


The patch titled
     From: zhang.yi20@zte.com.cn
has been added to the -mm tree.  Its filename is
     exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhang.yi20@zte.com.cn
Subject: : exec: avoid propagating PF_NO_SETAFFINITY into userspace child

Userspace process doesn't want the PF_NO_SETAFFINITY, but its parent may be
a kernel worker thread which has PF_NO_SETAFFINITY set, and this worker thread
can do kernel_thread() to create the child.
Clearing this flag in usersapce child to enable its migrating capability.

Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~exec-avoid-propagating-pf_no_setaffinity-into-userspace-child fs/exec.c
--- a/fs/exec.c~exec-avoid-propagating-pf_no_setaffinity-into-userspace-child
+++ a/fs/exec.c
@@ -1087,8 +1087,8 @@ int flush_old_exec(struct linux_binprm *
 	bprm->mm = NULL;		/* We're using it now */
 
 	set_fs(USER_DS);
-	current->flags &=
-		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
+	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
+					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 
_

Patches currently in -mm which might be from zhang.yi20@zte.com.cn are

exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch

