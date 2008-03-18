From: akpm@linux-foundation.org
Subject: + cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:04:25 -0700
Message-ID: <200803180404.m2I44Pxb013247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYCREFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     cgroup: fix boot option parsing
has been added to the -mm tree.  Its filename is
     cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch

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
Subject: cgroup: fix boot option parsing
From: Li Zefan <lizf@cn.fujitsu.com>

When boot with 'cgroup_disable=cpuacct', it turns out subsystem 'cpu' is
disabled.

When Balbir posted the patch to add cgroup boot option support, Paul M noticed
this problem, but the patch was accepted without fixing it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/cgroup.c~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing
+++ a/kernel/cgroup.c
@@ -3065,25 +3065,22 @@ static void cgroup_release_agent(struct 
 static int __init cgroup_disable(char *str)
 {
 	int i;
+	char *token;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		if (!*token)
+			continue;
 
-	while (*str) {
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 
-			if (!strncmp(str, ss->name, strlen(ss->name))) {
+			if (!strcmp(token, ss->name)) {
 				ss->disabled = 1;
 				printk(KERN_INFO "Disabling %s control group"
 					" subsystem\n", ss->name);
 				break;
 			}
 		}
-		/*
-		 * Find the next option if any
-		 */
-		while (*str && (*str != ','))
-			str++;
-		if (*str == ',')
-			str++;
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

