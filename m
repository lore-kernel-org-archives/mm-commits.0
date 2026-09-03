Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524143839A3;
	Thu,  3 Sep 2026 18:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788461307; cv=none; b=OdI1H54wEw7yb+GFyMfwr8LPdoTwS48R19m97e1L8PibDp8ggJLuFiWO8WOWJh226+OfVcxOey0RIIJAqnDFoHlzqkbxjPzQeSIzsu4DXxvAXjK52YAjhtSF80JS6orPmp7JqSkG+VKFmiUUacNrM9SSTgG6V/zpmid7iLeBd/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788461307; c=relaxed/simple;
	bh=eYqJkW8WQGe1IHlUm/v/qniQukq4VSbN/p+PUerw6Mk=;
	h=Date:To:From:Subject:Message-Id; b=IxdxRRwjzmNzbnqJxcqFjb5yikIqs1BFSLBTP0YmcAUr42JXVrF8Fdv2QGN4vyIcxnbgAR+zrV0KH4xZPTxa29lJsA4h2UOffh34k5m1jHKaWHLerbcKDmQm1mzKUxVbiNEeXc0mH9S/UP0kfL+USGsT3eGqWALagazLx/hcaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEFWWmmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEFWWmmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DB01F000E9;
	Thu,  3 Sep 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788461304;
	bh=WcfGjHZDh5Z2IlTjPsvPr96hVOC/VO6nnIgpt7fLAwQ=;
	h=Date:To:From:Subject;
	b=QEFWWmmcuY//P7BtQA94WBtPmMDIx4HqCY87gqTempLKuWTEWij8UTQPXqZIPKopW
	 dsigV7Uk98wYLmGHClku3RSRE4YQ8exIQfhDXSAofDbKl30YnDAuM2jIxA2oIq5jgU
	 cpXb2egrO9DF4z46YzGlOEXoW8jjy9jF8xirFbJw=
Date: Thu, 03 Sep 2026 11:48:24 -0700
To: mm-commits@vger.kernel.org,tangzw515@gmail.com,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch added to mm-nonmm-unstable branch
Message-Id: <20260903184824.93DB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Thu, 3 Sep 2026 18:47:44 +0800

A hard readonly mount skips ocfs2_dlm_init(), so the per-osb lock
resources are never initialized and osb->cconn stays NULL.  Before commit
550842cc60987 ("ocfs2: fix freeing uninitialized resource on
ocfs2_dlm_shutdown") ocfs2_dismount_volume() only called
ocfs2_dlm_shutdown() when osb->cconn was set.  It now calls it
unconditionally, so unmounting a hard readonly mount drops the osb locks
and takes the never initialized l_lock in ocfs2_mark_lockres_freeing(). 
With lockdep enabled this triggers:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

ocfs2_drop_lock() and ocfs2_lock_res_free() already skip lock resources
without OCFS2_LOCK_INITIALIZED.  Add the same check to
ocfs2_mark_lockres_freeing(), which is reachable before them through
ocfs2_simple_drop_lockres(), so an uninitialized lockres is never touched.

Link: https://lore.kernel.org/20260903104744.2164235-1-joseph.qi@linux.alibaba.com
Fixes: 550842cc60987 ("ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: ZW Tang <tangzw515@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing
+++ a/fs/ocfs2/dlmglue.c
@@ -3525,6 +3525,10 @@ void ocfs2_mark_lockres_freeing(struct o
 	struct ocfs2_mask_waiter mw;
 	unsigned long flags, flags2;
 
+	/* We didn't get anywhere near actually using this lockres. */
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
+		return;
+
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch

