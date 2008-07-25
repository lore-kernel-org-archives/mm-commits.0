From: akpm@linux-foundation.org
Subject: - devcgroup-code-cleanup-fix-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:22:56 -0700
Message-ID: <200807250022.m6P0Mug1013967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbYGYAXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kill devcgroup-code-cleanup.patch warning
has been removed from the -mm tree.  Its filename was
     devcgroup-code-cleanup-fix-fix.patch

This patch was dropped because it was folded into devcgroup-code-cleanup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill devcgroup-code-cleanup.patch warning
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

devcgroup-code-cleanup.patch made following warnings because b is const.

  security/device_cgroup.c: In function 'devcgroup_update_access':
  security/device_cgroup.c:397: warning: passing argument 2 of 'simple_strtoul' from incompatible pointer type
  security/device_cgroup.c:410: warning: passing argument 2 of 'simple_strtoul' from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-code-cleanup-fix-fix security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-code-cleanup-fix-fix
+++ a/security/device_cgroup.c
@@ -359,6 +359,7 @@ static int devcgroup_update_access(struc
 {
 	struct dev_cgroup *cur_devcgroup;
 	const char *b;
+	char *endp;
 	int retval = 0, count;
 	struct dev_whitelist_item wh;
 
@@ -394,7 +395,8 @@ static int devcgroup_update_access(struc
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = simple_strtoul(b, &b, 10);
+		wh.major = simple_strtoul(b, &endp, 10);
+		b = endp;
 	} else {
 		return -EINVAL;
 	}
@@ -407,7 +409,8 @@ static int devcgroup_update_access(struc
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = simple_strtoul(b, &b, 10);
+		wh.minor = simple_strtoul(b, &endp, 10);
+		b = endp;
 	} else {
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
devcgroup-code-cleanup.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch

