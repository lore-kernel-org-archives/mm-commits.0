From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-introduce-__set_memory_prot.patch added to -mm
 tree
Date: Sat, 07 Mar 2020 15:04:51 -0800
Message-ID: <20200307230451.YuJua7SD7%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGXEx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 18:04:53 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: x86/mm: introduce __set_memory_prot()
has been added to the -mm tree.  Its filename is
     x86-mm-introduce-__set_memory_prot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-introduce-__set_memory_prot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-introduce-__set_memory_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Logan Gunthorpe <logang@deltatee.com>
Subject: x86/mm: introduce __set_memory_prot()

For use in the 32bit arch_add_memory() to set the pgprot type of the
memory to add.

Link: http://lkml.kernel.org/r/20200306170846.9333-5-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Badger <ebadger@gigaio.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/set_memory.h |    1 +
 arch/x86/mm/pat/set_memory.c      |   13 +++++++++++++
 2 files changed, 14 insertions(+)

--- a/arch/x86/include/asm/set_memory.h~x86-mm-introduce-__set_memory_prot
+++ a/arch/x86/include/asm/set_memory.h
@@ -34,6 +34,7 @@
  * The caller is required to take care of these.
  */
 
+int __set_memory_prot(unsigned long addr, int numpages, pgprot_t prot);
 int _set_memory_uc(unsigned long addr, int numpages);
 int _set_memory_wc(unsigned long addr, int numpages);
 int _set_memory_wt(unsigned long addr, int numpages);
--- a/arch/x86/mm/pat/set_memory.c~x86-mm-introduce-__set_memory_prot
+++ a/arch/x86/mm/pat/set_memory.c
@@ -1792,6 +1792,19 @@ static inline int cpa_clear_pages_array(
 		CPA_PAGES_ARRAY, pages);
 }
 
+/*
+ * _set_memory_prot is an internal helper for callers that have been passed
+ * a pgprot_t value from upper layers and a reservation has already been taken.
+ * If you want to set the pgprot to a specific page protocol, use the
+ * set_memory_xx() functions.
+ */
+int __set_memory_prot(unsigned long addr, int numpages, pgprot_t prot)
+{
+	return change_page_attr_set_clr(&addr, numpages, prot,
+					__pgprot(~pgprot_val(prot)), 0, 0,
+					NULL);
+}
+
 int _set_memory_uc(unsigned long addr, int numpages)
 {
 	/*
_

Patches currently in -mm which might be from logang@deltatee.com are

mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch
mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params.patch
x86-mm-thread-pgprot_t-through-init_memory_mapping.patch
x86-mm-introduce-__set_memory_prot.patch
powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch
mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch
mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc.patch
