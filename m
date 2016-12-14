From: akpm@linux-foundation.org
Subject: [patch 009/114] sysctl: add KERN_CONT to
 deprecated_sysctl_warning()
Date: Wed, 14 Dec 2016 15:04:26 -0800
Message-ID: <5851cffa./ZNh5cZoj9JyMOQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34360 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbcLNXEl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, ebiederm@xmission.com

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
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
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
