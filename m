From: akpm@linux-foundation.org
Subject: [folded] rapidio-add-rapidio-documentation-v2.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:22:40 -0700
Message-ID: <201103232322.p2NNMeWX004503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWXXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, mporter@kernel.crashing.org, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     rapidio-add-rapidio-documentation-v2
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-documentation-v2.patch

This patch was dropped because it was folded into rapidio-add-rapidio-documentation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio-add-rapidio-documentation-v2
From: Alexandre Bounine <alexandre.bounine@idt.com>

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/sysfs.txt |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN Documentation/rapidio/sysfs.txt~rapidio-add-rapidio-documentation-v2 Documentation/rapidio/sysfs.txt
--- a/Documentation/rapidio/sysfs.txt~rapidio-add-rapidio-documentation-v2
+++ a/Documentation/rapidio/sysfs.txt
@@ -36,6 +36,10 @@ device_rev - returns the device revision
    asm_did - returns identifier for the assembly containing the device
    asm_rev - returns revision level of the assembly containing the device
    asm_vid - returns vendor identifier of the assembly containing the device
+   destid  - returns device destination ID assigned by the enumeration routine
+             (see 4.1 for switch specific details)
+   lprev   - returns name of previous device (switch) on the path to the device
+             that that owns this attribute
 
 In addition to the files listed above, each device has a binary attribute file
 that allows read/write access to the device configuration registers using
@@ -66,9 +70,16 @@ set by the switch initialization routine
 
 4.1 Common Switch Attributes
 
- routes - reports switch routing information in "destID port" format. This
-          attribute reports only valid routing table entries, one line for
-          each entry.
+   routes - reports switch routing information in "destID port" format. This
+            attribute reports only valid routing table entries, one line for
+            each entry.
+   destid - device destination ID that defines a route to the switch
+ hopcount - number of hops on the path to the switch
+    lnext - returns names of devices linked to the switch except one of a device
+            linked to the ingress port (reported as "lprev"). This is an array
+            names with number of lines equal to number of ports in switch. If
+            a switch port has no attached device, returns "null" instead of
+            a device name.
 
 4.2 Device-specific Switch Attributes
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-new-sysfs-attributes.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch
rapidio-fix-potential-null-deref-on-failure-path.patch

