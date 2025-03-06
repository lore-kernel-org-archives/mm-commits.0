Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C5E367
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 03:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233246; cv=none; b=MusNFuKg91i3VtW2G/+TvLoRIhSavNBnCJ4pnKFYzj1h69PQexQdi1wL8ylMVZuf9fVlfrCahQgMc+kRG1qK3P2iO+WoThfrMxuttfT+8KyPh5bZ1aNLp2eqVsy0sXAJjKyBqAoSx56DTnbzRQXyvWsEAAboSW5ZtrYx1uCRebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233246; c=relaxed/simple;
	bh=zKc4nf+IoBvuCC0SN+LSCjij6+uw+NlsfFaBVZFHiOc=;
	h=Date:To:From:Subject:Message-Id; b=hPUOXicvte2BchJEgGjYPdUzDCrGeIom4WuE6uGddOqyaSSmQmWOkga/Li/IDoN08hvVyEChvxubH/kh7XYns6YhIqot2SLH+9BzEscllabq7JCrv76WObj8Z+ss+CCcfn63uhv9jN5fE8WbZOSy1PSvZt9BKKyrx5Z2ctUkyww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kQyUqdLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kQyUqdLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9583C4CEE4;
	Thu,  6 Mar 2025 03:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741233246;
	bh=zKc4nf+IoBvuCC0SN+LSCjij6+uw+NlsfFaBVZFHiOc=;
	h=Date:To:From:Subject:From;
	b=kQyUqdLEy8XERcqQGavrq3ljg84ebIN1R3MHaLlN7f5YHwpFDWGOV3SKwA+gqvpQ2
	 iOgthNiYHlDvk16nEQzmta4R1DlkV5gUJVQlqBwJeUD5XWOOqmwJvrR1yMFVd9HHqg
	 zkse7kzviJEqpRV0IX5cEGePWkIhg0E7gbqgZo54=
Date: Wed, 05 Mar 2025 19:54:05 -0800
To: mm-commits@vger.kernel.org,trond.myklebust@hammerspace.com,snitzer@kernel.org,anna.schumaker@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch removed from -mm tree
Message-Id: <20250306035405.D9583C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
has been removed from the -mm tree.  Its filename was
     nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch

This patch was dropped because it was folded into nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
Date: Mon Feb 24 10:53:31 PM PST 2025

fix build

Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
+++ a/mm/compaction.c
@@ -3181,7 +3181,7 @@ static int kcompactd(void *p)
 	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
 	long timeout = default_timeout;
 
-	tsk->flags |= PF_KCOMPACTD;
+	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3238,7 +3238,7 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
-	tsk->flags &= ~PF_KCOMPACTD;
+	current->flags &= ~PF_KCOMPACTD;
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-initial-refactor-of-move_vma-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

