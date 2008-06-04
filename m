From: akpm@linux-foundation.org
Subject: + devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:41:28 -0700
Message-ID: <200806042341.m54NfSLE015136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758556AbYFDXvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:51:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, menage@google.com, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     devcgroup: make a helper to convert cgroup_subsys_state to devs_cgroup
has been added to the -mm tree.  Its filename is
     devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup.patch

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
Subject: devcgroup: make a helper to convert cgroup_subsys_state to devs_cgroup
From: Pavel Emelyanov <xemul@openvz.org>

This is just picking the container_of out of cgroup_to_devcgroup into a
separate function.

This new css_to_devcgroup will be used in the 2nd patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup
+++ a/security/device_cgroup.c
@@ -49,10 +49,14 @@ struct dev_cgroup {
 	spinlock_t lock;
 };
 
+static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
+{
+	return container_of(s, struct dev_cgroup, css);
+}
+
 static inline struct dev_cgroup *cgroup_to_devcgroup(struct cgroup *cgroup)
 {
-	return container_of(cgroup_subsys_state(cgroup, devices_subsys_id),
-			    struct dev_cgroup, css);
+	return css_to_devcgroup(cgroup_subsys_state(cgroup, devices_subsys_id));
 }
 
 struct cgroup_subsys devices_subsys;
_

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

