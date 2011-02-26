From: akpm@linux-foundation.org
Subject: + rapidio-add-rapidio-documentation-v2.patch added to -mm tree
Date: Fri, 25 Feb 2011 16:13:42 -0800
Message-ID: <201102260013.p1Q0DgLO005842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab1BZAOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Feb 2011 19:14:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, mporter@kernel.crashing.org, rdunlap@xenotime.net


The patch titled
     rapidio-add-rapidio-documentation-v2
has been added to the -mm tree.  Its filename is
     rapidio-add-rapidio-documentation-v2.patch

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

rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch

