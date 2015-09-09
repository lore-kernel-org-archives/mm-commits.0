From: akpm@linux-foundation.org
Subject: [merged] memcg-move-memcg_proto_active-from-sockh.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:45:54 -0700
Message-ID: <55f08c72.ngdDgvwRXsjUhFak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move memcg_proto_active from sock.h
has been removed from the -mm tree.  Its filename was
     memcg-move-memcg_proto_active-from-sockh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: move memcg_proto_active from sock.h

The only user is sock_update_memcg which is living in memcontrol.c so it
doesn't make much sense to pollute sock.h by this inline helper.  Move it
to memcontrol.c and open code it into its only caller.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |    5 -----
 mm/memcontrol.c    |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/net/sock.h~memcg-move-memcg_proto_active-from-sockh include/net/sock.h
--- a/include/net/sock.h~memcg-move-memcg_proto_active-from-sockh
+++ a/include/net/sock.h
@@ -1045,11 +1045,6 @@ struct proto {
 int proto_register(struct proto *prot, int alloc_slab);
 void proto_unregister(struct proto *prot);
 
-static inline bool memcg_proto_active(struct cg_proto *cg_proto)
-{
-	return test_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
-}
