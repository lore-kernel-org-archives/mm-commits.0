From: akpm@linux-foundation.org
Subject: +
 memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy.patch added to -mm tree
Date: Tue, 03 Mar 2015 12:41:42 -0800
Message-ID: <54f61c86.vOP0WF5/vlc0jFrk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbbCCUln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 15:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: disable hierarchy support if bound to the legacy cgroup hierarchy
has been added to the -mm tree.  Its filename is
     memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: disable hierarchy support if bound to the legacy cgroup hierarchy

If the memory cgroup controller is initially mounted in the scope of the
default cgroup hierarchy and then remounted to a legacy hierarchy, it will
still have hierarchy support enabled, which is incorrect.  We should
disable hierarchy support if bound to the legacy cgroup hierarchy.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy
+++ a/mm/memcontrol.c
@@ -5232,7 +5232,9 @@ static void mem_cgroup_bind(struct cgrou
 	 * on for the root memcg is enough.
 	 */
 	if (cgroup_on_dfl(root_css->cgroup))
-		mem_cgroup_from_css(root_css)->use_hierarchy = true;
+		root_mem_cgroup->use_hierarchy = true;
+	else
+		root_mem_cgroup->use_hierarchy = false;
 }
 
 static u64 memory_current_read(struct cgroup_subsys_state *css,
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-disable-hierarchy-support-if-bound-to-the-legacy-cgroup-hierarchy.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch

