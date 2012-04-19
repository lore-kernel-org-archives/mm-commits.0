From: akpm@linux-foundation.org
Subject: + connector-userns-replace-netlink-uses-of-cap_raised-with-capable.patch added to -mm tree
Date: Thu, 19 Apr 2012 12:51:14 -0700
Message-ID: <20120419195115.1DBA0A0353@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41807 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2DSTvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 15:51:16 -0400
Received: by yenq2 with SMTP id q2so1022455yen.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 12:51:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davem@davemloft.net, dhowells@redhat.com, james.l.morris@oracle.com, kaber@trash.net, morgan@kernel.org, philipp.reisner@linbit.com, segoon@openwall.com, serge.hallyn@canonical.com


The patch titled
     Subject: connector/userns: replace netlink uses of cap_raised with capable.
has been added to the -mm tree.  Its filename is
     connector-userns-replace-netlink-uses-of-cap_raised-with-capable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ebiederm@xmission.com (Eric W. Biederman)
Subject: connector/userns: replace netlink uses of cap_raised with capable.

In 2009 Philip Reiser notied that a few users of netlink connector
interface needed a capability check and added the idiom
cap_raised(nsp->eff_cap, CAP_SYS_ADMIN) to a few of them, on the premise
that netlink was asynchronous.

In 2011 Patrick McHardy noticed we were being silly because netlink is
synchronous and removed eff_cap from the netlink_skb_params and changed
the idiom to cap_raised(current_cap(), CAP_SYS_ADMIN).

Looking at those spots with a fresh eye we should be calling
capable(CAP_SYS_ADMIN).  The only reason I can see for not calling capable
is that it once appeared we were not in the same task as the caller which
would have made calling capable() impossible.

In the initial user_namespace the only difference between between
cap_raised(current_cap(), CAP_SYS_ADMIN) and capable(CAP_SYS_ADMIN) are a
few sanity checks and the fact that capable(CAP_SYS_ADMIN) sets
PF_SUPERPRIV if we use the capability.

Since we are going to be using root privilege setting PF_SUPERPRIV seems
the right thing to do.

The motivation for this that patch is that in a child user namespace
cap_raised(current_cap(),...) tests your capabilities with respect to that
child user namespace not capabilities in the initial user namespace and
thus will allow processes that should be unprivielged to use the kernel
services that are only protected with cap_raised(current_cap(),..).

To fix possible user_namespace issues and to just clean up the code
replace cap_raised(current_cap(), CAP_SYS_ADMIN) with
capable(CAP_SYS_ADMIN).

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <james.l.morris@oracle.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_nl.c           |    2 +-
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/drbd/drbd_nl.c~connector-userns-replace-netlink-uses-of-cap_raised-with-capable drivers/block/drbd/drbd_nl.c
--- a/drivers/block/drbd/drbd_nl.c~connector-userns-replace-netlink-uses-of-cap_raised-with-capable
+++ a/drivers/block/drbd/drbd_nl.c
@@ -2297,7 +2297,7 @@ static void drbd_connector_callback(stru
 		return;
 	}
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
+	if (!capable(CAP_SYS_ADMIN)) {
 		retcode = ERR_PERM;
 		goto fail;
 	}
diff -puN drivers/md/dm-log-userspace-transfer.c~connector-userns-replace-netlink-uses-of-cap_raised-with-capable drivers/md/dm-log-userspace-transfer.c
--- a/drivers/md/dm-log-userspace-transfer.c~connector-userns-replace-netlink-uses-of-cap_raised-with-capable
+++ a/drivers/md/dm-log-userspace-transfer.c
@@ -134,7 +134,7 @@ static void cn_ulog_callback(struct cn_m
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return;
 
 	spin_lock(&receiving_list_lock);
diff -puN drivers/video/uvesafb.c~connector-userns-replace-netlink-uses-of-cap_raised-with-capable drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~connector-userns-replace-netlink-uses-of-cap_raised-with-capable
+++ a/drivers/video/uvesafb.c
@@ -73,7 +73,7 @@ static void uvesafb_cn_callback(struct c
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return;
 
 	if (msg->seq >= UVESAFB_TASKS_MAX)
_
Subject: Subject: connector/userns: replace netlink uses of cap_raised with capable.

Patches currently in -mm which might be from ebiederm@xmission.com are

linux-next.patch
connector-userns-replace-netlink-uses-of-cap_raised-with-capable.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

