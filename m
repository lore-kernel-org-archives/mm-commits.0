From: akpm@linux-foundation.org
Subject: + intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch added to -mm tree
Date: Mon, 06 Feb 2012 13:01:14 -0800
Message-ID: <20120206210115.0F0E7A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65051 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BFVBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 16:01:15 -0500
Received: by yenm1 with SMTP id m1so24275yen.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 13:01:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.y.wang@intel.com, alan@linux.intel.com, hpa@zytor.com, kangkai.yin@intel.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, pierre.tardy@intel.com, tglx@linutronix.de


The patch titled
     Subject: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND
has been added to the -mm tree.  Its filename is
     intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND

Patches currently in -mm which might be from yong.y.wang@intel.com are

intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch

