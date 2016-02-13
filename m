From: akpm@linux-foundation.org
Subject: +
 mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch added to
 -mm tree
Date: Fri, 12 Feb 2016 16:00:21 -0800
Message-ID: <56be7215.sO19WonThlK47DmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcBMAAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Feb 2016 19:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: remove redundant arch depend for memory hotplug
has been added to the -mm tree.  Its filename is
     mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ubsan-cosmetic-fix-to-kconfig-text.patch
mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch

