From: akpm@linux-foundation.org
Subject: [merged] kexec-get-rid-of-duplicate-check-for-hole_end.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:07 -0800
Message-ID: <20130228201207.A78A85A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:37763 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3B1UMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:08 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so244834yen.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: get rid of duplicate check for hole_end
has been removed from the -mm tree.  Its filename was
     kexec-get-rid-of-duplicate-check-for-hole_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: get rid of duplicate check for hole_end

hole_end has been checked to make sure it is <= crash_res.end in the while
condition check, so the if condition check is duplicate.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/kexec.c~kexec-get-rid-of-duplicate-check-for-hole_end kernel/kexec.c
--- a/kernel/kexec.c~kexec-get-rid-of-duplicate-check-for-hole_end
+++ a/kernel/kexec.c
@@ -503,8 +503,6 @@ static struct page *kimage_alloc_crash_c
 
 		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
 			break;
-		if (hole_end > crashk_res.end)
-			break;
 		/* See if I overlap any of the segments */
 		for (i = 0; i < image->nr_segments; i++) {
 			unsigned long mstart, mend;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

