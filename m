From: akpm@linux-foundation.org
Subject: + memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch added to -mm tree
Date: Thu, 05 Apr 2012 16:38:25 -0700
Message-ID: <20120405233825.BCDF2A04F2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57308 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2DEXi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 19:38:26 -0400
Received: by yenq2 with SMTP id q2so229944yen.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 16:38:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: handai.szj@taobao.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz


The patch titled
     Subject: memcg: revise the position of threshold index while unregistering event
has been added to the -mm tree.  Its filename is
     memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch

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
@@ -4470,7 +4470,7 @@ static void mem_cgroup_usage_unregister_
 			continue;
 
 		new->entries[j] = thresholds->primary->entries[i];
-		if (new->entries[j].threshold < usage) {
+		if (new->entries[j].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used
 			 * until rcu_assign_pointer(), so it's safe to increment
_
Subject: Subject: memcg: revise the position of threshold index while unregistering event

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch

