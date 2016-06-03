From: akpm@linux-foundation.org
Subject: + arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch
 added to -mm tree
Date: Fri, 03 Jun 2016 14:15:51 -0700
Message-ID: <5751f387.z3gNh+Xmr7W5IYse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbcFCVPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: kdump: advertise boot aliased crash kernel resource
has been added to the -mm tree.  Its filename is
     arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1006,9 +1006,25 @@ static void __init reserve_crashkernel(v
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

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch
arm-kexec-advertise-location-of-bootable-ram.patch
kexec-dont-invoke-oom-killer-for-control-page-allocation.patch
kexec-ensure-user-memory-sizes-do-not-wrap.patch
kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t.patch
kexec-allow-architectures-to-override-boot-mapping.patch
arm-kexec-fix-kexec-for-keystone-2.patch

