From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch
 added to -mm tree
Date: Sat, 07 Mar 2020 15:04:39 -0800
Message-ID: <20200307230439.wcH_oozpw%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGXEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 18:04:42 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: mm/memory_hotplug: drop the flags field from struct mhp_restrictions
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch

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
Subject: mm/memory_hotplug: drop the flags field from struct mhp_restrictions

Patch series "Allow setting caching mode in arch_add_memory() for P2PDMA", v4.

Currently, the page tables created using memremap_pages() are always
created with the PAGE_KERNEL cacheing mode.  However, the P2PDMA code is
creating pages for PCI BAR memory which should never be accessed through
the cache and instead use either WC or UC.  This still works in most
cases, on x86, because the MTRR registers typically override the caching
settings in the page tables for all of the IO memory to be UC-.  However,
this tends not to work so well on other arches or some rare x86 machines
that have firmware which does not setup the MTRR registers in this way.

Instead of this, this series proposes a change to arch_add_memory() to
take the pgprot required by the mapping which allows us to explicitly set
pagetable entries for P2PDMA memory to UC.

This changes is pretty routine for most of the arches: x86_64, arm64 and
powerpc simply need to thread the pgprot through to where the page tables
are setup.  x86_32 unfortunately sets up the page tables at boot so must
use _set_memory_prot() to change their caching mode.  ia64, s390 and sh
don't appear to have an easy way to change the page tables so, for now at
least, we just return -EINVAL on such mappings and thus they will not
support P2PDMA memory until the work for this is done.  This should be
fine as they don't yet support ZONE_DEVICE.


This patch (of 7):

This variable is not used anywhere and should therefore be removed from
the structure.

Link: http://lkml.kernel.org/r/20200306170846.9333-2-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Badger <ebadger@gigaio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions
+++ a/include/linux/memory_hotplug.h
@@ -55,11 +55,9 @@ enum {
 
 /*
  * Restrictions for the memory hotplug:
- * flags:  MHP_ flags
  * altmap: alternative allocator for memmap array
  */
 struct mhp_restrictions {
-	unsigned long flags;
 	struct vmem_altmap *altmap;
 };
 
_

Patches currently in -mm which might be from logang@deltatee.com are

mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch
mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params.patch
x86-mm-thread-pgprot_t-through-init_memory_mapping.patch
x86-mm-introduce-__set_memory_prot.patch
powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch
mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch
mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc.patch
