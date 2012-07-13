From: akpm@linux-foundation.org
Subject: [folded] memcg-prevent-oom-with-too-many-dirty-pages-fix-fix.patch removed from -mm tree
Date: Fri, 13 Jul 2012 13:52:01 -0700
Message-ID: <20120713205201.679AA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:49524 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2GMUwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:52:02 -0400
Received: by yhl10 with SMTP id 10so386131yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:52:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: memcg: prevent from OOM with too many dirty pages
has been removed from the -mm tree.  Its filename was
     memcg-prevent-oom-with-too-many-dirty-pages-fix-fix.patch

This patch was dropped because it was folded into memcg-prevent-oom-with-too-many-dirty-pages.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: Re: memcg: prevent from OOM with too many dirty pages

On Wed, 11 Jul 2012, Andrew Morton wrote:
> On Wed, 11 Jul 2012 18:57:43 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
>
> > --- 3.5-rc6-mm1/mm/vmscan.c	2012-07-11 14:42:13.668335884 -0700
> > +++ linux/mm/vmscan.c	2012-07-11 16:01:20.712814127 -0700
> > @@ -726,7 +726,8 @@ static unsigned long shrink_page_list(st
> >  			 * writeback from reclaim and there is nothing else to
> >  			 * reclaim.
> >  			 */
> > -			if (!global_reclaim(sc) && PageReclaim(page))
> > +			if (!global_reclaim(sc) && PageReclaim(page) &&
> > +					may_enter_fs)
> >  				wait_on_page_writeback(page);
> >  			else {
> >  				nr_writeback++;
>
> um, that may_enter_fs test got removed because nobody knew why it was
> there.  Nobody knew why it was there because it was undocumented.  Do
> you see where I'm going with this?

I was hoping you might do that bit ;)  Here's my display of ignorance:


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmscan.c~memcg-prevent-oom-with-too-many-dirty-pages-fix-fix mm/vmscan.c
--- a/mm/vmscan.c~memcg-prevent-oom-with-too-many-dirty-pages-fix-fix
+++ a/mm/vmscan.c
@@ -725,6 +725,12 @@ static unsigned long shrink_page_list(st
 			 * could easily OOM just because too many pages are in
 			 * writeback from reclaim and there is nothing else to
 			 * reclaim.
+			 *
+			 * Check may_enter_fs, certainly because a loop driver
+			 * thread might enter reclaim, and deadlock if it waits
+			 * on a page for which it is needed to do the write
+			 * (loop masks off __GFP_IO|__GFP_FS for this reason);
+			 * but more thought would probably show more reasons.
 			 */
 			if (!global_reclaim(sc) && PageReclaim(page) &&
 					may_enter_fs)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
prio_tree-debugging-patch.patch

