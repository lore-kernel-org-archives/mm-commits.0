From: akpm@linux-foundation.org
Subject: + memcg-make-threshold-index-in-the-right-position.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:08:10 -0700
Message-ID: <20120404220810.8BCA5A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:36673 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2DDWIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:08:12 -0400
Received: by vbnl22 with SMTP id l22so100222vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:08:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz


The patch titled
     Subject: memcg: make threshold index in the right position
has been added to the -mm tree.  Its filename is
     memcg-make-threshold-index-in-the-right-position.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/memcontrol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

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
@@ -4267,7 +4267,7 @@ static void __mem_cgroup_threshold(struc
 	usage = mem_cgroup_usage(memcg, swap);
 
 	/*
-	 * current_threshold points to threshold just below usage.
+	 * current_threshold points to threshold just below or equal to usage.
 	 * If it's not true, a threshold was crossed after last
 	 * call of __mem_cgroup_threshold().
 	 */
@@ -4393,14 +4393,15 @@ static int mem_cgroup_usage_register_eve
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
_
Subject: Subject: memcg: make threshold index in the right position

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-make-threshold-index-in-the-right-position.patch

