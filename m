From: akpm@linux-foundation.org
Subject: + memcg-move-memcg_proto_active-from-sockh.patch added to -mm
 tree
Date: Mon, 27 Jul 2015 14:35:42 -0700
Message-ID: <55b6a42e.l+77s2uLU9UkCv/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbbG0Vfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 17:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move memcg_proto_active from sock.h
has been added to the -mm tree.  Its filename is
     memcg-move-memcg_proto_active-from-sockh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-move-memcg_proto_active-from-sockh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-move-memcg_proto_active-from-sockh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1043,11 +1043,6 @@ struct proto {
 int proto_register(struct proto *prot, int alloc_slab);
 void proto_unregister(struct proto *prot);
 
-static inline bool memcg_proto_active(struct cg_proto *cg_proto)
-{
-	return test_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
-}
