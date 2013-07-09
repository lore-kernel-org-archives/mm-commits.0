From: akpm@linux-foundation.org
Subject: [merged]
 revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:33 -0700
Message-ID: <51dc9ac1.THYpIhzUnJOKDlti%akpm__32848.5504178845$1373412096$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3GIXUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, lizefan@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, mhocko@suse.cz

Subject: [merged] revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch removed from -mm tree
To: mhocko@suse.cz,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,lizefan@huawei.com,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:33 -0700


The patch titled
     Subject: Revert "memcg: avoid dangling reference count in creation failure"
has been removed from the -mm tree.  Its filename was
     revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: Revert "memcg: avoid dangling reference count in creation failure"

This reverts e4715f01be697a.

mem_cgroup_put is hierarchy aware so mem_cgroup_put(memcg) already drops
an additional reference from all parents so the additional
mem_cgrroup_put(parent) potentially causes use-after-free.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~revert-memcg-avoid-dangling-reference-count-in-creation-failure mm/memcontrol.c
--- a/mm/memcontrol.c~revert-memcg-avoid-dangling-reference-count-in-creation-failure
+++ a/mm/memcontrol.c
@@ -6352,8 +6352,6 @@ mem_cgroup_css_online(struct cgroup *con
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
 	}
 	return error;
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
drop_caches-add-some-documentation-and-info-messsge.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch

