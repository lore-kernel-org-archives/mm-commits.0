From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-config_deferred_struct_page_init-depends-on-flatmem-explicitly.patch removed from -mm tree
Date: Fri, 27 May 2016 11:45:22 -0700
Message-ID: <574895c2.a5fgzJgU9eiqTZop%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make CONFIG_DEFERRED_STRUCT_PAGE_INIT depends on !FLATMEM explicitly
has been removed from the -mm tree.  Its filename was
     mm-make-config_deferred_struct_page_init-depends-on-flatmem-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: make CONFIG_DEFERRED_STRUCT_PAGE_INIT depends on !FLATMEM explicitly

Per the suggestion from Michal Hocko [1], DEFERRED_STRUCT_PAGE_INIT
requires some ordering wrt other initialization operations, e.g. 
page_ext_init has to happen after the whole memmap is initialized
properly.  For SPARSEMEM this requires to wait for page_alloc_init_late. 
Other memory models (e.g.  flatmem) might have different initialization
layouts (page_ext_init_flatmem).  Currently DEFERRED_STRUCT_PAGE_INIT
depends on MEMORY_HOTPLUG which in turn

	depends on SPARSEMEM || X86_64_ACPI_NUMA
	depends on ARCH_ENABLE_MEMORY_HOTPLUG

and X86_64_ACPI_NUMA depends on NUMA which in turn disable FLATMEM memory
model:

config ARCH_FLATMEM_ENABLE
	def_bool y
	depends on X86_32 && !NUMA

so FLATMEM is ruled out via dependency maze.  Be explicit and disable
FLATMEM for DEFERRED_STRUCT_PAGE_INIT so that we do not reintroduce subtle
initialization bugs

[1] http://lkml.kernel.org/r/20160523073157.GD2278@dhcp22.suse.cz

Link: http://lkml.kernel.org/r/1464027356-32282-1-git-send-email-yang.shi@linaro.org
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~mm-make-config_deferred_struct_page_init-depends-on-flatmem-explicitly mm/Kconfig
--- a/mm/Kconfig~mm-make-config_deferred_struct_page_init-depends-on-flatmem-explicitly
+++ a/mm/Kconfig
@@ -649,6 +649,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 	default n
 	depends on ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	depends on MEMORY_HOTPLUG
+	depends on !FLATMEM
 	help
 	  Ordinarily all struct pages are initialised during early boot in a
 	  single thread. On very large machines this can take a considerable
_

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-use-early_pfn_to_nid-in-page_ext_init.patch
mm-use-early_pfn_to_nid-in-register_page_bootmem_info_node.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

