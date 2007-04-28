From: akpm@linux-foundation.org
Subject: - networking-bonding-documentation-fix-for-multiple-bonding-interfaces.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:54:00 -0700
Message-ID: <200704281054.l3SAs0C3020109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965714AbXD1Kyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Alexandra.Kossovsky@oktetlabs.ru, fubar@us.ibm.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     networking: bonding documentation fix for multiple bonding interfaces
has been removed from the -mm tree.  Its filename was
     networking-bonding-documentation-fix-for-multiple-bonding-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: networking: bonding documentation fix for multiple bonding interfaces
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>

Fix bonding driver documentation for the case of multiple bonding interfaces.

Signed-off-by: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Acked-by: Jay Vosburgh <fubar@us.ibm.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/bonding.txt |   35 +------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff -puN Documentation/networking/bonding.txt~networking-bonding-documentation-fix-for-multiple-bonding-interfaces Documentation/networking/bonding.txt
--- a/Documentation/networking/bonding.txt~networking-bonding-documentation-fix-for-multiple-bonding-interfaces
+++ a/Documentation/networking/bonding.txt
@@ -920,40 +920,9 @@ options, you may wish to use the "max_bo
 documented above.
 
 	To create multiple bonding devices with differing options, it
-is necessary to load the bonding driver multiple times.  Note that
-current versions of the sysconfig network initialization scripts
-handle this automatically; if your distro uses these scripts, no
-special action is needed.  See the section Configuring Bonding
-Devices, above, if you're not sure about your network initialization
-scripts.
-
-	To load multiple instances of the module, it is necessary to
-specify a different name for each instance (the module loading system
-requires that every loaded module, even multiple instances of the same
-module, have a unique name).  This is accomplished by supplying
-multiple sets of bonding options in /etc/modprobe.conf, for example:
-	
-alias bond0 bonding
-options bond0 -o bond0 mode=balance-rr miimon=100
-
-alias bond1 bonding
-options bond1 -o bond1 mode=balance-alb miimon=50
-
-	will load the bonding module two times.  The first instance is
-named "bond0" and creates the bond0 device in balance-rr mode with an
-miimon of 100.  The second instance is named "bond1" and creates the
-bond1 device in balance-alb mode with an miimon of 50.
-
-	In some circumstances (typically with older distributions),
-the above does not work, and the second bonding instance never sees
-its options.  In that case, the second options line can be substituted
-as follows:
-
-install bond1 /sbin/modprobe --ignore-install bonding -o bond1 \
-	mode=balance-alb miimon=50
+is necessary to use bonding parameters exported by sysfs, documented
+in the section below.
 
-	This may be repeated any number of times, specifying a new and
-unique name in place of bond1 for each subsequent instance.
 
 3.4 Configuring Bonding Manually via Sysfs
 ------------------------------------------
_

Patches currently in -mm which might be from Alexandra.Kossovsky@oktetlabs.ru are

origin.patch
