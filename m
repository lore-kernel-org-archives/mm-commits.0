From: akpm@linux-foundation.org
Subject: [patch 077/111] ARM: kexec: advertise location of bootable RAM
Date: Tue, 02 Aug 2016 14:05:51 -0700
Message-ID: <57a10b2f.rfsDFZoGVn6vFqxN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbcHBVRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: ARM: kexec: advertise location of bootable RAM

Advertise the location of bootable RAM to kexec-tools.  kexec needs to
know where it can place the kernel in RAM, and so be executable when the
system needs to jump into it.

Advertise these areas in /proc/iomem with a "System RAM (boot alias)" tag.

Link: http://lkml.kernel.org/r/E1b8ko4-0004HA-GF@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Reviewed-by: Pratyush Anand <panand@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN arch/arm/kernel/setup.c~arm-kexec-advertise-location-of-bootable-ram arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~arm-kexec-advertise-location-of-bootable-ram
+++ a/arch/arm/kernel/setup.c
@@ -848,10 +848,29 @@ static void __init request_standard_reso
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
+		phys_addr_t start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
+		phys_addr_t end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
+		unsigned long boot_alias_start;
+
+		/*
+		 * Some systems have a special memory alias which is only
+		 * used for booting.  We need to advertise this region to
+		 * kexec-tools so they know where bootable RAM is located.
+		 */
+		boot_alias_start = phys_to_idmap(start);
+		if (arm_has_idmap_alias() && boot_alias_start != IDMAP_INVALID_ADDR) {
+			res = memblock_virt_alloc(sizeof(*res), 0);
+			res->name = "System RAM (boot alias)";
+			res->start = boot_alias_start;
+			res->end = phys_to_idmap(end);
+			res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+			request_resource(&iomem_resource, res);
+		}
+
 		res = memblock_virt_alloc(sizeof(*res), 0);
 		res->name  = "System RAM";
-		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
-		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
+		res->start = start;
+		res->end = end;
 		res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
 		request_resource(&iomem_resource, res);
_
