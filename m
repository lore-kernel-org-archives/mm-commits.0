From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-workingset-per-cgroup-cache-thrash-detection-fix.patch removed from -mm
 tree
Date: Tue, 15 Mar 2016 14:40:03 -0700
Message-ID: <56e88133.oRZDepa1PwemiAPT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcCOVkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:40:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-workingset-per-cgroup-cache-thrash-detection-fix
has been removed from the -mm tree.  Its filename was
     mm-workingset-per-cgroup-cache-thrash-detection-fix.patch

This patch was dropped because it was folded into mm-workingset-per-cgroup-cache-thrash-detection.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm-workingset-per-cgroup-cache-thrash-detection-fix

Do not return from workingset_activation() with locked rcu and page.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-per-cgroup-cache-thrash-detection-fix mm/workingset.c
--- a/mm/workingset.c~mm-workingset-per-cgroup-cache-thrash-detection-fix
+++ a/mm/workingset.c
@@ -317,9 +317,10 @@ void workingset_activation(struct page *
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
 	if (!mem_cgroup_disabled() && !memcg)
-		return;
+		goto out;
 	lruvec = mem_cgroup_zone_lruvec(page_zone(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
+out:
 	unlock_page_memcg(memcg);
 }
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-workingset-per-cgroup-cache-thrash-detection.patch

