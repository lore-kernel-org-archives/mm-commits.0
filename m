From: akpm@linux-foundation.org
Subject: [merged]
 mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:39:15 -0700
Message-ID: <56f03fd3.xjFodRQsQGICalrC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbcCUT4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: remove redundant arch depend for memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm/Kconfig: remove redundant arch depend for memory hotplug

MEMORY_HOTPLUG already depends on ARCH_ENABLE_MEMORY_HOTPLUG which is selected
by the supported architectures, so the following arch depend is unnecessary.

Signed-off-by: Yang Shi <yang.shi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/Kconfig~mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug mm/Kconfig
--- a/mm/Kconfig~mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug
+++ a/mm/Kconfig
@@ -187,7 +187,6 @@ config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
-	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
 
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
_

Patches currently in -mm which might be from yang.shi@linaro.org are


