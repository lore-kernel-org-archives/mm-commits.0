From: akpm@linux-foundation.org
Subject: + memcg-move-mem_cgroup_is_root-upwards.patch added to -mm tree
Date: Tue, 18 Sep 2012 14:04:39 -0700
Message-ID: <20120918210439.A2D59100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43532 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab2IRVEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 17:04:41 -0400
Received: by vbis24 with SMTP id s24so44766vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 14:04:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, sachin.kamat@linaro.org


The patch titled
     Subject: memcg: move mem_cgroup_is_root upwards
has been added to the -mm tree.  Its filename is
     memcg-move-mem_cgroup_is_root-upwards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
