Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B583ACA7D
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857152; cv=none; b=olqQRBivMTbp3f1m4BSwcwi0glyJIrT76TUMOy48ZZrEXJzduqKAbnhCmadBy4z8dbVoJ0XEpV5gNszytJMibnehnqInViJPvIpXVMvMgXYVcihd4LADlgImkBgOPFJKRpqyTZPdZN2SCaSQLTy+wQJOR8voPBGyKLG2PvDUD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857152; c=relaxed/simple;
	bh=ZIzIQTE2NILGBzsDa0vW+stpw2hDs6ZMryPN6gyRsYI=;
	h=Date:To:From:Subject:Message-Id; b=T7PC2nhxBguPGtyGw3cs/Wo9vtNSB7Wanr3Yf8JoZ/f0PbWi0APwD8KDN/VKWEK8J1RU/5oXdJP1wrxiNyc6Qns3EOLR1g7GvFZfwWTaq+DoRFSK7AKsLOBH0j4Jgky6yrW8BML0aW22q4J2Y4hIc9/nGFR44LXj3pACeXi+UqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SH9LPnU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SH9LPnU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15439C19421;
	Wed, 18 Mar 2026 18:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857152;
	bh=ZIzIQTE2NILGBzsDa0vW+stpw2hDs6ZMryPN6gyRsYI=;
	h=Date:To:From:Subject:From;
	b=SH9LPnU1Rp1k+0mFUMp3Ue7wHvXMoy0QLVmFgF8Hr0QRCuUKxJ5Fin6L17ITEMUqG
	 tRJ3jiBLR1CTiQvgDDtHPojKKVScqhzoZ3TzJh5VDUh4tUpLee2E8higPL6qSimD4n
	 4gLDQiplmwCLzq85s9B158a+TRh9br0WYA3rRUpM=
Date: Wed, 18 Mar 2026 11:05:51 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-defer-flb-module-refcounting-to-active-sessions.patch added to mm-new branch
Message-Id: <20260318180552.15439C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: defer FLB module refcounting to active sessions
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-defer-flb-module-refcounting-to-active-sessions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-defer-flb-module-refcounting-to-active-sessions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: defer FLB module refcounting to active sessions
Date: Wed, 18 Mar 2026 10:16:42 -0400

Stop pinning modules indefinitely upon FLB registration.  Instead,
dynamically take a module reference when the FLB is actively used in a
session (e.g., during preserve and retrieve) and release it when the
session concludes.

This allows modules providing FLB operations to be cleanly unloaded when
not in active use by the live update orchestrator.

Link: https://lkml.kernel.org/r/20260318141637.1870220-14-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-defer-flb-module-refcounting-to-active-sessions
+++ a/kernel/liveupdate/luo_flb.c
@@ -112,10 +112,15 @@ static int luo_flb_file_preserve_one(str
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
@@ -143,6 +148,7 @@ static void luo_flb_file_unpreserve_one(
 
 			private->outgoing.data = 0;
 			private->outgoing.obj = NULL;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -178,12 +184,17 @@ static int luo_flb_retrieve_one(struct l
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
@@ -217,6 +228,7 @@ static void luo_flb_file_finish_one(stru
 			private->incoming.data = 0;
 			private->incoming.obj = NULL;
 			private->incoming.finished = true;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -394,11 +406,6 @@ int liveupdate_register_flb(struct liveu
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
@@ -474,12 +481,11 @@ int liveupdate_unregister_flb(struct liv
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
 
 	luo_session_resume();
@@ -506,7 +512,8 @@ err_resume:
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

mm-vmalloc-export-clear_vm_uninitialized_flag.patch
kho-fix-kasan-support-for-restored-vmalloc-regions.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch

