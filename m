From: akpm@linux-foundation.org
Subject: + memcg-do-not-account-memory-used-for-cache-creation.patch added to -mm tree
Date: Tue, 11 Jun 2013 14:08:17 -0700
Message-ID: <51b791c1.aL+PimGTEN9Ovn0v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3FKVIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 17:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, glommer@gmail.com

Subject: + memcg-do-not-account-memory-used-for-cache-creation.patch added to -mm tree
To: glommer@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 14:08:17 -0700


The patch titled
     Subject: memcg: do not account memory used for cache creation
has been added to the -mm tree.  Its filename is
     memcg-do-not-account-memory-used-for-cache-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch
memcg-do-not-account-memory-used-for-cache-creation.patch

