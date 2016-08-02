From: akpm@linux-foundation.org
Subject: [patch 076/111] ARM: kdump: advertise boot aliased crash kernel
 resource
Date: Tue, 02 Aug 2016 14:05:48 -0700
Message-ID: <57a10b2c.tyPeu6H6rr8CAyGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbcHBVRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: ARM: kdump: advertise boot aliased crash kernel resource

Advertise a resource which describes where the crash kernel is located in
the boot view of RAM.  This allows kexec-tools to have this vital
information.

Link: http://lkml.kernel.org/r/E1b8knz-0004H4-Bd@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/arm/kernel/setup.c~arm-kdump-advertise-boot-aliased-crash-kernel-resource arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~arm-kdump-advertise-boot-aliased-crash-kernel-resource
+++ a/arch/arm/kernel/setup.c
@@ -1000,9 +1000,25 @@ static void __init reserve_crashkernel(v
 		(unsigned long)(crash_base >> 20),
 		(unsigned long)(total_mem >> 20));
 
+	/* The crashk resource must always be located in normal mem */
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 	insert_resource(&iomem_resource, &crashk_res);
+
+	if (arm_has_idmap_alias()) {
+		/*
+		 * If we have a special RAM alias for use at boot, we
+		 * need to advertise to kexec tools where the alias is.
+		 */
+		static struct resource crashk_boot_res = {
+			.name = "Crash kernel (boot alias)",
+			.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
+		};
+
+		crashk_boot_res.start = phys_to_idmap(crash_base);
+		crashk_boot_res.end = crashk_boot_res.start + crash_size - 1;
+		insert_resource(&iomem_resource, &crashk_boot_res);
+	}
 }
 #else
 static inline void reserve_crashkernel(void) {}
_
