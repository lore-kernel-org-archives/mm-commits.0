From: akpm@linux-foundation.org
Subject: [patch 125/126] cgroup: remove unnecessary 0 check from
 css_from_id()
Date: Tue, 26 Jul 2016 15:27:01 -0700
Message-ID: <5797e3b5.Lw7KVk+veQhDSb97%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbcGZW1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com

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
@@ -6166,7 +6166,7 @@ struct cgroup_subsys_state *css_tryget_o
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return id > 0 ? idr_find(&ss->css_idr, id) : NULL;
+	return idr_find(&ss->css_idr, id);
 }
 
 /**
_
