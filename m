From: akpm@linux-foundation.org
Subject: + arm-kexec-fix-kexec-for-keystone-2.patch added to -mm tree
Date: Fri, 03 Jun 2016 14:16:06 -0700
Message-ID: <5751f396.NE6oHsYpdh3P9/uM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbcFCVQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: kexec: fix kexec for Keystone 2
has been added to the -mm tree.  Its filename is
     arm-kexec-fix-kexec-for-keystone-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-kexec-fix-kexec-for-keystone-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-kexec-fix-kexec-for-keystone-2.patch

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
Subject: ARM: kexec: fix kexec for Keystone 2

Provide kexec with the boot view of memory by overriding the normal kexec
translation functions added in a previous patch.  We also need to fix a
call to memblock in machine_kexec_prepare() so that we provide it with a
running-view physical address rather than a boot- view physical address.

Link: http://lkml.kernel.org/r/E1b8koa-0004Hl-Ey@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kexec.h    |   24 ++++++++++++++++++++++++
 arch/arm/kernel/machine_kexec.c |    2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff -puN arch/arm/include/asm/kexec.h~arm-kexec-fix-kexec-for-keystone-2 arch/arm/include/asm/kexec.h
--- a/arch/arm/include/asm/kexec.h~arm-kexec-fix-kexec-for-keystone-2
+++ a/arch/arm/include/asm/kexec.h
@@ -53,6 +53,30 @@ static inline void crash_setup_regs(stru
 /* Function pointer to optional machine-specific reinitialization */
 extern void (*kexec_reinit)(void);
 
+static inline unsigned long phys_to_boot_phys(phys_addr_t phys)
+{
+	return phys_to_idmap(phys);
+}
+#define phys_to_boot_phys phys_to_boot_phys
+
+static inline phys_addr_t boot_phys_to_phys(unsigned long entry)
+{
+	return idmap_to_phys(entry);
+}
+#define boot_phys_to_phys boot_phys_to_phys
+
+static inline unsigned long page_to_boot_pfn(struct page *page)
+{
+	return page_to_pfn(page) + (arch_phys_to_idmap_offset >> PAGE_SHIFT);
+}
+#define page_to_boot_pfn page_to_boot_pfn
+
+static inline struct page *boot_pfn_to_page(unsigned long boot_pfn)
+{
+	return pfn_to_page(boot_pfn - (arch_phys_to_idmap_offset >> PAGE_SHIFT));
+}
+#define boot_pfn_to_page boot_pfn_to_page
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* CONFIG_KEXEC */
diff -puN arch/arm/kernel/machine_kexec.c~arm-kexec-fix-kexec-for-keystone-2 arch/arm/kernel/machine_kexec.c
--- a/arch/arm/kernel/machine_kexec.c~arm-kexec-fix-kexec-for-keystone-2
+++ a/arch/arm/kernel/machine_kexec.c
@@ -57,7 +57,7 @@ int machine_kexec_prepare(struct kimage
 	for (i = 0; i < image->nr_segments; i++) {
 		current_segment = &image->segment[i];
 
-		if (!memblock_is_region_memory(current_segment->mem,
+		if (!memblock_is_region_memory(idmap_to_phys(current_segment->mem),
 					       current_segment->memsz))
 			return -EINVAL;
 
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch
arm-kexec-advertise-location-of-bootable-ram.patch
kexec-dont-invoke-oom-killer-for-control-page-allocation.patch
kexec-ensure-user-memory-sizes-do-not-wrap.patch
kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t.patch
kexec-allow-architectures-to-override-boot-mapping.patch
arm-kexec-fix-kexec-for-keystone-2.patch

