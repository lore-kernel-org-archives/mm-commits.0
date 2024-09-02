Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33334A0F;
	Mon,  2 Sep 2024 00:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238775; cv=none; b=BMX59CWU9uXvaHM5WCNZ5f6E6mQ8kLXJ8/uYXHFPm2Mobnkddu/VROxpJh0Agol1gVP0t/o58Jt/8W47CNdlwh/yn4tpCcYRpLa4eHajIPdjOXvhngws9oLvMw4G9wOd5YUWMKwFtuGg/+E9Anj6lftXSdNlSVfm6TaUVOsc+hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238775; c=relaxed/simple;
	bh=+f77JFb09UVmuQcrc8lOIUpmzArxFFtSJpnAEGtOLBQ=;
	h=Date:To:From:Subject:Message-Id; b=hNvsPEVaaQQ900w4u98AQfrulO8u571B632dkICwSZcvZpXE5oylK9IlYgND83pgaGCMvKcUVcBu/pZyfqQB/QL+iTna0Jiaoi7VjpdgLdLVTGvMm8xa2NS1T+NftnSUfULZft3P05XoFRb6/LjGvhggCcWWCay5FpAa4qtMSzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YenY0plC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YenY0plC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5835C4CEC7;
	Mon,  2 Sep 2024 00:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238775;
	bh=+f77JFb09UVmuQcrc8lOIUpmzArxFFtSJpnAEGtOLBQ=;
	h=Date:To:From:Subject:From;
	b=YenY0plCeRpfrboB1Xx8SRGg8nDY0uSIJ4OVRDYkCwG8l3PuY/e4EpsmfoJeU+nEC
	 ibsFx69m7urTOpc+Mz+dNzpOkI2ulDi82jyoYhhTeFWIawIHxB//2UvdRlgRMTAc1M
	 WB/aGJB6TAYyGebtBWMkAezWTXA52tXXJ1k24Hr0=
Date: Sun, 01 Sep 2024 17:59:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch removed from -mm tree
Message-Id: <20240902005935.A5835C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix missing cleanup on rollforward recovery error
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix missing cleanup on rollforward recovery error
Date: Sat, 10 Aug 2024 15:52:42 +0900

In an error injection test of a routine for mount-time recovery, KASAN
found a use-after-free bug.

It turned out that if data recovery was performed using partial logs
created by dsync writes, but an error occurred before starting the log
writer to create a recovered checkpoint, the inodes whose data had been
recovered were left in the ns_dirty_files list of the nilfs object and
were not freed.

Fix this issue by cleaning up inodes that have read the recovery data if
the recovery routine fails midway before the log writer starts.

Link: https://lkml.kernel.org/r/20240810065242.3701-1-konishi.ryusuke@gmail.com
Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/recovery.c~nilfs2-fix-missing-cleanup-on-rollforward-recovery-error
+++ a/fs/nilfs2/recovery.c
@@ -716,6 +716,33 @@ static void nilfs_finish_roll_forward(st
 }
 
 /**
+ * nilfs_abort_roll_forward - cleaning up after a failed rollforward recovery
+ * @nilfs: nilfs object
+ */
+static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
+{
+	struct nilfs_inode_info *ii, *n;
+	LIST_HEAD(head);
+
+	/* Abandon inodes that have read recovery data */
+	spin_lock(&nilfs->ns_inode_lock);
+	list_splice_init(&nilfs->ns_dirty_files, &head);
+	spin_unlock(&nilfs->ns_inode_lock);
+	if (list_empty(&head))
+		return;
+
+	set_nilfs_purging(nilfs);
+	list_for_each_entry_safe(ii, n, &head, i_dirty) {
+		spin_lock(&nilfs->ns_inode_lock);
+		list_del_init(&ii->i_dirty);
+		spin_unlock(&nilfs->ns_inode_lock);
+
+		iput(&ii->vfs_inode);
+	}
+	clear_nilfs_purging(nilfs);
+}
+
+/**
  * nilfs_salvage_orphan_logs - salvage logs written after the latest checkpoint
  * @nilfs: nilfs object
  * @sb: super block instance
@@ -773,15 +800,19 @@ int nilfs_salvage_orphan_logs(struct the
 		if (unlikely(err)) {
 			nilfs_err(sb, "error %d writing segment for recovery",
 				  err);
-			goto failed;
+			goto put_root;
 		}
 
 		nilfs_finish_roll_forward(nilfs, ri);
 	}
 
- failed:
+put_root:
 	nilfs_put_root(root);
 	return err;
+
+failed:
+	nilfs_abort_roll_forward(nilfs);
+	goto put_root;
 }
 
 /**
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

