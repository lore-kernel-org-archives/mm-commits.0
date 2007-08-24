From: akpm@linux-foundation.org
Subject: + hpet-force-enable-on-ich34.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:53 -0700
Message-ID: <200708242205.l7OM5rAh017083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759890AbXHXWQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: us15@os.inf.tu-dresden.de, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     Enable HPET on ICH3 and ICH4
has been added to the -mm tree.  Its filename is
     hpet-force-enable-on-ich34.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Enable HPET on ICH3 and ICH4
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>

ICH3 and ICH4 have undocumented HPET capabilities.  This patch enables HPET
for platforms based around these ICHs.  

Tested on various ICH3 and ICH4 platforms.

Because HPET is not officially documented for ICH3/4 and may not have been
validated by chipset folks, we're on thin ice here. I'd recommend testing 
this patch in -hrt or -mm for a while and wait for success/failure reports
before feeding it upstream.

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/quirks.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN arch/i386/kernel/quirks.c~hpet-force-enable-on-ich34 arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~hpet-force-enable-on-ich34
+++ a/arch/i386/kernel/quirks.c
@@ -232,6 +232,14 @@ static void old_ich_force_enable_hpet(st
 	printk(KERN_DEBUG "Failed to force enable HPET\n");
 }
 
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0,
+                         old_ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12,
+                         old_ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_0,
+                         old_ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_12,
+                         old_ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_0,
                          old_ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_12,
_

Patches currently in -mm which might be from us15@os.inf.tu-dresden.de are

hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
