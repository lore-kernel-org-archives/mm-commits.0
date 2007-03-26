From: akpm@linux-foundation.org
Subject: - merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch removed from -mm tree
Date: Mon, 26 Mar 2007 12:44:54 -0700
Message-ID: <200703261944.l2QJitsP028763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbXCZTpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 15:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, clg@fr.ibm.com, ebiederm@xmission.com, pbadari@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     utsns: fix !CONFIG_UTS_NS behavior
has been removed from the -mm tree.  Its filename was
     merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: utsns: fix !CONFIG_UTS_NS behavior
From: "Serge E. Hallyn" <serge@hallyn.com>

When CONFIG_UTS_NS=n, clone(CLONE_NEWUTS) quietly refuses.  So correctly does
not unshare a new uts namespace, but also does not return -EINVAL.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/utsname.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/utsname.h~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2 include/linux/utsname.h
--- a/include/linux/utsname.h~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2
+++ a/include/linux/utsname.h
@@ -35,6 +35,7 @@ struct new_utsname {
 #include <linux/sched.h>
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
+#include <linux/err.h>
 #include <asm/atomic.h>
 
 struct uts_namespace {
@@ -60,6 +61,8 @@ static inline void put_uts_ns(struct uts
 static inline struct uts_namespace *copy_utsname(int flags,
 						struct uts_namespace *ns)
 {
+	if (flags & CLONE_NEWUTS)
+		return ERR_PTR(-EINVAL);
 	return ns;
 }
 
_

Patches currently in -mm which might be from serge@hallyn.com are

merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
