From: akpm@linux-foundation.org
Subject: + utsns-fix-config_uts_ns-behavior.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:54:54 -0800
Message-ID: <200703250854.l2P8ssF6024167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36763 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbXCYIzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, ebiederm@xmission.com


The patch titled
     utsns: fix !CONFIG_UTS_NS behavior
has been added to the -mm tree.  Its filename is
     utsns-fix-config_uts_ns-behavior.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

utsns-fix-config_uts_ns-behavior.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
