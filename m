From: akpm@linux-foundation.org
Subject: [folded] cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:58:06 -0800
Message-ID: <201003102258.o2AMw6Yi008911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757385Ab0CJW6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@open


The patch titled
     cgroup: do not use dprintf in cgroup_event_listener
has been removed from the -mm tree.  Its filename was
     cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch

This patch was dropped because it was folded into cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: do not use dprintf in cgroup_event_listener
From: "Kirill A. Shutemov" <kirill@shutemov.name>

glibc's dprintf(3) is buggy:
http://sourceware.org/bugzilla/show_bug.cgi?id=11319

Let's not to use it in the example.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroup_event_listener.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/cgroup_event_listener.c~cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix Documentation/cgroups/cgroup_event_listener.c
--- a/Documentation/cgroups/cgroup_event_listener.c~cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix
+++ a/Documentation/cgroups/cgroup_event_listener.c
@@ -23,6 +23,7 @@ int main(int argc, char **argv)
 	int cfd = -1;
 	int event_control = -1;
 	char event_control_path[PATH_MAX];
+	char line[LINE_MAX];
 	int ret;
 
 	if (argc != 3) {
@@ -39,7 +40,7 @@ int main(int argc, char **argv)
 
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
 			dirname(argv[1]));
-	if (ret > PATH_MAX) {
+	if (ret >= PATH_MAX) {
 		fputs("Path to cgroup.event_control is too long\n", stderr);
 		goto out;
 	}
@@ -57,7 +58,13 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	ret = dprintf(event_control, "%d %d %s", efd, cfd, argv[2]);
+	ret = snprintf(line, LINE_MAX, "%d %d %s", efd, cfd, argv[2]);
+	if (ret >= LINE_MAX) {
+		fputs("Arguments string is too long\n", stderr);
+		goto out;
+	}
+
+	ret = write(event_control, line, strlen(line) + 1);
 	if (ret == -1) {
 		perror("Cannot write to cgroup.event_control");
 		goto out;
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroups-fix-contents-in-cgroups-documentation.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-typos-in-memcg_testtxt.patch

