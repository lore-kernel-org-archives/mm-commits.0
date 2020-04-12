From: akpm@linux-foundation.org
Subject: [merged]
 mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc.patch removed from
 -mm tree
Date: Sat, 11 Apr 2020 23:45:34 -0700
Message-ID: <20200412064534.3qYPDPoHF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgDLGpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: mm/memremap: set caching mode for PCI P2PDMA memory to WC
has been removed from the -mm tree.  Its filename was
     mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Logan Gunthorpe <logang@deltatee.com>
Subject: mm/memremap: set caching mode for PCI P2PDMA memory to WC

PCI BAR IO memory should never be mapped as WB, however prior to this the
PAT bits were set WB and it was typically overridden by MTRR registers set
by the firmware.

Set PCI P2PDMA memory to be UC as this is what it currently, typically,
ends up being mapped as on x86 after the MTRR registers override the cache
setting.

Future use-cases may need to generalize this by adding flags to select the
caching type, as some P2PDMA cases may not want UC.  However, those
use-cases are not upstream yet and this can be changed when they arrive.

Link: http://lkml.kernel.org/r/20200306170846.9333-8-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Badger <ebadger@gigaio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memremap.c~mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc
+++ a/mm/memremap.c
@@ -217,7 +217,10 @@ void *memremap_pages(struct dev_pagemap
 		}
 		break;
 	case MEMORY_DEVICE_DEVDAX:
+		need_devmap_managed = false;
+		break;
 	case MEMORY_DEVICE_PCI_P2PDMA:
+		params.pgprot = pgprot_noncached(params.pgprot);
 		need_devmap_managed = false;
 		break;
 	default:
_

Patches currently in -mm which might be from logang@deltatee.com are
