From: akpm@linux-foundation.org
Subject: - m68knommu-coldfire-add-support-for-kernel-preemption-missing-chunk.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:07 -0700
Message-ID: <200805132133.m4DLX7Nt000788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761761AbYEMVde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: ColdFire add support for kernel preemption (missing chunk)
has been removed from the -mm tree.  Its filename was
     m68knommu-coldfire-add-support-for-kernel-preemption-missing-chunk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: ColdFire add support for kernel preemption (missing chunk)
From: Sebastian Siewior <bigeasy@linutronix.de>

As the subject says this patch adds the support for kernel preemption on
m68knommu Coldfire.  I thing the same changes could be applied to 68360 &
68328 but since I don't have the HW, I don't touch it.  Kconfig enables the
preemption item only on coldfire.

This is a missing chunk from Sebastian's original patch that I lost from the
first submission.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/m68knommu/Kconfig~m68knommu-coldfire-add-support-for-kernel-preemption-missing-chunk arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~m68knommu-coldfire-add-support-for-kernel-preemption-missing-chunk
+++ a/arch/m68knommu/Kconfig
@@ -671,6 +671,9 @@ config ROMKERNEL
 
 endchoice
 
+if COLDFIRE
+source "kernel/Kconfig.preempt"
+endif
 source "mm/Kconfig"
 
 endmenu
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

origin.patch
m68knommu-add-info-about-removing-mcfserial.patch
linux-next.patch
add-the-carmine-fb-driver.patch
add-the-carmine-fb-driver-update.patch

