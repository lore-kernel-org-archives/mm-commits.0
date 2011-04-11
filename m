From: akpm@linux-foundation.org
Subject: [merged] pci-enable-aspm-state-clearing-regardless-of-policy.patch removed from -mm tree
Date: Mon, 11 Apr 2011 12:05:33 -0700
Message-ID: <201104111902.p3BJ2mVc028014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755518Ab1DKTD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 15:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, jbarnes@virtuousgeek.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pci: enable ASPM state clearing regardless of policy
has been removed from the -mm tree.  Its filename was
     pci-enable-aspm-state-clearing-regardless-of-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

