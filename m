From: akpm@linux-foundation.org
Subject: - agp-add-a-missing-via-agp-module-alias.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:05 -0700
Message-ID: <200806232102.m5NL25ck016046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbYFWVC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     agp: add a missing via-agp module alias
has been removed from the -mm tree.  Its filename was
     agp-add-a-missing-via-agp-module-alias.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agp: add a missing via-agp module alias
From: Dave Jones <davej@redhat.com>

Whilst trying to discern what could possibly be in the
no-source-provided version of via-agp that VIA are distributing on
linux.via.com.tw, I noticed in the modinfo output that they supported
an extra alias.

Further digging revealed it was for PCI ID 0x0364, which we added in
commit 32ddef98f232585f20bc8bdb891029a6a5f633d0 last year, but we
didn't add the corresponding entry in the pci_device_id table, so it
doesn't get auto-loaded on that hardware.

[hopefully this is the only difference between kernel.org, and their
 binary-only variant. Without the source, it's hard to tell. Sigh. ]

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/via-agp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/agp/via-agp.c~agp-add-a-missing-via-agp-module-alias drivers/char/agp/via-agp.c
--- a/drivers/char/agp/via-agp.c~agp-add-a-missing-via-agp-module-alias
+++ a/drivers/char/agp/via-agp.c
@@ -548,6 +548,7 @@ static const struct pci_device_id agp_vi
 	ID(PCI_DEVICE_ID_VIA_VT3324),
 	ID(PCI_DEVICE_ID_VIA_VT3336),
 	ID(PCI_DEVICE_ID_VIA_P4M890),
+	ID(PCI_DEVICE_ID_VIA_VT3364),
 	{ }
 };
 
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
list-debugging-use-warn_on-instead-of-bug.patch

