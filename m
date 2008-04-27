From: akpm@linux-foundation.org
Subject: + mm-add-nr_writeback_temp-counter-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:33:42 -0700
Message-ID: <200804272033.m3RKXgrV023553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYD0UeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, mszeredi@suse.cz


The patch titled
     add vmstat_text for NR_WRITEBACK_TEMP
has been added to the -mm tree.  Its filename is
     mm-add-nr_writeback_temp-counter-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add vmstat_text for NR_WRITEBACK_TEMP
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Against:  2.6.25-rc8-mm2 [maybe also missing in '.25-mm1]

/proc/vmstat items after "nr_vmscan_write" are off-by-one
because of missing test for NR_WRITEBACK_TEMP that was added
to mmzone.h.

Apparently from:

	mm-add-nr_writeback_temp-counter.patch

in -mm tree.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~mm-add-nr_writeback_temp-counter-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_writeback_temp-counter-fix
+++ a/mm/vmstat.c
@@ -608,6 +608,7 @@ static const char * const vmstat_text[] 
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_writeback_temp",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
fix-indentation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch
mm-add-nr_writeback_temp-counter-fix.patch

