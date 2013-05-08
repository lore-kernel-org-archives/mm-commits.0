From: akpm@linux-foundation.org
Subject: + kernel-sysc-remove-stable-friendly-pf_thread_bound-define.patch added to -mm tree
Date: Wed, 08 May 2013 13:45:13 -0700
Message-ID: <20130508204513.E9D4D31C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36357 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3EHUpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:45:15 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so210351ghb.3
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:45:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de


The patch titled
     Subject: kernel/sys.c: remove -stable friendly PF_THREAD_BOUND define
has been added to the -mm tree.  Its filename is
     kernel-sysc-remove-stable-friendly-pf_thread_bound-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: kernel/sys.c: remove -stable friendly PF_THREAD_BOUND define

"reboot: rigrate shutdown/reboot to boot cpu" added this temporary #define
for easier backporting to the stable releases.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-remove-stable-friendly-pf_thread_bound-define kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-remove-stable-friendly-pf_thread_bound-define
+++ a/kernel/sys.c
@@ -362,11 +362,6 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-/* Add backwards compatibility for stable trees. */
-#ifndef PF_NO_SETAFFINITY
-#define PF_NO_SETAFFINITY		PF_THREAD_BOUND
-#endif
