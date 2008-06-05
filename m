From: akpm@linux-foundation.org
Subject: + devscgroup-make-white-list-more-compact-in-some-cases.patch added to -mm tree
Date: Thu, 05 Jun 2008 11:47:51 -0700
Message-ID: <200806051847.m55IlqoT024368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbYFESr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, serue@us.ibm.com


The patch titled
     devscgroup: make white list more compact in some cases
has been added to the -mm tree.  Its filename is
     devscgroup-make-white-list-more-compact-in-some-cases.patch

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
Subject: devscgroup: make white list more compact in some cases
From: Pavel Emelyanov <xemul@openvz.org>

Consider you added a 'c foo:bar r' permission to some cgroup and then (a
bit later) 'c'foo:bar w' for it.  After this you'll see the

c foo:bar r
c foo:bar w

lines in a devices.list file.

Another example - consider you added 10 'c foo:bar r' permissions to some
cgroup (e.g.  by mistake).  After this you'll see 10 c foo:bar r lines in
a list file.

This is weird.  This situation also has one more annoying consequence. 
Having many items in a white list makes permissions checking slower, sine
it has to walk a longer list.

The proposal is to merge permissions for items, that correspond to the
same device.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~devscgroup-make-white-list-more-compact-in-some-cases security/device_cgroup.c
--- a/security/device_cgroup.c~devscgroup-make-white-list-more-compact-in-some-cases
+++ a/security/device_cgroup.c
@@ -106,7 +106,7 @@ free_and_exit:
 static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
 {
-	struct dev_whitelist_item *whcopy;
+	struct dev_whitelist_item *whcopy, *walk;
 
 	whcopy = kmalloc(sizeof(*whcopy), GFP_KERNEL);
 	if (!whcopy)
@@ -114,7 +114,21 @@ static int dev_whitelist_add(struct dev_
 
 	memcpy(whcopy, wh, sizeof(*whcopy));
 	spin_lock(&dev_cgroup->lock);
-	list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
+	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
+		if (walk->type != wh->type)
+			continue;
+		if (walk->major != wh->major)
+			continue;
+		if (walk->minor != wh->minor)
+			continue;
+
+		walk->access |= wh->access;
+		kfree(whcopy);
+		whcopy = NULL;
+	}
+
+	if (whcopy != NULL)
+		list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
 	spin_unlock(&dev_cgroup->lock);
 	return 0;
 }
_

Patches currently in -mm which might be from xemul@openvz.org are

devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup.patch
devscgroup-relax-task-to-dev_cgroup-conversion.patch
devscgroup-check-for-device-permissions-at-mount-time.patch
devscgroup-make-white-list-more-compact-in-some-cases.patch
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

