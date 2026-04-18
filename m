Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A29B36C598
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498789; cv=none; b=sKHChG5kh1YaiXPct8Xd7tHlLcLkQfSxuFPVFZc2I7UTrRToht9s80GbmZlN4FB5uuM7RgGdsPe3PuitZpmE/R8qwGF4i3N66Mh5ff5N1bJvohosqN6NDtzxjE/LW0DQjvGD3qUYk1FHH8+0ib9Jmn0UGaHjpmGnJEPkQtYo8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498789; c=relaxed/simple;
	bh=yeVl3+j90tj1U6Z25R+M1veT7f+s4U2hEDRXILVJC1U=;
	h=Date:To:From:Subject:Message-Id; b=oi/x6ijbOPZHYWXdQBGMGJyJdz9VRICiDH52sk8CqGGgpCU68drOnZaGCwR7D01+lVbTCDM7fsXlh7WTnoXL1Ds57YdgFJgvJBaJIJ2Zo+9ndi7Fi6TqJCW30Nqh8JcquJ+lh5zUe8woXqBGaXGn7L7bsLX0mjsMc1iu6sLp9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uODh4fV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uODh4fV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68684C19424;
	Sat, 18 Apr 2026 07:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498788;
	bh=yeVl3+j90tj1U6Z25R+M1veT7f+s4U2hEDRXILVJC1U=;
	h=Date:To:From:Subject:From;
	b=uODh4fV+JdfWGB3SBbZ/BUBzQvBQ/NTXy+pgFJGLFwPz+3qtdeMCIPOHd8owOEt+2
	 PkDGnZvY+cusaXGkQcHp6BbekX5yc0lJ+JF4yZKl8mecm41tIAHjsjvk7eQuwQ5NO7
	 EIbPPRDIROqjCkblzrI6URtvOD4x1Tbew8wncVEc=
Date: Sat, 18 Apr 2026 00:53:03 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-protect-flb-lists-with-luo_register_rwlock.patch removed from -mm tree
Message-Id: <20260418075307.68684C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: protect FLB lists with luo_register_rwlock
has been removed from the -mm tree.  Its filename was
     liveupdate-protect-flb-lists-with-luo_register_rwlock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: protect FLB lists with luo_register_rwlock
Date: Fri, 27 Mar 2026 03:33:28 +0000

Because liveupdate FLB objects will soon drop their persistent module
references when registered, list traversals must be protected against
concurrent module unloading.

To provide this protection, utilize the global luo_register_rwlock.  It
protects the global registry of FLBs and the handler's specific list of
FLB dependencies.

Read locks are used during concurrent list traversals (e.g., during
preservation and serialization).  Write locks are taken during
registration and unregistration.

Link: https://lore.kernel.org/20260327033335.696621-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h  |    1 +
 kernel/liveupdate/luo_flb.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/liveupdate.h~liveupdate-protect-flb-lists-with-luo_register_rwlock
+++ a/include/linux/liveupdate.h
@@ -12,6 +12,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
--- a/kernel/liveupdate/luo_flb.c~liveupdate-protect-flb-lists-with-luo_register_rwlock
+++ a/kernel/liveupdate/luo_flb.c
@@ -245,17 +245,20 @@ int luo_flb_file_preserve(struct liveupd
 	struct luo_flb_link *iter;
 	int err = 0;
 
+	down_read(&luo_register_rwlock);
 	list_for_each_entry(iter, flb_list, list) {
 		err = luo_flb_file_preserve_one(iter->flb);
 		if (err)
 			goto exit_err;
 	}
+	up_read(&luo_register_rwlock);
 
 	return 0;
 
 exit_err:
 	list_for_each_entry_continue_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
+	up_read(&luo_register_rwlock);
 
 	return err;
 }
@@ -277,6 +280,7 @@ void luo_flb_file_unpreserve(struct live
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
 }
@@ -297,6 +301,7 @@ void luo_flb_file_finish(struct liveupda
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_finish_one(iter->flb);
 }
@@ -360,6 +365,8 @@ int liveupdate_register_flb(struct liveu
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Check that this FLB is not already linked to this file handler */
 	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
@@ -401,11 +408,13 @@ int liveupdate_register_flb(struct liveu
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 
 	return 0;
 
 err_resume:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -449,6 +458,8 @@ int liveupdate_unregister_flb(struct liv
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb) {
@@ -473,11 +484,13 @@ int liveupdate_unregister_flb(struct liv
 		module_put(flb->ops->owner);
 	}
 
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 
 	return 0;
 
 err_resume:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -643,6 +656,7 @@ void luo_flb_serialize(void)
 	struct liveupdate_flb *gflb;
 	int i = 0;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

