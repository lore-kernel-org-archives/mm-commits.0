From: akpm@linux-foundation.org
Subject: + memcgroup-return-negative-error-code-in-mem_cgroup_create.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:52 -0800
Message-ID: <200802230733.m1N7XfqQ018244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYBWHyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     ] memcgroup: return negative error code in mem_cgroup_create()
has been added to the -mm tree.  Its filename is
     memcgroup-return-negative-error-code-in-mem_cgroup_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ] memcgroup: return negative error code in mem_cgroup_create()
From: Li Zefan <lizf@cn.fujitsu.com>

Cgroup requires the subsystem to return negative error code on error in the
create method.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-return-negative-error-code-in-mem_cgroup_create mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-return-negative-error-code-in-mem_cgroup_create
+++ a/mm/memcontrol.c
@@ -1100,7 +1100,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
 	if (mem == NULL)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	res_counter_init(&mem->res);
 
@@ -1116,7 +1116,7 @@ free_out:
 		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
 		kfree(mem);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroup-fix-and-update-documentation.patch
cgroup-fix-comments.patch
cgroup-clean-up-cgrouph.patch
cgroup-fix-memory-leak-in-cgroup_get_sb.patch
cgroup-fix-subsys-bitops.patch
cgroup-remove-duplicate-code-in-find_css_set.patch
cgroup-remove-dead-code-in-cgroup_get_rootdir.patch
memcgroup-fix-and-update-documentation.patch
memcgroup-remove-a-useless-vm_bug_on.patch
memcgroup-return-negative-error-code-in-mem_cgroup_create.patch
