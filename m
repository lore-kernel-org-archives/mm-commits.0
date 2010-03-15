From: akpm@linux-foundation.org
Subject: + memcontrol-fix-potential-null-deref.patch added to -mm tree
Date: Mon, 15 Mar 2010 14:13:41 -0700
Message-ID: <201003152113.o2FLDf5u022965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932738Ab0COVNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 17:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcontrol: fix potential null deref
has been added to the -mm tree.  Its filename is
     memcontrol-fix-potential-null-deref.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcontrol: fix potential null deref
From: Dan Carpenter <error27@gmail.com>

There was a potential null deref introduced in c62b1a3b31b5 ("memcg: use
generic percpu instead of private implementation").

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcontrol-fix-potential-null-deref mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-fix-potential-null-deref
+++ a/mm/memcontrol.c
@@ -3691,8 +3691,10 @@ static struct mem_cgroup *mem_cgroup_all
 	else
 		mem = vmalloc(size);
 
-	if (mem)
-		memset(mem, 0, size);
+	if (!mem)
+		return NULL;
+
+	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!mem->stat) {
 		if (size < PAGE_SIZE)
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
dpt_i20-several-use-after-free-issues.patch
i915-fix-small-leak-on-error-path.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
goku_udc-potential-null-dereference.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch

