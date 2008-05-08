From: akpm@linux-foundation.org
Subject: + pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set.patch added to -mm tree
Date: Thu, 08 May 2008 13:04:50 -0700
Message-ID: <200805082004.m48K4oRE003232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbYEHUFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, jbarnes@virtuousgeek.org, shaohua.li@intel.com


The patch titled
     PCI ACPI: fix uninitialized variable in __pci_osc_support_set
has been added to the -mm tree.  Its filename is
     pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI ACPI: fix uninitialized variable in __pci_osc_support_set
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

If the ACPI namespace doesn't have any device object corresponding to the
specified hid, 'retval' in __pci_osc_support_set() is not changed by the
acpi_query_osc() callback.  Since 'retval' is not initizlized in the current
implementation, the contents of 'retval' is undefined in this case.  This
causes a mis-handling of ctrlset_buf[OSC_SUPPORT_TYPE] and will cause an
unexpected result in the subsequent pci_osc_control_set() call as a result.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pci-acpi.c~pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set drivers/pci/pci-acpi.c
--- a/drivers/pci/pci-acpi.c~pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set
+++ a/drivers/pci/pci-acpi.c
@@ -166,7 +166,7 @@ run_osc_out:
 acpi_status __pci_osc_support_set(u32 flags, const char *hid)
 {
 	u32 temp;
-	acpi_status retval;
+	acpi_status retval = AE_NOT_FOUND;
 
 	if (!(flags & OSC_SUPPORT_MASKS)) {
 		return AE_TYPE;
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set.patch

