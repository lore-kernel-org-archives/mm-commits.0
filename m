From: akpm@linux-foundation.org
Subject: + cgroup-remove-unnecessary-0-check-from-css_from_id.patch added
 to -mm tree
Date: Tue, 21 Jun 2016 16:28:54 -0700
Message-ID: <5769cdb6.3pWBtD6F3vNO2R54%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbcFUXa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove unnecessary 0 check from css_from_id()
has been added to the -mm tree.  Its filename is
     cgroup-remove-unnecessary-0-check-from-css_from_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cgroup-remove-unnecessary-0-check-from-css_from_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cgroup-remove-unnecessary-0-check-from-css_from_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: cgroup: remove unnecessary 0 check from css_from_id()

css_idr allocation starts at 1, so index 0 will never point to an item. 
css_from_id() currently filters that before asking idr_find(), but
idr_find() would also just return NULL, so this is not needed.

Link: http://lkml.kernel.org/r/20160617162427.GC19084@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-remove-unnecessary-0-check-from-css_from_id kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-unnecessary-0-check-from-css_from_id
+++ a/kernel/cgroup.c
@@ -6162,7 +6162,7 @@ struct cgroup_subsys_state *css_tryget_o
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return id > 0 ? idr_find(&ss->css_idr, id) : NULL;
+	return idr_find(&ss->css_idr, id);
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

