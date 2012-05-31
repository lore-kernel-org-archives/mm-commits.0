From: akpm@linux-foundation.org
Subject: [merged] memcg-make-threshold-index-in-the-right-position.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:11 -0700
Message-ID: <20120531191711.52E81A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49752 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981Ab2EaTRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:13 -0400
Received: by were53 with SMTP id e53so75912wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make threshold index in the right position
has been removed from the -mm tree.  Its filename was
     memcg-make-threshold-index-in-the-right-position.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: make threshold index in the right position

Index current_threshold may point to threshold that just equal to usage
after last call of __mem_cgroup_threshold.  But after registering a new
event, it will change (pointing to threshold just below usage).  So make
it consistent here.

For example:
now:
	threshold array:  3  [5]  7  9   (usage = 6, [index] = 5)

next turn (after calling __mem_cgroup_threshold):
	threshold array:  3   5  [7]  9   (usage = 7, [index] = 7)

after registering a new event (threshold = 10):
	threshold array:  3  [5]  7  9  10 (usage = 7, [index] = 5)

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-threshold-index-in-the-right-position mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-threshold-index-in-the-right-position
+++ a/mm/memcontrol.c
@@ -181,7 +181,7 @@ struct mem_cgroup_threshold {
 
 /* For threshold */
 struct mem_cgroup_threshold_ary {
-	/* An array index points to threshold just below usage. */
+	/* An array index points to threshold just below or equal to usage. */
 	int current_threshold;
 	/* Size of entries[] */
 	unsigned int size;
@@ -4280,7 +4280,7 @@ static void __mem_cgroup_threshold(struc
 	usage = mem_cgroup_usage(memcg, swap);
 
 	/*
-	 * current_threshold points to threshold just below usage.
+	 * current_threshold points to threshold just below or equal to usage.
 	 * If it's not true, a threshold was crossed after last
 	 * call of __mem_cgroup_threshold().
 	 */
@@ -4406,14 +4406,15 @@ static int mem_cgroup_usage_register_eve
 	/* Find current threshold */
 	new->current_threshold = -1;
 	for (i = 0; i < size; i++) {
-		if (new->entries[i].threshold < usage) {
+		if (new->entries[i].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used until
 			 * rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
 			++new->current_threshold;
-		}
+		} else
+			break;
 	}
 
 	/* Free old spare buffer and save old primary buffer as spare */
@@ -4482,7 +4483,7 @@ static void mem_cgroup_usage_unregister_
 			continue;
 
 		new->entries[j] = thresholds->primary->entries[i];
-		if (new->entries[j].threshold < usage) {
+		if (new->entries[j].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used
 			 * until rcu_assign_pointer(), so it's safe to increment
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

