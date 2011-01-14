From: akpm@linux-foundation.org
Subject: [merged] thp-select-config_compaction-if-transparent_hugepage-enabled.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:11 -0800
Message-ID: <201101142251.p0EMp1lD005460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab1ANWvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled
has been removed from the -mm tree.  Its filename was
     thp-select-config_compaction-if-transparent_hugepage-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled
From: Andrea Arcangeli <aarcange@redhat.com>

With transparent hugepage support we need compaction for the "defrag"
sysfs controls to be effective.

At the moment THP hangs the system if COMPACTION isn't selected, as
without COMPACTION lumpy reclaim wouldn't be entirely disabled.  So at the
moment it's not orthogonal.  When lumpy will be removed from the VM I can
remove the select COMPACTION in theory, but then 99% of THP users would be
still doing a mistake in disabling compaction, even if the mistake won't
return in fatal runtime but just slightly degraded performance.  So from a
theoretical standpoing forcing the below select is not needed (the
dependency isn't strict nor at compile time nor at runtime) but from a
practical standpoint it is safer.

If anybody really wants THP to run without compaction, it'd be such a
weird setup that editing the Kconfig file to allow it will be surely not a
problem.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~thp-select-config_compaction-if-transparent_hugepage-enabled mm/Kconfig
--- a/mm/Kconfig~thp-select-config_compaction-if-transparent_hugepage-enabled
+++ a/mm/Kconfig
@@ -305,6 +305,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on X86 && MMU
+	select COMPACTION
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
 	  huge tlb transparently to the applications whenever possible.
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

