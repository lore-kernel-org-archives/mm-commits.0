From: akpm@linux-foundation.org
Subject: [patch 2/8] revert "ARM: keystone: dts: add psci command
 definition"
Date: Wed, 10 Aug 2016 16:27:41 -0700
Message-ID: <57abb86d.VBvp0mDyXL2020pp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcHJX1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 19:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, linux@armlinux.org.uk, vitalya@ti.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "ARM: keystone: dts: add psci command definition"

Revert 51d5d12b8f3d ("ARM: keystone: dts: add psci command definition"),
which was inadvertently added twice.

Cc: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/keystone.dtsi |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/arm/boot/dts/keystone.dtsi~revert-arm-keystone-dts-add-psci-command-definition arch/arm/boot/dts/keystone.dtsi
--- a/arch/arm/boot/dts/keystone.dtsi~revert-arm-keystone-dts-add-psci-command-definition
+++ a/arch/arm/boot/dts/keystone.dtsi
@@ -70,14 +70,6 @@
 		cpu_on		= <0x84000003>;
 	};
 
-	psci {
-		compatible	= "arm,psci";
-		method		= "smc";
-		cpu_suspend	= <0x84000001>;
-		cpu_off		= <0x84000002>;
-		cpu_on		= <0x84000003>;
-	};
