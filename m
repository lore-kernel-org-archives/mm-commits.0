From: akpm@linux-foundation.org
Subject: [merged]
 cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:05 -0800
Message-ID: <569e990d.idi6Xmia3G3VyS1L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup, memcg, writeback: drop spurious rcu locking around mem_cgroup_css_from_page()
has been removed from the -mm tree.  Its filename was
     cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cgroup, memcg, writeback: drop spurious rcu locking around mem_cgroup_css_from_page()

In earlier versions, mem_cgroup_css_from_page() could return non-root css
on a legacy hierarchy which can go away and required rcu locking; however,
the eventual version simply returns the root cgroup if memcg is on a
legacy hierarchy and thus doesn't need rcu locking around or in it. 
Remove spurious rcu lockings.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 --
 mm/memcontrol.c   |    3 ---
 2 files changed, 5 deletions(-)

diff -puN fs/fs-writeback.c~cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page fs/fs-writeback.c
--- a/fs/fs-writeback.c~cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page
+++ a/fs/fs-writeback.c
@@ -677,9 +677,7 @@ void wbc_account_io(struct writeback_con
 	if (!wbc->wb)
 		return;
 
-	rcu_read_lock();
 	id = mem_cgroup_css_from_page(page)->id;
-	rcu_read_unlock();
 
 	if (id == wbc->wb_id) {
 		wbc->wb_bytes += bytes;
diff -puN mm/memcontrol.c~cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page
+++ a/mm/memcontrol.c
@@ -382,14 +382,11 @@ struct cgroup_subsys_state *mem_cgroup_c
 {
 	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
