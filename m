From: akpm@linux-foundation.org
Subject: [merged] mm-clarify-compaction-kconfig-text.patch removed from
 -mm tree
Date: Mon, 29 Aug 2016 12:51:27 -0700
Message-ID: <57c4923f.hhMvzBkcNFnVblMc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754185AbcH2Tv2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 15:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, js1304@gmail.com, markus@trippelsdorf.de, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify COMPACTION Kconfig text
has been removed from the -mm tree.  Its filename was
     mm-clarify-compaction-kconfig-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: clarify COMPACTION Kconfig text

The current wording of the COMPACTION Kconfig help text doesn't emphasise
that disabling COMPACTION might cripple the page allocator which relies on
the compaction quite heavily for high order requests and an unexpected OOM
can happen with the lack of compaction.  Make sure we are vocal about
that.

Link: http://lkml.kernel.org/r/20160823091726.GK23577@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-clarify-compaction-kconfig-text mm/Kconfig
--- a/mm/Kconfig~mm-clarify-compaction-kconfig-text
+++ a/mm/Kconfig
@@ -262,7 +262,14 @@ config COMPACTION
 	select MIGRATION
 	depends on MMU
 	help
-	  Allows the compaction of memory for the allocation of huge pages.
+          Compaction is the only memory management component to form
+          high order (larger physically contiguous) memory blocks
+          reliably. The page allocator relies on compaction heavily and
+          the lack of the feature can lead to unexpected OOM killer
+          invocations for high order memory requests. You shouldn't
+          disable this option unless there really is a strong reason for
+          it and then we would be really interested to hear about that at
+          linux-mm@kvack.org.
 
 #
 # support for page migration
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-prevent-pre-mature-oom-killer-invocation-for-high-order-request.patch
mm-vmscan-get-rid-of-throttle_vm_writeout.patch
oom-keep-mm-of-the-killed-task-available.patch
kernel-oom-fix-potential-pgd_lock-deadlock-from-__mmdrop.patch
mm-oom-get-rid-of-signal_struct-oom_victims.patch
oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly.patch
mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory.patch
oom-oom_reaper-allow-to-reap-mm-shared-by-the-kthreads.patch

