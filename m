From: akpm@linux-foundation.org
Subject: + merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch added to -mm tree
Date: Sun, 25 Mar 2007 13:52:33 -0800
Message-ID: <200703252152.l2PLqX2a003702@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59221 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXCYVwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 17:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, clg@fr.ibm.com, ebiederm@xmission.com, pbadari@us.ibm.com, serue@us.ibm.com


The patch titled
     utsns: fix !CONFIG_UTS_NS behavior
has been added to the -mm tree.  Its filename is
     merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
