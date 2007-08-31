From: akpm@linux-foundation.org
Subject: + drm-via-invalid-device-ids-removal.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:52:48 -0700
Message-ID: <200708311852.l7VIqrsa021659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965677AbXHaSxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xavier@bachelot.org, airlied@linux.ie


The patch titled
     drm: VIA invalid device IDs removal
has been added to the -mm tree.  Its filename is
     drm-via-invalid-device-ids-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drm: VIA invalid device IDs removal
From: Xavier Bachelot <xavier@bachelot.org>

0x1106, 0x7204 is unknown and thus is not an IGP/GPU.
0x1106, 0x3304 is K8M800 hostbridge, not an IGP/GPU.
None of them are in drm git tree.

Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_pciids.h |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/char/drm/drm_pciids.h~drm-via-invalid-device-ids-removal drivers/char/drm/drm_pciids.h
--- a/drivers/char/drm/drm_pciids.h~drm-via-invalid-device-ids-removal
+++ a/drivers/char/drm/drm_pciids.h
@@ -236,10 +236,8 @@
 	{0x1106, 0x3022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3118, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x7204, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x7205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x3304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3344, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
_

Patches currently in -mm which might be from xavier@bachelot.org are

drm-via-invalid-device-ids-removal.patch
