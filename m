From: akpm@linux-foundation.org
Subject: + cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch added to -mm tree
Date: Wed, 24 Feb 2010 15:22:16 -0800
Message-ID: <201002242322.o1ONMGSG026454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178Ab0BXXW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 18:22:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix
has been added to the -mm tree.  Its filename is
     cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch

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
Subject: cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Actually, we want to fput() cfile, if cfile is not NULL.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix
+++ a/kernel/cgroup.c
@@ -3122,7 +3122,7 @@ static int cgroup_write_event_control(st
 	return 0;
 
 fail:
-	if (!cfile)
+	if (cfile)
 		fput(cfile);
 
 	if (event && event->eventfd && !IS_ERR(event->eventfd))
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroups-fix-contents-in-cgroups-documentation.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch

