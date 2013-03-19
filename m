From: akpm@linux-foundation.org
Subject: + memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:02:29 -0700
Message-ID: <20130319210229.792CB31C1D1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33219 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3CSVCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:02:30 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so100730qaj.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:02:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org


The patch titled
     Subject: memcg: do not check for do_swap_account in mem_cgroup_{read,write,reset}
has been added to the -mm tree.  Its filename is
     memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch

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
Subject: memcg: do not check for do_swap_account in mem_cgroup_{read,write,reset}

Since 2d11085e ("memcg: do not create memsw files if swap accounting is
disabled") memsw files are created only if memcg swap accounting is
enabled so it doesn't make any sense to check for it explicitly in
mem_cgroup_read(), mem_cgroup_write() and mem_cgroup_reset().

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset
+++ a/mm/memcontrol.c
@@ -5025,9 +5025,6 @@ static ssize_t mem_cgroup_read(struct cg
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 
-	if (!do_swap_account && type == _MEMSWAP)
-		return -EOPNOTSUPP;
-
 	switch (type) {
 	case _MEM:
 		if (name == RES_USAGE)
@@ -5162,9 +5159,6 @@ static int mem_cgroup_write(struct cgrou
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 
-	if (!do_swap_account && type == _MEMSWAP)
-		return -EOPNOTSUPP;
-
 	switch (name) {
 	case RES_LIMIT:
 		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
@@ -5241,9 +5235,6 @@ static int mem_cgroup_reset(struct cgrou
 	type = MEMFILE_TYPE(event);
 	name = MEMFILE_ATTR(event);
 
-	if (!do_swap_account && type == _MEMSWAP)
-		return -EOPNOTSUPP;
