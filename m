Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F174A28
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467937; cv=none; b=H/+ARractlzro/xfJBeGZoXn2bbgYDo5zelTFeLMZfgTVwUYUqFuFP1dJ0/s99ayilFOIa/l1d/Kj+kQWuKpjQ6R2I0xBsTTPA+T7mC2q/1cb7Q2Kn5+DGfoYGGoBZuVQo5b6j+Trigijcqtuxze8X0KCCAdN93X4lZ1vtpH9eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467937; c=relaxed/simple;
	bh=BVajozwELIwLBPTI7K5SSdkIzTZ6876J2tWZWXLDcMc=;
	h=Date:To:From:Subject:Message-Id; b=kKKBvnRNHGoXH4MpU/2Jc3mq0HBSQFTJ2QVUAwYSil9QGEC34xxXoUzCygIRFma9XawpkFLpm98DChi+vcbUM/OQDKLgZtApRyqggq6cx8QrbKejf0IFXjmQVDWLPU1WIJyEhDQbBa+VqUfC4wwbvZ2Pp+wHe4pMTSmdi4fmPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ar5MyX3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ar5MyX3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB69DC2BBFC;
	Sat, 11 May 2024 22:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467937;
	bh=BVajozwELIwLBPTI7K5SSdkIzTZ6876J2tWZWXLDcMc=;
	h=Date:To:From:Subject:From;
	b=Ar5MyX3siM+G5f9byiyY9brCbqsq+ZcBf6cax4oht0lY+3aDa5tZ/K0NV3HuhXLQK
	 Rs94ODJP9eXGXyUNMZAzoBH1DkQC4fsoo2dqY5YAoMLgPz1i3vzsATAUSgzHemJ7/H
	 Nfk36DK4o3GyOyQcT3KvlnvEA1Z0GX9ZZXzldjLc=
Date: Sat, 11 May 2024 15:52:16 -0700
To: mm-commits@vger.kernel.org,song@kernel.org,peterz@infradead.org,lkp@intel.com,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch removed from -mm tree
Message-Id: <20240511225216.DB69DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove calls to folio_set_error() and folio_clear_error()
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: remove calls to folio_set_error() and folio_clear_error()
Date: Tue, 30 Apr 2024 14:09:01 +0900

Nobody checks this flag on nilfs2 folios, stop setting and clearing it. 
That lets us simplify nilfs_end_folio_io() slightly.

Link: https://lkml.kernel.org/r/20240420025029.2166544-17-willy@infradead.org
Link: https://lkml.kernel.org/r/20240430050901.3239-1-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c     |    1 -
 fs/nilfs2/segment.c |    8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error
+++ a/fs/nilfs2/dir.c
@@ -174,7 +174,6 @@ Eend:
 		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode));
 fail:
-	folio_set_error(folio);
 	return false;
 }
 
--- a/fs/nilfs2/segment.c~nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error
+++ a/fs/nilfs2/segment.c
@@ -1725,14 +1725,8 @@ static void nilfs_end_folio_io(struct fo
 		return;
 	}
 
-	if (!err) {
-		if (!nilfs_folio_buffers_clean(folio))
-			filemap_dirty_folio(folio->mapping, folio);
-		folio_clear_error(folio);
-	} else {
+	if (err || !nilfs_folio_buffers_clean(folio))
 		filemap_dirty_folio(folio->mapping, folio);
-		folio_set_error(folio);
-	}
 
 	folio_end_writeback(folio);
 }
_

Patches currently in -mm which might be from willy@infradead.org are


