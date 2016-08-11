From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch removed from -mm tree
Date: Thu, 11 Aug 2016 15:31:08 -0700
Message-ID: <57acfcac.plF3khKN8Q+dN2Mr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbcHKWbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 18:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch

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
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

