From: akpm@linux-foundation.org
Subject: + memremap-check-pfn-validity-before-passing-to-pfn_to_page.patch added to -mm tree
Date: Mon, 07 Mar 2016 15:03:01 -0800
Message-ID: <56de08a5.ZC/UBMKlSU4l842n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbcCGXDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2016 18:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memremap: check pfn validity before passing to pfn_to_page()
has been added to the -mm tree.  Its filename is
     memremap-check-pfn-validity-before-passing-to-pfn_to_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memremap-check-pfn-validity-before-passing-to-pfn_to_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memremap-check-pfn-validity-before-passing-to-pfn_to_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: memremap: check pfn validity before passing to pfn_to_page()

In memremap's helper function try_ram_remap(), we dereference a struct
page pointer that was derived from a PFN that is known to be covered by a
'System RAM' iomem region, and is thus assumed to be a 'valid' PFN, i.e.,
a PFN that has a struct page associated with it and is covered by the
kernel direct mapping.

However, the assumption that there is a 1:1 relation between the System RAM
iomem region and the kernel direct mapping is not universally valid on all
architectures, and on ARM and arm64, 'System RAM' may include regions for
which pfn_valid() returns false.

Generally speaking, both __va() and pfn_to_page() should only ever be
called on PFNs/physical addresses for which pfn_valid() returns true, so
add that check to try_ram_remap().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/memremap.c~memremap-check-pfn-validity-before-passing-to-pfn_to_page kernel/memremap.c
--- a/kernel/memremap.c~memremap-check-pfn-validity-before-passing-to-pfn_to_page
+++ a/kernel/memremap.c
@@ -29,10 +29,10 @@ __weak void __iomem *ioremap_cache(resou
 
 static void *try_ram_remap(resource_size_t offset, size_t size)
 {
-	struct page *page = pfn_to_page(offset >> PAGE_SHIFT);
+	unsigned long pfn = PHYS_PFN(offset);
 
 	/* In the simple case just return the existing linear address */
-	if (!PageHighMem(page))
+	if (pfn_valid(pfn) && !PageHighMem(pfn_to_page(pfn)))
 		return __va(offset);
 	return NULL; /* fallback to ioremap_cache */
 }
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

memremap-check-pfn-validity-before-passing-to-pfn_to_page.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch

