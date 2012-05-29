From: akpm@linux-foundation.org
Subject: [folded] memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch removed from -mm tree
Date: Tue, 29 May 2012 14:46:07 -0700
Message-ID: <20120529214607.6D47DA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60405 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2E2VqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:46:08 -0400
Received: by vbnl22 with SMTP id l22so455805vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:46:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: handai.szj@taobao.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: revise the position of threshold index while unregistering event
has been removed from the -mm tree.  Its filename was
     memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch

This patch was dropped because it was folded into memcg-make-threshold-index-in-the-right-position.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: revise the position of threshold index while unregistering event

Index current_threshold should point to threshold just below or equal to
usage.  See below: http://www.spinics.net/lists/cgroups/msg00844.html

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-revise-the-position-of-threshold-index-while-unregistering-event mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-revise-the-position-of-threshold-index-while-unregistering-event
+++ a/mm/memcontrol.c
@@ -4695,7 +4695,7 @@ static void mem_cgroup_usage_unregister_
 			continue;
 
 		new->entries[j] = thresholds->primary->entries[i];
-		if (new->entries[j].threshold < usage) {
+		if (new->entries[j].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used
 			 * until rcu_assign_pointer(), so it's safe to increment
_

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-make-threshold-index-in-the-right-position.patch

