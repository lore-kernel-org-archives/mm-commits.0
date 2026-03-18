Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FB53B8BA7
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857147; cv=none; b=sPpuEA7PDJCkveC9NDwf3QZPbTTekl6x31dqghyuv7JHm2/trB5i4SCgtqbqLRJpvMHO1kDbUNz0HTwqLna4+QbfMeOWQFKNeLxfBF/xLQnjdQW1t4mvQ2bpEwoQwAvdBYwXbyfmlZKs31c0EEHyx0ahWOMfBJkYPQp+2p8hU7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857147; c=relaxed/simple;
	bh=LwqrCacGr2/Bg7J0Sb3bhVMLUtTz2Ecld3f213TCjxM=;
	h=Date:To:From:Subject:Message-Id; b=ktZQ3Rrc/YFKGck6E+C5MN887FtPZYySyd9aBqXjc2Gqx9nvJzP/wBUVoHI4EVg4zVjaO6CwUCBr3AfbjzB3GXhD7pDXPyByQ8J2sbP9F9iuJILo2wn0Ji7dS8OWnql1MlN8czmhKs47cz67Gzs+09sgA3C9dPWgVk3si8SpQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rODPOeg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rODPOeg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055E7C19421;
	Wed, 18 Mar 2026 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857147;
	bh=LwqrCacGr2/Bg7J0Sb3bhVMLUtTz2Ecld3f213TCjxM=;
	h=Date:To:From:Subject:From;
	b=rODPOeg82l3cSg/O5GLXkmmX2bf1D2VLu0S0quZp3OLicnbKX6/KH+i1f14E5e0VG
	 IGk14PP6atBe5j57iKrfFJYE7VaPh9uLTs0yuRyd4JfLsol2tSwQ5bG6OjULx49iUj
	 d4dBS2Ina46HXMLdDXBKma/fysKiUMaJPyte7/jU=
Date: Wed, 18 Mar 2026 11:05:46 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-protect-flb-lists-with-rwsem.patch added to mm-new branch
Message-Id: <20260318180547.055E7C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: protect FLB lists with rwsem
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-protect-flb-lists-with-rwsem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-protect-flb-lists-with-rwsem.patch

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
Subject: liveupdate: protect FLB lists with rwsem
Date: Wed, 18 Mar 2026 10:16:40 -0400

Because liveupdate FLB objects will soon drop their persistent module
references when registered, list traversals must be protected against
concurrent module unloading.

Introduce two read-write semaphores to provide this protection:
1. A global luo_flb_lock protects the global registry of FLBs.
2. A per-handler flb_lock protects the handler's specific list of FLB
   dependencies.

Read locks are used during concurrent list traversals (e.g., during
preservation and serialization).  Write locks are taken during
registration and unregistration.  When both locks are required, the global
luo_flb_lock is strictly acquired before the per-handler flb_lock to
prevent deadlocks.

Link: https://lkml.kernel.org/r/20260318141637.1870220-12-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |    3 +++
 kernel/liveupdate/luo_file.c |    1 +
 kernel/liveupdate/luo_flb.c  |   16 ++++++++++++++++
 3 files changed, 20 insertions(+)

--- a/include/linux/liveupdate.h~liveupdate-protect-flb-lists-with-rwsem
+++ a/include/linux/liveupdate.h
@@ -12,6 +12,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
@@ -107,6 +108,8 @@ struct liveupdate_file_handler {
 	struct list_head __private list;
 	/* A list of FLB dependencies. */
 	struct list_head __private flb_list;
+	/* Protects flb_list */
+	struct rw_semaphore __private flb_lock;
 };
 
 /**
--- a/kernel/liveupdate/luo_file.c~liveupdate-protect-flb-lists-with-rwsem
+++ a/kernel/liveupdate/luo_file.c
@@ -873,6 +873,7 @@ int liveupdate_register_file_handler(str
 		}
 
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
+		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
--- a/kernel/liveupdate/luo_flb.c~liveupdate-protect-flb-lists-with-rwsem
+++ a/kernel/liveupdate/luo_flb.c
@@ -49,6 +49,7 @@
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
 #include "luo_internal.h"
@@ -70,6 +71,7 @@ struct luo_flb_global {
 	long count;
 };
 
+static DECLARE_RWSEM(luo_flb_lock);
 static struct luo_flb_global luo_flb_global = {
 	.list = LIST_HEAD_INIT(luo_flb_global.list),
 };
@@ -240,6 +242,8 @@ int luo_flb_file_preserve(struct liveupd
 	struct luo_flb_link *iter;
 	int err = 0;
 
+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	list_for_each_entry(iter, flb_list, list) {
 		err = luo_flb_file_preserve_one(iter->flb);
 		if (err)
@@ -272,6 +276,8 @@ void luo_flb_file_unpreserve(struct live
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
 }
@@ -292,6 +298,8 @@ void luo_flb_file_finish(struct liveupda
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_finish_one(iter->flb);
 }
@@ -355,6 +363,9 @@ int liveupdate_register_flb(struct liveu
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	guard(rwsem_write)(&luo_flb_lock);
+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	/* Check that this FLB is not already linked to this file handler */
 	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
@@ -444,6 +455,9 @@ int liveupdate_unregister_flb(struct liv
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	guard(rwsem_write)(&luo_flb_lock);
+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
+
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb) {
@@ -638,6 +652,8 @@ void luo_flb_serialize(void)
 	struct liveupdate_flb *gflb;
 	int i = 0;
 
+	guard(rwsem_read)(&luo_flb_lock);
+
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
 
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

