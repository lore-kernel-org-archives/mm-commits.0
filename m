From: akpm@linux-foundation.org
Subject: [merged] thp-config_transparent_hugepage.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:47 -0800
Message-ID: <201101142249.p0EMnb1x005308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     thp-config_transparent_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: CONFIG_TRANSPARENT_HUGEPAGE
From: Andrea Arcangeli <aarcange@redhat.com>

Add config option.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN mm/Kconfig~thp-config_transparent_hugepage mm/Kconfig
--- a/mm/Kconfig~thp-config_transparent_hugepage
+++ a/mm/Kconfig
@@ -302,6 +302,20 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 	  See Documentation/nommu-mmap.txt for more information.
 
+config TRANSPARENT_HUGEPAGE
+	bool "Transparent Hugepage Support" if EMBEDDED
+	depends on X86_64 && MMU
+	default y
+	help
+	  Transparent Hugepages allows the kernel to use huge pages and
+	  huge tlb transparently to the applications whenever possible.
+	  This feature can improve computing performance to certain
+	  applications by speeding up page faults during memory
+	  allocation, by reducing the number of tlb misses and by speeding
+	  up the pagetable walking.
+
+	  If memory constrained on embedded, you may want to say N.
+
 #
 # UP and nommu archs use km based percpu allocator
 #
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

