From: akpm@linux-foundation.org
Subject: - sched-fix-init_hrtick-section-mismatch-warning.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:48 -0700
Message-ID: <200810012151.m91Lpm3Q005957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbYJAVwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sched: fix init_hrtick() section mismatch warning
has been removed from the -mm tree.  Its filename was
     sched-fix-init_hrtick-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fix init_hrtick() section mismatch warning
From: "Rakib Mullick" <rakib.mullick@gmail.com>

   LD      kernel/built-in.o
WARNING: kernel/built-in.o(.text+0x326): Section mismatch in reference
from the function init_hrtick() to the variable
.cpuinit.data:hotplug_hrtick_nb.8
The function init_hrtick() references
the variable __cpuinitdata hotplug_hrtick_nb.8.
This is often because init_hrtick lacks a __cpuinitdata
annotation or the annotation of hotplug_hrtick_nb.8 is wrong.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-init_hrtick-section-mismatch-warning kernel/sched.c
--- a/kernel/sched.c~sched-fix-init_hrtick-section-mismatch-warning
+++ a/kernel/sched.c
@@ -1094,7 +1094,7 @@ hotplug_hrtick(struct notifier_block *nf
 	return NOTIFY_DONE;
 }
 
-static void init_hrtick(void)
+static __init void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

cpusetc-remove-extra-variable.patch

