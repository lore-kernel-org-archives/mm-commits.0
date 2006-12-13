From: akpm@osdl.org
Subject: - sysctl-remove-some-ops.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:52:20 -0800
Message-ID: <200612130652.kBD6qK3d030431@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57369 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbWLMGwu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, chrisw@sous-sol.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove some OPs
has been removed from the -mm tree.  Its filename was
     sysctl-remove-some-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: remove some OPs
From: Alexey Dobriyan <adobriyan@gmail.com>

kernel.cap-bound uses only OP_SET and OP_AND

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-some-ops kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-some-ops
+++ a/kernel/sysctl.c
@@ -1931,9 +1931,6 @@ int proc_dointvec(ctl_table *table, int 
 
 #define OP_SET	0
 #define OP_AND	1
-#define OP_OR	2
-#define OP_MAX	3
-#define OP_MIN	4
 
 static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
 				      int *valp,
@@ -1945,13 +1942,6 @@ static int do_proc_dointvec_bset_conv(in
 		switch(op) {
 		case OP_SET:	*valp = val; break;
 		case OP_AND:	*valp &= val; break;
-		case OP_OR:	*valp |= val; break;
-		case OP_MAX:	if(*valp < val)
-					*valp = val;
-				break;
-		case OP_MIN:	if(*valp > val)
-				*valp = val;
-				break;
 		}
 	} else {
 		int val = *valp;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch

