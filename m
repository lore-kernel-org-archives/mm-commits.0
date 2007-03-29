From: akpm@linux-foundation.org
Subject: - utsns-fix-config_uts_ns-behavior.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:03 -0700
Message-ID: <200703290742.l2T7g3Aj030276@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbXC2HmG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     utsns: fix !CONFIG_UTS_NS behavior
has been removed from the -mm tree.  Its filename was
     utsns-fix-config_uts_ns-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: utsns: fix !CONFIG_UTS_NS behavior
From: "Serge E. Hallyn" <serue@us.ibm.com>

When CONFIG_UTS_NS=n, clone(CLONE_NEWUTS) quietly refuses.  So correctly does
not unshare a new uts namespace, but also does not return -EINVAL.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/utsname.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/utsname.h~utsns-fix-config_uts_ns-behavior include/linux/utsname.h
--- a/include/linux/utsname.h~utsns-fix-config_uts_ns-behavior
+++ a/include/linux/utsname.h
@@ -70,6 +70,8 @@ static inline int unshare_utsname(unsign
 
 static inline int copy_utsname(int flags, struct task_struct *tsk)
 {
+	if (flags & CLONE_NEWUTS)
+		return -EINVAL;
 	return 0;
 }
 static inline void put_uts_ns(struct uts_namespace *ns)
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
