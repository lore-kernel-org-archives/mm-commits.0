From: akpm@linux-foundation.org
Subject: [merged] intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch removed from -mm tree
Date: Mon, 07 May 2012 14:20:27 -0700
Message-ID: <20120507212027.80C45A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38564 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2EGVUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2012 17:20:31 -0400
Received: by bkty5 with SMTP id y5so284733bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 07 May 2012 14:20:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.y.wang@intel.com, alan@linux.intel.com, hpa@zytor.com, kangkai.yin@intel.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, pierre.tardy@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
has been removed from the -mm tree.  Its filename was
     intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yong Wang <yong.y.wang@intel.com>
Subject: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND

So that the power button still wakes up the platform.

Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
Tested-by: Kangkai Yin <kangkai.yin@intel.com>
Tested-by: Yong Wang <yong.y.wang@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_mid_powerbtn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/intel_mid_powerbtn.c~intel_mid_powerbtn-mark-irq-as-irqf_no_suspend drivers/platform/x86/intel_mid_powerbtn.c
--- a/drivers/platform/x86/intel_mid_powerbtn.c~intel_mid_powerbtn-mark-irq-as-irqf_no_suspend
+++ a/drivers/platform/x86/intel_mid_powerbtn.c
@@ -78,7 +78,7 @@ static int __devinit mfld_pb_probe(struc
 
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	error = request_threaded_irq(irq, NULL, mfld_pb_isr, 0,
+	error = request_threaded_irq(irq, NULL, mfld_pb_isr, IRQF_NO_SUSPEND,
 			DRIVER_NAME, input);
 	if (error) {
 		dev_err(&pdev->dev, "Unable to request irq %d for mfld power"
_

Patches currently in -mm which might be from yong.y.wang@intel.com are


