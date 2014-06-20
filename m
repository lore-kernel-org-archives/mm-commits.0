From: akpm@linux-foundation.org
Subject: + memcg-remove-lookup_cgroup_page-prototype.patch added to -mm
 tree
Date: Fri, 20 Jun 2014 15:14:48 -0700
Message-ID: <53a4b258.PLibFKjiDsAIXW8P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, gthelen@google.com


The patch titled
     Subject: memcg: remove lookup_cgroup_page() prototype
has been added to the -mm tree.  Its filename is
     memcg-remove-lookup_cgroup_page-prototype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-lookup_cgroup_page-prototype.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-lookup_cgroup_page-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: remove lookup_cgroup_page() prototype

6b208e3f6e35 ("mm: memcg: remove unused node/section info from pc->flags")
deleted lookup_cgroup_page() but left a prototype for it.

Kill the vestigial prototype.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-lookup_cgroup_page-prototype include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-lookup_cgroup_page-prototype
+++ a/include/linux/page_cgroup.h
@@ -42,7 +42,6 @@ static inline void __init page_cgroup_in
 #endif
 
 struct page_cgroup *lookup_page_cgroup(struct page *page);
-struct page *lookup_cgroup_page(struct page_cgroup *pc);
 
 static inline int PageCgroupUsed(struct page_cgroup *pc)
 {
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-remove-lookup_cgroup_page-prototype.patch
memcg-deprecate-memoryforce_empty-knob.patch

