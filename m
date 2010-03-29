From: akpm@linux-foundation.org
Subject: + intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915.patch added to -mm tree
Date: Mon, 29 Mar 2010 18:40:49 -0400
Message-ID: <201003300141.o2U1fuaB018594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab0C3BmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Mar 2010 21:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miguel.ojeda.sandonis@gmail.com, David.Woodhouse@intel.com, airlied@linux.ie, eric@anholt.net, stable@kernel.org, zhenyuw@linux.intel.com


The patch titled
     intel-agp.c: fix crash when accessing nonexistent GTT entries in i915
has been added to the -mm tree.  Its filename is
     intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915.patch

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
Subject: intel-agp.c: fix crash when accessing nonexistent GTT entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Commit fc61901373987ad61851ed001fe971f3ee8d96a3 ("agp/intel-agp: Clear
entire GTT on startup") (included since 2.6.32.4) crashes (locks up) the
82915G/GV/910GL Controller when intel-agp.c tries to access nonexistent
GTT entries at:

-		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+		for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {

Rationale: I915 (gma900) has 128 MB of video memory (maximum), as per
intel.com (
http://www.intel.com/support/graphics/intel915g/sb/CS-012579.htm ) and
lscpi:

00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Device 4147
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ff480000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d8000000 (32-bit, prefetchable) [size=128M]
        Region 3: Memory at ff440000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: <access denied>

AFAIK, that implies that its gtt_total_size (in pages) should be 32K (as
num_entries showed before the commit) instead of 64K.

Note: The IS_I915 macro includes 945; however, only GMA900 (I915) had 128
MB as the maximum AFAIK.  Therefore, I divided the IS_I915 macro.  I do
not know about the "E7221" (please check).

How to reproduce: Access kernel.org in iceweasel (Debian Lenny) and the X
server will crash.  Sometimes, the kernel freezes.

The fix should be applied to stable series, as well as 2.6.33 and
2.6.34-rc1.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915
+++ a/drivers/char/agp/intel-agp.c
@@ -74,11 +74,11 @@ EXPORT_SYMBOL(intel_agp_enabled);
 #define PCI_DEVICE_ID_INTEL_SANDYBRIDGE_M_HB  0x0104
 #define PCI_DEVICE_ID_INTEL_SANDYBRIDGE_M_IG  0x0106
 
-/* cover 915 and 945 variants */
 #define IS_I915 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
+		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
+
+#define IS_I945 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB)
 
@@ -824,14 +824,14 @@ static void intel_i830_init_gtt_entries(
 			break;
 		case I915_GMCH_GMS_STOLEN_48M:
 			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
+			if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries = MB(48) - KB(size);
 			else
 				gtt_entries = 0;
 			break;
 		case I915_GMCH_GMS_STOLEN_64M:
 			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
+			if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries = MB(64) - KB(size);
 			else
 				gtt_entries = 0;
@@ -1400,6 +1400,8 @@ static int intel_i915_create_gatt_table(
 
 	if (IS_G33)
 	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
+	else if (IS_I915)
+	    gtt_map_size = 128 * 1024; /* 128K on I915 */
 	intel_private.gtt = ioremap(temp2, gtt_map_size);
 	if (!intel_private.gtt)
 		return -ENOMEM;
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from miguel.ojeda.sandonis@gmail.com are

intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915.patch

