From: akpm@linux-foundation.org
Subject: - devscgroup-make-white-list-more-compact-in-some-cases.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:14 -0700
Message-ID: <200806081948.m58JmE8u017487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbYFHTsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscgroup: make white list more compact in some cases
has been removed from the -mm tree.  Its filename was
     devscgroup-make-white-list-more-compact-in-some-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
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

