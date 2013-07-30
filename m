From: akpm@linux-foundation.org
Subject: +
 memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch added to
 -mm tree
Date: Tue, 30 Jul 2013 13:34:55 -0700
Message-ID: <51f8236f.KTrX5bZL7UJCvT8g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab3G3Ue4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 16:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, lizefan@huawei.com

Subject: + memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch added to -mm tree
To: lizefan@huawei.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 13:34:55 -0700


The patch titled
     Subject: memcg: remove redundant code in mem_cgroup_force_empty_write()
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: remove redundant code in mem_cgroup_force_empty_write()

vfs guarantees the cgroup won't be destroyed, so it's redundant to get a
css reference.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-code-in-mem_cgroup_force_empty_write mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-code-in-mem_cgroup_force_empty_write
+++ a/mm/memcontrol.c
@@ -5005,15 +5005,10 @@ static int mem_cgroup_force_empty(struct
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int ret;
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	css_get(&memcg->css);
-	ret = mem_cgroup_force_empty(memcg);
-	css_put(&memcg->css);
