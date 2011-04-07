From: akpm@linux-foundation.org
Subject: + pci-enable-aspm-state-clearing-regardless-of-policy.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:23:15 -0700
Message-ID: <201104072223.p37MNFAj003797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414Ab1DGWXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.williamson@redhat.com, jbarnes@virtuousgeek.org, mjg@redhat.com


The patch titled
     pci: enable ASPM state clearing regardless of policy
has been added to the -mm tree.  Its filename is
     pci-enable-aspm-state-clearing-regardless-of-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: enable ASPM state clearing regardless of policy
From: Alex Williamson <alex.williamson@redhat.com>

Commit 2f671e2d ("PCI: Disable ASPM if BIOS asks us to") allowed us to
clear ASPM state when the FADT tells us it isn't supported, but we don't
put this into effect if the aspm_policy is set to POLICY_POWERSAVE. 
Enable the state to be cleared regardless of policy.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aspm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pcie/aspm.c~pci-enable-aspm-state-clearing-regardless-of-policy drivers/pci/pcie/aspm.c
--- a/drivers/pci/pcie/aspm.c~pci-enable-aspm-state-clearing-regardless-of-policy
+++ a/drivers/pci/pcie/aspm.c
@@ -608,7 +608,7 @@ void pcie_aspm_init_link_state(struct pc
 	 * the BIOS's expectation, we'll do so once pci_enable_device() is
 	 * called.
 	 */
-	if (aspm_policy != POLICY_POWERSAVE) {
+	if (aspm_policy != POLICY_POWERSAVE || aspm_clear_state) {
 		pcie_config_aspm_path(link);
 		pcie_set_clkpm(link, policy_to_clkpm_state(link));
 	}
_

Patches currently in -mm which might be from alex.williamson@redhat.com are

linux-next.patch
pci-enable-aspm-state-clearing-regardless-of-policy.patch

