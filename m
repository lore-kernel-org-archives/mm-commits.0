From: akpm@linux-foundation.org
Subject: + devscgroup-relax-task-to-dev_cgroup-conversion.patch added to -mm tree
Date: Wed, 04 Jun 2008 18:33:39 -0700
Message-ID: <200806050133.m551Xe7o019278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYFEBhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 21:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, menage@google.com, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     devscgroup: relax task to dev_cgroup conversion
has been added to the -mm tree.  Its filename is
     devscgroup-relax-task-to-dev_cgroup-conversion.patch

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
Subject: devscgroup: relax task to dev_cgroup conversion
From: Pavel Emelyanov <xemul@openvz.org>
Return-Path: <xemul@openvz.org>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=none autolearn=ham
	version=3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id m547h8Fo001965
	for <akpm@localhost>; Wed, 4 Jun 2008 00:43:10 -0700
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with IMAP (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Wed, 04 Jun 2008 00:43:10 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m547g5Ct010642
	for <akpm@imap1.linux-foundation.org>; Wed, 4 Jun 2008 00:42:05 -0700
Received: from sacred.ru (sacred.ru [62.205.161.221])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m547fueC028187
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <akpm@linux-foundation.org>; Wed, 4 Jun 2008 00:41:59 -0700
Received: from [10.30.3.76] (swsoft-msk-nat.sw.ru [195.214.232.10])
	(authenticated bits=0)
	by sacred.ru (8.13.8/8.13.8) with ESMTP id m547flnc003822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Wed, 4 Jun 2008 11:41:47 +0400
Message-ID: <484646B4.3050904@openvz.org>
Date: Wed, 04 Jun 2008 11:39:32 +0400
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Serge Hallyn <serue@us.ibm.com>, Paul Menage <menage@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] devscgroup: relax task to dev_cgroup conversion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 04 Jun 2008 11:41:48 +0400 (MSD)
Received-SPF: pass (domain of xemul@openvz.org designates 62.205.161.221 as permitted sender)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

Two functions, that need to get a device_cgroup from a task (they
are devcgroup_inode_permission and devcgroup_inode_mknod) make it
in a strange way:

They get a css_set from task, then a subsys_state from css_set,
then a cgroup from the state and then a subsys_state again from
the cgroup. Besides, the devices_subsys_id is read from memory,
whilst there's a enum-ed constant for it.

Optimize this part a bit:
1. Get the subsys_stats form the task and be done - no 2 extra
   dereferences,
2. Use the device_subsys_id constant, not the value from memory
   (i.e. one less dereference).

Found while preparing 2.6.26 OpenVZ port.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 security/device_cgroup.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 15f2f80..f9941a7 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -506,7 +506,6 @@ struct cgroup_subsys devices_subsys = {
 
 int devcgroup_inode_permission(struct inode *inode, int mask)
 {
-	struct cgroup *cgroup;
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
@@ -515,8 +514,8 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
 		return 0;
 	if (!S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode))
 		return 0;
-	cgroup = task_cgroup(current, devices_subsys.subsys_id);
-	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
+				devices_subsys_id));
 	if (!dev_cgroup)
 		return 0;
 
@@ -547,12 +546,11 @@ acc_check:
 
 int devcgroup_inode_mknod(int mode, dev_t dev)
 {
-	struct cgroup *cgroup;
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
-	cgroup = task_cgroup(current, devices_subsys.subsys_id);
-	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
+				devices_subsys_id));
 	if (!dev_cgroup)
 		return 0;
 
-- 
1.5.3.4

Patches currently in -mm which might be from xemul@openvz.org are

linux-next.patch
proc-calculate-the-correct-proc-pid-link-count.patch
proc-calculate-the-correct-proc-pid-link-count-cleanup.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup.patch
devscgroup-relax-task-to-dev_cgroup-conversion.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
bsdacct-stir-up-comments-around-acct_process.patch
reiser4.patch

