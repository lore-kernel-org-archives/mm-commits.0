From: akpm@linux-foundation.org
Subject: [patch 059/119] cgroup: revert fa06235b8eb0 ("cgroup:
 reset css on destruction")
Date: Wed, 06 Sep 2017 16:21:50 -0700
Message-ID: <20170906232150.zI4mdpmO9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50050 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753778AbdIFXVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: cgroup: revert fa06235b8eb0 ("cgroup: reset css on destruction")

fa06235b8eb0 ("cgroup: reset css on destruction") caused css_reset
callback to be called from the offlining path.  Although it solves the
problem mentioned in the commit description ("For instance, memory cgroup
needs to reset memory.low, otherwise pages charged to a dead cgroup might
never get reclaimed."), generally speaking, it's not correct.

An offline cgroup can still be a resource domain, and we shouldn't grant
it more resources than it had before deletion.

For instance, if an offline memory cgroup has dirty pages, we should still
imply i/o limits during writeback.

The css_reset callback is designed to return the cgroup state into the
original state, that means reset all limits and counters.  It's spomething
different from the offlining, and we shouldn't use it from the offlining
path.  Instead, we should adjust necessary settings from the
per-controller css_offline callbacks (e.g.  reset memory.low).

Link: http://lkml.kernel.org/r/20170727130428.28856-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/cgroup/cgroup.c~cgroup-revert-fa06235b8eb0-cgroup-reset-css-on-destruction kernel/cgroup/cgroup.c
--- a/kernel/cgroup/cgroup.c~cgroup-revert-fa06235b8eb0-cgroup-reset-css-on-destruction
+++ a/kernel/cgroup/cgroup.c
@@ -4100,9 +4100,6 @@ static void offline_css(struct cgroup_su
 	if (!(css->flags & CSS_ONLINE))
 		return;
 
-	if (ss->css_reset)
-		ss->css_reset(css);
