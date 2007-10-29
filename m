From: akpm@linux-foundation.org
Subject: + intel-iommu-fix-array-overflow.patch added to -mm tree
Date: Mon, 29 Oct 2007 00:55:50 -0700
Message-ID: <200710290755.l9T7toLH026290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbXJ2Hzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 03:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, anil.s.keshavamurthy@intel.com, mgross@linux.intel.com


The patch titled
     intel-iommu: Fix array overflow
has been added to the -mm tree.  Its filename is
     intel-iommu-fix-array-overflow.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: intel-iommu: Fix array overflow
=46rom: Takashi Iwai <tiwai@suse.de>

=46ix possible array overflow:

drivers/pci/intel-iommu.c: In function =A1dmar_get_fault_reason=A2:
drivers/pci/intel-iommu.c:753: warning: array subscript is above array =
bounds
drivers/pci/intel-iommu.c: In function =A1iommu_page_fault=A2:
drivers/pci/intel-iommu.c:753: warning: array subscript is above array =
bounds

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Mark Gross <mgross@linux.intel.com>
Acked-by: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-fix-array-overflow driv=
ers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-fix-array-overflow
+++ a/drivers/pci/intel-iommu.c
@@ -749,8 +749,8 @@ static char *fault_reason_strings[] =3D
=20
 char *dmar_get_fault_reason(u8 fault_reason)
 {
-	if (fault_reason > MAX_FAULT_REASON_IDX)
-		return fault_reason_strings[MAX_FAULT_REASON_IDX];
+	if (fault_reason >=3D MAX_FAULT_REASON_IDX)
+		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];
 	else
 		return fault_reason_strings[fault_reason];
 }
_

Patches currently in -mm which might be from tiwai@suse.de are

intel-iommu-fix-array-overflow.patch
git-alsa.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
pm-qos-infrastructure-and-interface.patch
latencyc-use-qos-infrastructure.patch
