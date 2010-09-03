From: akpm@linux-foundation.org
Subject: + mm-avoid-warning-when-compaction-is-selected.patch added to -mm tree
Date: Fri, 03 Sep 2010 13:06:38 -0700
Message-ID: <201009032006.o83K6cic009630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab0ICUHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 16:07:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie


The patch titled
     mm: avoid warning when COMPACTION is selected
has been added to the -mm tree.  Its filename is
     mm-avoid-warning-when-compaction-is-selected.patch

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
Subject: mm: avoid warning when COMPACTION is selected
From: Andrea Arcangeli <aarcange@redhat.com>

COMPACTION enables MIGRATION, but MIGRATION spawns a warning if numa or
memhotplug aren't selected.  However MIGRATION doesn't depend on them.  I
guess it's just trying to be strict doing a double check on who's enabling
it, but it doesn't know that compaction also enables MIGRATION.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-avoid-warning-when-compaction-is-selected mm/Kconfig
--- a/mm/Kconfig~mm-avoid-warning-when-compaction-is-selected
+++ a/mm/Kconfig
@@ -189,7 +189,7 @@ config COMPACTION
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
+	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful in
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
mm-fix-swapin-race-condition.patch
mm-avoid-warning-when-compaction-is-selected.patch
define-madv_hugepage.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch

