From: akpm@linux-foundation.org
Subject: + agp-add-a-missing-via-agp-module-alias.patch added to -mm tree
Date: Wed, 21 May 2008 14:26:56 -0700
Message-ID: <200805212126.m4LLQuHW001588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbYEUV1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     agp: add a missing via-agp module alias
has been added to the -mm tree.  Its filename is
     agp-add-a-missing-via-agp-module-alias.patch

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
agp-add-a-missing-via-agp-module-alias.patch
list-debugging-use-warn_on-instead-of-bug.patch

