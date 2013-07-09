From: akpm@linux-foundation.org
Subject: [merged]
 memcg-do-not-account-memory-used-for-cache-creation.patch removed from -mm
 tree
Date: Tue, 09 Jul 2013 16:19:45 -0700
Message-ID: <51dc9a91.mSLcnPSmdfXlngzv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3GIXTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, glommer@gmail.com

Subject: [merged] memcg-do-not-account-memory-used-for-cache-creation.patch removed from -mm tree
To: glommer@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:45 -0700


The patch titled
     Subject: memcg: do not account memory used for cache creation
has been removed from the -mm tree.  Its filename was
     memcg-do-not-account-memory-used-for-cache-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: memcg: do not account memory used for cache creation

The memory we used to hold the memcg arrays is currently accounted to the
current memcg.  But that creates a problem, because that memory can only
be freed after the last user is gone.  Our only way to know which is the
last user, is to hook up to freeing time, but the fact that we still have
some in flight kmallocs will prevent freeing to happen.  I believe
therefore to be just easier to account this memory as global overhead.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-do-not-account-memory-used-for-cache-creation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-account-memory-used-for-cache-creation
+++ a/mm/memcontrol.c
@@ -5232,7 +5232,9 @@ static int memcg_propagate_kmem(struct m
 	static_key_slow_inc(&memcg_kmem_enabled_key);
 
 	mutex_lock(&set_limit_mutex);
+	memcg_stop_kmem_account();
 	ret = memcg_update_cache_sizes(memcg);
+	memcg_resume_kmem_account();
 	mutex_unlock(&set_limit_mutex);
 out:
 	return ret;
_

Patches currently in -mm which might be from glommer@gmail.com are

origin.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

