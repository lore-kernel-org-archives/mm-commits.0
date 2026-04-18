Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F199636C598
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498796; cv=none; b=Qmm3nK5vbshZXYCVyuY4sykmGvyNUuyp0XMsVJsv2BXXmx/BwusW921CaV/Yz/i3vkhojwU4akY9zX0wcdPhqihvS70+ifU64FJYWhvyBAA5Gfv924lSc2/mqkngh5K0r280eR0lqsmDvvMxRAMUgDnYvtPZtqc84jFc6fZ5TDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498796; c=relaxed/simple;
	bh=+vxhNRPOjOCEqLERrxttT/jrm9gtHMigdJv79m2ZYBI=;
	h=Date:To:From:Subject:Message-Id; b=UhJQW14AZfKEsHQKAAzYkn0JDSdChmAeikyug8DLyheYAgXcm1NrH1J4UbNMIpO1hOtZx2RWuUhL4UE+HRKTp7fNwwUqFpNjHBvzoF1TVya/1KJ9rCSIPFOMhSUup0Jq+4HGj/2ZgpYtjIkhqeGgVUp8bRK0ZDdI837DIdQgwK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qVXQq3wM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qVXQq3wM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992D6C19424;
	Sat, 18 Apr 2026 07:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498795;
	bh=+vxhNRPOjOCEqLERrxttT/jrm9gtHMigdJv79m2ZYBI=;
	h=Date:To:From:Subject:From;
	b=qVXQq3wM7u+TqaJneyjdlxUBz5xPMULZlNLuarIaiaC8MUKPKxvvLayOiqQFV5VK5
	 h826rS4y3n3OZ4xaqgkthJ2p6Vor1g9Gv+XslAG8+KDgxDQVLn2B/V4qGJNjFnFd5K
	 IhZ3DSPptIhtfpmPIAY4etmvqtaxxfbAKH2bhZdw=
Date: Sat, 18 Apr 2026 00:53:09 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-defer-flb-module-refcounting-to-active-sessions.patch removed from -mm tree
Message-Id: <20260418075314.992D6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: defer FLB module refcounting to active sessions
has been removed from the -mm tree.  Its filename was
     liveupdate-defer-flb-module-refcounting-to-active-sessions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: defer FLB module refcounting to active sessions
Date: Fri, 27 Mar 2026 03:33:29 +0000

Stop pinning modules indefinitely upon FLB registration.  Instead,
dynamically take a module reference when the FLB is actively used in a
session (e.g., during preserve and retrieve) and release it when the
session concludes.

This allows modules providing FLB operations to be cleanly unloaded when
not in active use by the live update orchestrator.

Link: https://lore.kernel.org/20260327033335.696621-6-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-defer-flb-module-refcounting-to-active-sessions
+++ a/kernel/liveupdate/luo_flb.c
@@ -115,10 +115,15 @@ static int luo_flb_file_preserve_one(str
 			struct liveupdate_flb_op_args args = {0};
 			int err;
 
+			if (!try_module_get(flb->ops->owner))
+				return -ENODEV;
+
 			args.flb = flb;
 			err = flb->ops->preserve(&args);
-			if (err)
+			if (err) {
+				module_put(flb->ops->owner);
 				return err;
+			}
 			private->outgoing.data = args.data;
 			private->outgoing.obj = args.obj;
 		}
@@ -146,6 +151,7 @@ static void luo_flb_file_unpreserve_one(
 
 			private->outgoing.data = 0;
 			private->outgoing.obj = NULL;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -181,12 +187,17 @@ static int luo_flb_retrieve_one(struct l
 	if (!found)
 		return -ENOENT;
 
+	if (!try_module_get(flb->ops->owner))
+		return -ENODEV;
+
 	args.flb = flb;
 	args.data = private->incoming.data;
 
 	err = flb->ops->retrieve(&args);
-	if (err)
+	if (err) {
+		module_put(flb->ops->owner);
 		return err;
+	}
 
 	private->incoming.obj = args.obj;
 	private->incoming.retrieved = true;
@@ -220,6 +231,7 @@ static void luo_flb_file_finish_one(stru
 			private->incoming.data = 0;
 			private->incoming.obj = NULL;
 			private->incoming.finished = true;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -395,11 +407,6 @@ int liveupdate_register_flb(struct liveu
 				goto err_resume;
 		}
 
-		if (!try_module_get(flb->ops->owner)) {
-			err = -EAGAIN;
-			goto err_resume;
-		}
-
 		list_add_tail(&private->list, &luo_flb_global.list);
 		luo_flb_global.count++;
 	}
@@ -476,12 +483,11 @@ int liveupdate_unregister_flb(struct liv
 	private->users--;
 	/*
 	 * If this is the last file-handler with which we are registred, remove
-	 * from the global list, and relese module reference.
+	 * from the global list.
 	 */
 	if (!private->users) {
 		list_del_init(&private->list);
 		luo_flb_global.count--;
-		module_put(flb->ops->owner);
 	}
 
 	up_write(&luo_register_rwlock);
@@ -510,7 +516,8 @@ err_resume:
  *
  * Return: 0 on success, or a negative errno on failure. -ENODATA means no
  * incoming FLB data, -ENOENT means specific flb not found in the incoming
- * data, and -EOPNOTSUPP when live update is disabled or not configured.
+ * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
+ * live update is disabled or not configured.
  */
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
 {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

