From: akpm@linux-foundation.org
Subject: + sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch added to -mm tree
Date: Wed, 03 Feb 2010 12:59:20 -0800
Message-ID: <201002032059.o13KxKMh018761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab0BCVAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 16:00:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, neilb@suse.de


The patch titled
     sunrpc/cache: fix module refcnt leak in a failure path
has been added to the -mm tree.  Its filename is
     sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch

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
Subject: sunrpc/cache: fix module refcnt leak in a failure path
From: Li Zefan <lizf@cn.fujitsu.com>

Don't forget to release the module refcnt if seq_open() returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/cache.c~sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path
+++ a/net/sunrpc/cache.c
@@ -1233,8 +1233,10 @@ static int content_open(struct inode *in
 	if (!cd || !try_module_get(cd->owner))
 		return -EACCES;
 	han = __seq_open_private(file, &cache_content_op, sizeof(*han));
-	if (han == NULL)
+	if (han == NULL) {
+		module_put(cd->owner);
 		return -ENOMEM;
+	}
 
 	han->cd = cd;
 	return 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch
lib-stringc-simplify-strnstr.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch

