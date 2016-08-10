From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch added to -mm tree
Date: Wed, 10 Aug 2016 15:26:39 -0700
Message-ID: <57abaa1f.Vfd02uUwQlCYc51F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbcHJW0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix

use WARN_ON_ONCE() in mem_cgroup_id_get_online()

Link: http://lkml.kernel.org/r/20160803123445.GJ13263@esperanza
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix
+++ a/mm/memcontrol.c
@@ -4089,7 +4089,7 @@ static struct mem_cgroup *mem_cgroup_id_
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
 		 */
-		if (memcg == root_mem_cgroup) {
+		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
 			VM_BUG_ON(1);
 			break;
 		}
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

