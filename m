From: akpm@linux-foundation.org
Subject: [patch 3/4] kdump: write correct address of mem_section into
 vmcoreinfo
Date: Fri, 12 Jan 2018 16:53:14 -0800
Message-ID: <5a59587a.F8K1GJ56CkWG4+hU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965265AbeAMAxQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 19:53:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, bhe@redhat.com, dyoung@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@redhat.com, stable@vger.kernel.org, tglx@linutronix.de, vgoyal@redhat.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: kdump: write correct address of mem_section into vmcoreinfo

Depending on configuration mem_section can now be an array or a pointer to
an array allocated dynamically.  In most cases, we can continue to refer
to it as 'mem_section' regardless of what it is.

But there's one exception: '&mem_section' means "address of the array" if
mem_section is an array, but if mem_section is a pointer, it would mean
"address of the pointer".

We've stepped onto this in kdump code.  VMCOREINFO_SYMBOL(mem_section)
writes down address of pointer into vmcoreinfo, not array as we wanted.

Let's introduce VMCOREINFO_SYMBOL_ARRAY() that would handle the situation
correctly for both cases.

Link: http://lkml.kernel.org/r/20180112162532.35896-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |    2 ++
 kernel/crash_core.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/crash_core.h~kdump-write-a-correct-address-of-mem_section-into-vmcoreinfo include/linux/crash_core.h
--- a/include/linux/crash_core.h~kdump-write-a-correct-address-of-mem_section-into-vmcoreinfo
+++ a/include/linux/crash_core.h
@@ -42,6 +42,8 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
+#define VMCOREINFO_SYMBOL_ARRAY(name) \
+	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)name)
 #define VMCOREINFO_SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
 			      (unsigned long)sizeof(name))
diff -puN kernel/crash_core.c~kdump-write-a-correct-address-of-mem_section-into-vmcoreinfo kernel/crash_core.c
--- a/kernel/crash_core.c~kdump-write-a-correct-address-of-mem_section-into-vmcoreinfo
+++ a/kernel/crash_core.c
@@ -410,7 +410,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
 #ifdef CONFIG_SPARSEMEM
-	VMCOREINFO_SYMBOL(mem_section);
+	VMCOREINFO_SYMBOL_ARRAY(mem_section);
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
_
