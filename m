From: akpm@linux-foundation.org
Subject: + mm-add-section_align_up-and-section_align_down-macro.patch added to -mm tree
Date: Thu, 19 May 2011 16:01:52 -0700
Message-ID: <201105192301.p4JN1qGG001247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140Ab1ESXC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 May 2011 19:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, konrad.wilk@oracle.com


The patch titled
     mm: add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro
has been added to the -mm tree.  Its filename is
     mm-add-section_align_up-and-section_align_down-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro
From: Daniel Kiper <dkiper@net-space.pl>

Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro which aligns given
pfn to upper section and lower section boundary accordingly.

Required for the latest memory hotplug support for the Xen balloon driver.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/mmzone.h~mm-add-section_align_up-and-section_align_down-macro include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-section_align_up-and-section_align_down-macro
+++ a/include/linux/mmzone.h
@@ -956,6 +956,9 @@ static inline unsigned long early_pfn_to
 #define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
 #define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
 
+#define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
+#define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
+
 struct page;
 struct page_cgroup;
 struct mem_section {
_

Patches currently in -mm which might be from dkiper@net-space.pl are

linux-next.patch
mm-remove-dependency-on-config_flatmem-from-online_page.patch
mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch
mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch
mm-add-section_align_up-and-section_align_down-macro.patch

