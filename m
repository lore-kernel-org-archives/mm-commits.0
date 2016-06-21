From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch
 added to -mm tree
Date: Tue, 21 Jun 2016 16:28:59 -0700
Message-ID: <5769cdbb.jZuZqCgpVNAJDW7L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbcFUXa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix cgroup creation failure after many small jobs fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

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
Subject: mm: memcontrol: fix cgroup creation failure after many small jobs fix

init the IDR

Link: http://lkml.kernel.org/r/20160621154601.GA22431@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix
+++ a/mm/memcontrol.c
@@ -4117,7 +4117,7 @@ static struct cftype mem_cgroup_legacy_f
  * those references are manageable from userspace.
  */
 
-static struct idr mem_cgroup_idr;
+static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_get(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch

