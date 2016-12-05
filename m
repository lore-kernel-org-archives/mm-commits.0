From: akpm@linux-foundation.org
Subject: + sysctl-add-kern_cont-to-deprecated_sysctl_warning.patch added
 to -mm tree
Date: Mon, 05 Dec 2016 12:59:16 -0800
Message-ID: <5845d524.6qR6fRPUwlK6BtIg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbcLEU6t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2016 15:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: add KERN_CONT to deprecated_sysctl_warning()
has been added to the -mm tree.  Its filename is
     sysctl-add-kern_cont-to-deprecated_sysctl_warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-add-kern_cont-to-deprecated_sysctl_warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-add-kern_cont-to-deprecated_sysctl_warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: sysctl: add KERN_CONT to deprecated_sysctl_warning()

Do not break lines while printk()ing values.

  kernel: warning: process `tomoyo_file_tes' used the deprecated sysctl system call with
  kernel: 3.
  kernel: 5.
  kernel: 56.
  kernel:

Link: http://lkml.kernel.org/r/1480814833-4976-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl_binary.c~sysctl-add-kern_cont-to-deprecated_sysctl_warning kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-add-kern_cont-to-deprecated_sysctl_warning
+++ a/kernel/sysctl_binary.c
@@ -1354,8 +1354,8 @@ static void deprecated_sysctl_warning(co
 			"warning: process `%s' used the deprecated sysctl "
 			"system call with ", current->comm);
 		for (i = 0; i < nlen; i++)
-			printk("%d.", name[i]);
-		printk("\n");
+			printk(KERN_CONT "%d.", name[i]);
+		printk(KERN_CONT "\n");
 	}
 	return;
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch
sysctl-add-kern_cont-to-deprecated_sysctl_warning.patch

