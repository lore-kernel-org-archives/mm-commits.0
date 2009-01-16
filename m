From: akpm@linux-foundation.org
Subject: + cgroups-use-hierarchy-mutex-in-creation-failure-path.patch added to -mm tree
Date: Fri, 16 Jan 2009 13:02:48 -0800
Message-ID: <200901162102.n0GL2mkl031134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277AbZAPVDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 16:03:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: use hierarchy mutex in creation failure path
has been added to the -mm tree.  Its filename is
     cgroups-use-hierarchy-mutex-in-creation-failure-path.patch

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
Subject: cgroups: use hierarchy mutex in creation failure path
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, cgrp->sibling is handled under hierarchy mutex.
error route should do so, too.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cgroup.c~cgroups-use-hierarchy-mutex-in-creation-failure-path kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-use-hierarchy-mutex-in-creation-failure-path
+++ a/kernel/cgroup.c
@@ -2434,7 +2434,9 @@ static long cgroup_create(struct cgroup 
 
  err_remove:
 
+	cgroup_lock_hierarchy(root);
 	list_del(&cgrp->sibling);
+	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups--;
 
  err_destroy:
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-use-hierarchy-mutex-in-creation-failure-path.patch
memcg-get-put-parents-at-create-free.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch

