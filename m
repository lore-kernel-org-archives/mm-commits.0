From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-enforce-per-flavor-id-squashing.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:17 -0700
Message-ID: <200707172305.l6HN5HNg011908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935625AbXGQXPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: enforce per-flavor id squashing
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-enforce-per-flavor-id-squashing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: enforce per-flavor id squashing
From: J. Bruce Fields <bfields@citi.umich.edu>

Allow root squashing to vary per-pseudoflavor, so that you can (for example)
allow root access only when sufficiently strong security is in use.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/auth.c              |   18 ++++++++++++++++--
 include/linux/nfsd/export.h |    3 ++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/auth.c~knfsd-nfsd-enforce-per-flavor-id-squashing fs/nfsd/auth.c
--- a/fs/nfsd/auth.c~knfsd-nfsd-enforce-per-flavor-id-squashing
+++ a/fs/nfsd/auth.c
@@ -12,17 +12,31 @@
 
 #define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))
 
+static int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return f->flags;
+	}
+	return exp->ex_flags;
+
+}
+
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct svc_cred	cred = rqstp->rq_cred;
 	int i;
+	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
-	if (exp->ex_flags & NFSEXP_ALLSQUASH) {
+	if (flags & NFSEXP_ALLSQUASH) {
 		cred.cr_uid = exp->ex_anon_uid;
 		cred.cr_gid = exp->ex_anon_gid;
 		cred.cr_group_info = groups_alloc(0);
-	} else if (exp->ex_flags & NFSEXP_ROOTSQUASH) {
+	} else if (flags & NFSEXP_ROOTSQUASH) {
 		struct group_info *gi;
 		if (!cred.cr_uid)
 			cred.cr_uid = exp->ex_anon_uid;
diff -puN include/linux/nfsd/export.h~knfsd-nfsd-enforce-per-flavor-id-squashing include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd-enforce-per-flavor-id-squashing
+++ a/include/linux/nfsd/export.h
@@ -43,7 +43,8 @@
 #define NFSEXP_ALLFLAGS		0xFE3F
 
 /* The flags that may vary depending on security flavor: */
-#define NFSEXP_SECINFO_FLAGS	0
+#define NFSEXP_SECINFO_FLAGS	(NFSEXP_READONLY | NFSEXP_ROOTSQUASH \
+					| NFSEXP_ALLSQUASH)
 
 #ifdef __KERNEL__
 
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
