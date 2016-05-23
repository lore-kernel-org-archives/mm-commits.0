From: akpm@linux-foundation.org
Subject: [merged]
 mm-increase-safety-margin-provided-by-pf_less_throttle.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:47:02 -0700
Message-ID: <57435e36.sbKef6sDxkcgE/Cp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbcEWTrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MM: increase safety margin provided by PF_LESS_THROTTLE
has been removed from the -mm tree.  Its filename was
     mm-increase-safety-margin-provided-by-pf_less_throttle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: MM: increase safety margin provided by PF_LESS_THROTTLE

When nfsd is exporting a filesystem over NFS which is then NFS-mounted on
the local machine there is a risk of deadlock.  This happens when there
are lots of dirty pages in the NFS filesystem and they cause NFSD to be
throttled, either in throttle_vm_writeout() or in balance_dirty_pages().

To avoid this problem the PF_LESS_THROTTLE flag is set for NFSD threads
and it provides a 25% increase to the limits that affect NFSD.  Any
process writing to an NFS filesystem will be throttled well before the
number of dirty NFS pages reaches the limit imposed on NFSD, so NFSD will
not deadlock on pages that it needs to write out.  At least it shouldn't.

All processes are allowed a small excess margin to avoid performing too
many calculations: ratelimit_pages.

ratelimit_pages is set so that if a thread on every CPU uses the entire
margin, the total will only go 3% over the limit, and this is much less
than the 25% bonus that PF_LESS_THROTTLE provides, so this margin
shouldn't be a problem.  But it is.

The "total memory" that these 3% and 25% are calculated against are not
really total memory but are "global_dirtyable_memory()" which doesn't
include anonymous memory, just free memory and page-cache memory.

The "ratelimit_pages" number is based on whatever the
global_dirtyable_memory was on the last CPU hot-plug, which might not be
what you expect, but is probably close to the total freeable memory.

The throttle threshold uses the global_dirtable_memory at the moment when
the throttling happens, which could be much less than at the last CPU
hotplug.  So if lots of anonymous memory has been allocated, thus pushing
out lots of page-cache pages, then NFSD might end up being throttled due
to dirty NFS pages because the "25%" bonus it gets is calculated against a
rather small amount of dirtyable memory, while the "3%" margin that other
processes are allowed to dirty without penalty is calculated against a
much larger number.

To remove this possibility of deadlock we need to make sure that the
margin granted to PF_LESS_THROTTLE exceeds that rate-limit margin.  Simply
adding ratelimit_pages isn't enough as that should be multiplied by the
number of cpus.

So add "global_wb_domain.dirty_limit / 32" as that more accurately
reflects the current total over-shoot margin.  This ensures that the
number of dirty NFS pages never gets so high that nfsd will be throttled
waiting for them to be written.

Link: http://lkml.kernel.org/r/87futgowwv.fsf@notabene.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-increase-safety-margin-provided-by-pf_less_throttle mm/page-writeback.c
--- a/mm/page-writeback.c~mm-increase-safety-margin-provided-by-pf_less_throttle
+++ a/mm/page-writeback.c
@@ -411,8 +411,8 @@ static void domain_dirty_limits(struct d
 		bg_thresh = thresh / 2;
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
-		bg_thresh += bg_thresh / 4;
-		thresh += thresh / 4;
+		bg_thresh += bg_thresh / 4 + global_wb_domain.dirty_limit / 32;
+		thresh += thresh / 4 + global_wb_domain.dirty_limit / 32;
 	}
 	dtc->thresh = thresh;
 	dtc->bg_thresh = bg_thresh;
_

Patches currently in -mm which might be from neilb@suse.com are

dax-move-radix_dax_-definitions-to-daxc.patch

