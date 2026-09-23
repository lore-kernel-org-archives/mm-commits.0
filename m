Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1D737F309
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 02:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790130613; cv=none; b=T70mF5Gm589lHgG5hzYVCEtcl6vQu7CSF3Am31LB68++doqixBWlGznFyrIvDMYK3BP6RfqBXoIOjXMLVAJa6+sPHjXSL0tBhppc9XztRiyI8V4lgW0bxDLyT8+07jqK/8Vs2CdOvjKPbr9zucaV98+4nVxqbY6pIQ68s84uc3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790130613; c=relaxed/simple;
	bh=7qvHJKPUkq9BT+OdMwXMTtKYgKVV5PiPg31Ha6qeM7c=;
	h=Date:To:From:Subject:Message-Id; b=e7Kx9qPZZw0L6jtKB6kGXDLbnbYmTiO73N/VHOC2j7oI5bbP+W2hh7X8Mv7vFqIDbt8TVMNIygwIQkJ9X0ytDKh+8GlSCJw55EoQo9YtThNrRIlzV5Tt8oESQH5J5Gt3xxOtTMODKpxAplulETcoJDp0XKeJYNNtp4SKXxey3/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YshBPPDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YshBPPDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F3E1F000FF;
	Wed, 23 Sep 2026 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790130611;
	bh=pyeuyFkhZg1YVfqKhWqPrmZZbC9R1LrofwchvrmDIyM=;
	h=Date:To:From:Subject;
	b=YshBPPDbzNgrz4tRCHTXP/aC6b6yPKp9FN48joaq0qpw5N+7fZUCdSipNvYiGutuV
	 4khYFCJVV94jvh3fEV3osVxHYeLDr0PQRBMJAnvr9ZIKvf0ROzflyOmetYkWVA/U7H
	 gjtcoYksJwKt/cm20o4o6NZImLypBI34KPZS3hxE=
Date: Tue, 22 Sep 2026 19:30:10 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-heming-zhao-as-ocfs2-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260923023011.53F3E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Heming Zhao as ocfs2 reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-heming-zhao-as-ocfs2-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-heming-zhao-as-ocfs2-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: add Heming Zhao as ocfs2 reviewer
Date: Wed, 23 Sep 2026 08:39:20 +0800

Heming Zhao has contributed ocfs2 a lot recent years, both as a author and
reviewer.  So add him as ocfs2 reviewer.

Link: https://lore.kernel.org/20260923003920.2382398-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mark Fasheh <mark@fasheh.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-heming-zhao-as-ocfs2-reviewer
+++ a/MAINTAINERS
@@ -20568,6 +20568,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mark@fasheh.com>
 M:	Joel Becker <jlbec@evilplan.org>
 M:	Joseph Qi <joseph.qi@linux.alibaba.com>
+R:	Heming Zhao <heming.zhao@suse.com>
 L:	ocfs2-devel@lists.linux.dev
 S:	Supported
 W:	http://ocfs2.wiki.kernel.org
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

maintainers-add-heming-zhao-as-ocfs2-reviewer.patch
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
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

