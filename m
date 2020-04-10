From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 19/35] mm/memory_hotplug: drop the flags field
 from struct mhp_restrictions
Date: Fri, 10 Apr 2020 14:33:17 -0700
Message-ID: <20200410213317.ZZC8xOmnC%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVdS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:18 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, linux-mm@kvack.org, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org

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
@@ -59,11 +59,9 @@ enum {
 
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
