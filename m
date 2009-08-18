From: akpm@linux-foundation.org
Subject: + drm-via-add-pci-id-for-via-vx800-chipset.patch added to -mm tree
Date: Tue, 18 Aug 2009 14:52:51 -0700
Message-ID: <200908182152.n7ILqpIn025522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbZHRVxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 17:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.schlichter@web.de, airlied@redhat.com, alexdeucher@gmail.com, eric@anholt.net


The patch titled
     drm/via: add pci id for VIA VX800 chipset
has been added to the -mm tree.  Its filename is
     drm-via-add-pci-id-for-via-vx800-chipset.patch

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
Subject: drm/via: add pci id for VIA VX800 chipset
From: Thomas Schlichter <thomas.schlichter@web.de>

The VIA DRM module is able to accelerate 2D video on the VX800 chipset,
thus add the corresponding PCI ID.  Accelerated 3D video is not
implemented.

The modified VIA DRM module was tested with X.Org openchrome driver on a
Samsung NC20 netbook.  Video playback with xine requires nearly 30% less
CPU cycles.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drm_pciids.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/drm/drm_pciids.h~drm-via-add-pci-id-for-via-vx800-chipset include/drm/drm_pciids.h
--- a/include/drm/drm_pciids.h~drm-via-add-pci-id-for-via-vx800-chipset
+++ a/include/drm/drm_pciids.h
@@ -477,6 +477,7 @@
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
 	{0x1106, 0x3157, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
+	{0x1106, 0x1122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
 	{0, 0, 0}
 
 #define i810_PCI_IDS \
_

Patches currently in -mm which might be from thomas.schlichter@web.de are

drm-via-add-pci-id-for-via-vx800-chipset.patch

