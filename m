From: akpm@linux-foundation.org
Subject: - devcgroup-code-cleanup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:33 -0700
Message-ID: <200807252258.m6PMwXKv003299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYGYW74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, menage@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     devcgroup: code cleanup
has been removed from the -mm tree.  Its filename was
     devcgroup-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: code cleanup
From: Li Zefan <lizf@cn.fujitsu.com>

- clean up set_majmin()
- use simple_strtoul() to parse major/minor

[akpm@linux-foundation.org: fix simple_strtoul() usage]
[kosaki.motohiro@jp.fujitsu.com: fix warnings]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-code-cleanup security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-code-cleanup
+++ a/security/device_cgroup.c
@@ -202,7 +202,7 @@ static struct cgroup_subsys_state *devcg
 		}
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
-		wh->access = ACC_MKNOD | ACC_READ | ACC_WRITE;
+		wh->access = ACC_MASK;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
@@ -264,11 +264,10 @@ static char type_to_char(short type)
 
 static void set_majmin(char *str, unsigned m)
 {
-	memset(str, 0, MAJMINLEN);
 	if (m == ~0)
-		sprintf(str, "*");
+		strcpy(str, "*");
 	else
-		snprintf(str, MAJMINLEN, "%u", m);
+		sprintf(str, "%u", m);
 }
 
 static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
@@ -360,6 +359,7 @@ static int devcgroup_update_access(struc
 {
 	struct dev_cgroup *cur_devcgroup;
 	const char *b;
+	char *endp;
 	int retval = 0, count;
 	struct dev_whitelist_item wh;
 
@@ -395,11 +395,8 @@ static int devcgroup_update_access(struc
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = 0;
-		while (isdigit(*b)) {
-			wh.major = wh.major*10+(*b-'0');
-			b++;
-		}
+		wh.major = simple_strtoul(b, &endp, 10);
+		b = endp;
 	} else {
 		return -EINVAL;
 	}
@@ -412,11 +409,8 @@ static int devcgroup_update_access(struc
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = 0;
-		while (isdigit(*b)) {
-			wh.minor = wh.minor*10+(*b-'0');
-			b++;
-		}
+		wh.minor = simple_strtoul(b, &endp, 10);
+		b = endp;
 	} else {
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

