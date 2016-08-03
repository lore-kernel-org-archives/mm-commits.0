From: akpm@linux-foundation.org
Subject: [merged]
 kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:46 -0700
Message-ID: <57a2345a.NAGWfLF2d/VrdsQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbcHCSNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: arrange for paddr_vmcoreinfo_note() to return phys_addr_t
has been removed from the -mm tree.  Its filename was
     kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: kdump: arrange for paddr_vmcoreinfo_note() to return phys_addr_t

On PAE systems (eg, ARM LPAE) the vmcore note may be located above 4GB
physical on 32-bit architectures, so we need a wider type than "unsigned
long" here.  Arrange for paddr_vmcoreinfo_note() to return a phys_addr_t,
thereby allowing it to be located above 4GB.

This makes no difference for kexec-tools, as they already assume a 64-bit
type when reading from this file.

Link: http://lkml.kernel.org/r/E1b8koK-0004HS-K9@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Reviewed-by: Pratyush Anand <panand@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/machine_kexec.c |    2 +-
 include/linux/kexec.h            |    2 +-
 kernel/kexec_core.c              |    2 +-
 kernel/ksysfs.c                  |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/machine_kexec.c~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -163,7 +163,7 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 }
 
-unsigned long paddr_vmcoreinfo_note(void)
+phys_addr_t paddr_vmcoreinfo_note(void)
 {
 	return ia64_tpa((unsigned long)(char *)&vmcoreinfo_note);
 }
diff -puN include/linux/kexec.h~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t
+++ a/include/linux/kexec.h
@@ -233,7 +233,7 @@ void crash_save_vmcoreinfo(void);
 void arch_crash_save_vmcoreinfo(void);
 __printf(1, 2)
 void vmcoreinfo_append_str(const char *fmt, ...);
-unsigned long paddr_vmcoreinfo_note(void);
+phys_addr_t paddr_vmcoreinfo_note(void);
 
 #define VMCOREINFO_OSRELEASE(value) \
 	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
diff -puN kernel/kexec_core.c~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t kernel/kexec_core.c
--- a/kernel/kexec_core.c~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t
+++ a/kernel/kexec_core.c
@@ -1372,7 +1372,7 @@ void vmcoreinfo_append_str(const char *f
 void __weak arch_crash_save_vmcoreinfo(void)
 {}
 
-unsigned long __weak paddr_vmcoreinfo_note(void)
+phys_addr_t __weak paddr_vmcoreinfo_note(void)
 {
 	return __pa((unsigned long)(char *)&vmcoreinfo_note);
 }
diff -puN kernel/ksysfs.c~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t kernel/ksysfs.c
--- a/kernel/ksysfs.c~kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t
+++ a/kernel/ksysfs.c
@@ -128,8 +128,8 @@ KERNEL_ATTR_RW(kexec_crash_size);
 static ssize_t vmcoreinfo_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lx %x\n",
-		       paddr_vmcoreinfo_note(),
+	phys_addr_t vmcore_base = paddr_vmcoreinfo_note();
+	return sprintf(buf, "%pa %x\n", &vmcore_base,
 		       (unsigned int)sizeof(vmcoreinfo_note));
 }
 KERNEL_ATTR_RO(vmcoreinfo);
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are


