Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E539C637
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456148; cv=none; b=BiurrSzpjkINTKQocquaT+/X3pZUE53Axhl8ap26UFzVuvUVGjwby3ggW4/pV+WpLw2wN6elS6GYDWpsDl25DsPoXwQE1eWsa7MqKaP13aYsLICr3LUaMgNhIz7qJY6g/4fOUaYyRHdeufF2ZwV2YGqZg6OA0+4vyJ5Qlg5KoFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456148; c=relaxed/simple;
	bh=blt/Ue4DMRMpxfTkSEMwIZ7QD7l8gmN0h5c15HoeS+k=;
	h=Date:To:From:Subject:Message-Id; b=IPMUSTz7x5bAMtLOMhvTzIHYDNuU8v31tnDJMETDiBkq8APa5XCa1FETkjdIHIOlP/GKkNykR6SOtkdeYaqZrQCE1LXodKifqvbGCuA2sBDzUYnM4vnqg3hBSeTEffgmL5ZJ7tdMF1qbQCqES7I0eJbA3Lsqr1gbhKH1QEPAoME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SFWgldCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SFWgldCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6391F000FF;
	Sat, 26 Sep 2026 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456146;
	bh=01DRyhqMebI3HB+SJDC2RAvytO8Sp5MHT68BdvxhgTA=;
	h=Date:To:From:Subject;
	b=SFWgldCcc7RhXmAV2No70vRCeHrW0HxFScgy7jfqBFhrwe4bOj29fTX3UMlbjrOLN
	 ZL+ONS6/D5vGyluyBI3SRJ1HfonkbQGwBl3JmEUbu/2z5sbpDFFb2nMdh8y79Wu2Cq
	 qi10jQSWZsOxHxh/G8daD7pMU9KN31+3+5akxwyw=
Date: Sat, 26 Sep 2026 13:55:46 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-heming-zhao-as-ocfs2-reviewer.patch removed from -mm tree
Message-Id: <20260926205546.8E6391F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Heming Zhao as ocfs2 reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-heming-zhao-as-ocfs2-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

