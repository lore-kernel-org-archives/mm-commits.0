From: akpm@linux-foundation.org
Subject: + arm-keystone-dts-add-psci-command-definition.patch added to -mm tree
Date: Fri, 03 Jun 2016 14:16:03 -0700
Message-ID: <5751f393.5VPQhy4m6bgMc5GZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbcFCVQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalya@ti.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, rmk+kernel@arm.linux.org.uk, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: keystone: dts: add psci command definition
has been added to the -mm tree.  Its filename is
     arm-keystone-dts-add-psci-command-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-keystone-dts-add-psci-command-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-keystone-dts-add-psci-command-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Andrianov <vitalya@ti.com>
Subject: ARM: keystone: dts: add psci command definition

This commit adds definition for cpu_on, cpu_off and cpu_suspend commands. 
These definitions must match the corresponding PSCI definitions in boot
monitor.

Having those command and corresponding PSCI support in boot monitor allows
run time CPU hot plugin.

Link: http://lkml.kernel.org/r/E1b8koV-0004Hf-2j@rmk-PC.armlinux.org.uk
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/keystone.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/arm/boot/dts/keystone.dtsi~arm-keystone-dts-add-psci-command-definition arch/arm/boot/dts/keystone.dtsi
--- a/arch/arm/boot/dts/keystone.dtsi~arm-keystone-dts-add-psci-command-definition
+++ a/arch/arm/boot/dts/keystone.dtsi
@@ -70,6 +70,14 @@
 		cpu_on		= <0x84000003>;
 	};
 
+	psci {
+		compatible	= "arm,psci";
+		method		= "smc";
+		cpu_suspend	= <0x84000001>;
+		cpu_off		= <0x84000002>;
+		cpu_on		= <0x84000003>;
+	};
+
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
_

Patches currently in -mm which might be from vitalya@ti.com are

arm-keystone-dts-add-psci-command-definition.patch

