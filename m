From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-sysc-remove-stable-friendly-pf_thread_bound-define.patch removed from -mm tree
Date: Thu, 09 May 2013 13:51:30 -0700
Message-ID: <20130509205131.37F6331C08F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:52564 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3EIUvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:51:32 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so333794qec.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:51:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: remove -stable friendly PF_THREAD_BOUND define
has been removed from the -mm tree.  Its filename was
     kernel-sysc-remove-stable-friendly-pf_thread_bound-define.patch

This patch was dropped because an updated version will be merged

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
