From: akpm@linux-foundation.org
Subject: + audit-netlink-socket-can-be-auto-bound-to-pid-other-than-current-pid.patch added to -mm tree
Date: Tue, 18 Mar 2008 15:17:19 -0700
Message-ID: <200803182217.m2IMHJeL018905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbYCSTmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, amy.griffis@hp.com, dwmw2@infradead.org, eparis@parisplace.org, sgrubb@redhat.com, tgraf@suug.ch, viro@zeniv.linux.org.uk


The patch titled
     audit: netlink socket can be auto-bound to pid other than current->pid
has been added to the -mm tree.  Its filename is
     audit-netlink-socket-can-be-auto-bound-to-pid-other-than-current-pid.patch

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
Subject: audit: netlink socket can be auto-bound to pid other than current->pid
From: Pavel Emelyanov <xemul@openvz.org>

This patch is based on the one from Thomas.

The kauditd_thread() calls the netlink_unicast() and passes the audit_pid to
it.  The audit_pid, in turn, is received from the user space and the tool
(I've checked the audit v1.6.9) uses getpid() to pass one in the kernel. 
Besides, this tool doesn't bind the netlink socket to this id, but simply
creates it allowing the kernel to auto-bind one.

That's the preamble.

The problem is that netlink_autobind() _does_not_ guarantees that the socket
will be auto-bound to the current pid.  Instead it uses the current pid as a
hint to start looking for a free id.  So, in case of conflict, the audit
messages can be sent to a wrong socket.  This can happen (it's unlikely, but
can be) in case some task opens more than one netlink sockets and then the
audit one starts - in this case the audit's pid can be busy and its socket
will be bound to another id.

The proposal is to introduce an audit_nlk_pid in audit subsys, that will point
to the netlink socket to send packets to.  It will most often be equal to
audit_pid.  The socket id can be got from the skb's netlink CB right in the
audit_receive_msg.

Later, if the audit tools will bind the socket themselves, the kernel will
have to provide a way to setup the audit_nlk_pid as well.

A good side effect of this patch is that audit_pid can later be converted to
struct pid, as it is not longer safe to use pid_t-s in the presence of pid
namespaces.  But audit code still uses the tgid from task_struct in the
audit_signal_info and in the audit_filter_syscall.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Amy Griffis <amy.griffis@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/audit.c~audit-netlink-socket-can-be-auto-bound-to-pid-other-than-current-pid kernel/audit.c
--- a/kernel/audit.c~audit-netlink-socket-can-be-auto-bound-to-pid-other-than-current-pid
+++ a/kernel/audit.c
@@ -78,8 +78,10 @@ static int	audit_default;
 /* If auditing cannot proceed, audit_failure selects what happens. */
 static int	audit_failure = AUDIT_FAIL_PRINTK;
 
-/* If audit records are to be written to the netlink socket, audit_pid
+/* If audit records are to be written to the netlink socket, audit_nlk_pid
  * contains the (non-zero) pid. */
+static int	audit_nlk_pid;
+
 int		audit_pid;
 
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
@@ -349,13 +351,13 @@ static int kauditd_thread(void *dummy)
 		skb = skb_dequeue(&audit_skb_queue);
 		wake_up(&audit_backlog_wait);
 		if (skb) {
-			if (audit_pid) {
-				int err = netlink_unicast(audit_sock, skb, audit_pid, 0);
+			if (audit_nlk_pid) {
+				int err = netlink_unicast(audit_sock, skb, audit_nlk_pid, 0);
 				if (err < 0) {
 					BUG_ON(err != -ECONNREFUSED); /* Shoudn't happen */
-					printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
+					printk(KERN_ERR "audit: *NO* daemon at audit_nlk_pid=%d\n", audit_nlk_pid);
 					audit_log_lost("auditd dissapeared\n");
-					audit_pid = 0;
+					audit_nlk_pid = 0;
 				}
 			} else {
 				if (printk_ratelimit())
@@ -626,6 +628,7 @@ static int audit_receive_msg(struct sk_b
 							sid, 1);
 
 			audit_pid = new_pid;
+			audit_nlk_pid = NETLINK_CB(skb).pid;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
 			err = audit_set_rate_limit(status_get->rate_limit,
@@ -1354,7 +1357,7 @@ void audit_log_end(struct audit_buffer *
 		audit_log_lost("rate limit exceeded");
 	} else {
 		struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
-		if (audit_pid) {
+		if (audit_nlk_pid) {
 			nlh->nlmsg_len = ab->skb->len - NLMSG_SPACE(0);
 			skb_queue_tail(&audit_skb_queue, ab->skb);
 			ab->skb = NULL;
_

Patches currently in -mm which might be from xemul@openvz.org are

memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup.patch
git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
audit-netlink-socket-can-be-auto-bound-to-pid-other-than-current-pid.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch
bsd_acct-using-task_struct-tgid-is-not-right-in-pid-namespaces.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
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
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

