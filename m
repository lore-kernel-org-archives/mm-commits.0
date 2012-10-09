From: akpm@linux-foundation.org
Subject: [merged] memcg-move-mem_cgroup_is_root-upwards.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:29 -0700
Message-ID: <20121009181330.55B115C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52418 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2JISNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:32 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so364707wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move mem_cgroup_is_root upwards
has been removed from the -mm tree.  Its filename was
     memcg-move-mem_cgroup_is_root-upwards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: move mem_cgroup_is_root upwards

kmem code uses this function and it is better to not use forward
declarations for static inline functions as some (older) compilers don't
like it:

gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux)

mm/memcontrol.c:421: warning: `mem_cgroup_is_root' declared inline after being called
mm/memcontrol.c:421: warning: previous declaration of `mem_cgroup_is_root' was here

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-mem_cgroup_is_root-upwards mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-mem_cgroup_is_root-upwards
+++ a/mm/memcontrol.c
@@ -412,10 +412,14 @@ struct mem_cgroup *mem_cgroup_from_css(s
 	return container_of(s, struct mem_cgroup, css);
 }
 
+static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+{
+	return (memcg == root_mem_cgroup);
+}
+
 /* Writing them here to avoid exposing memcg's inner layout */
 #if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 
-static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
 void sock_update_memcg(struct sock *sk)
 {
 	if (mem_cgroup_sockets_enabled) {
@@ -1011,11 +1015,6 @@ void mem_cgroup_iter_break(struct mem_cg
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
-{
-	return (memcg == root_mem_cgroup);
-}
