Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF54258EF4;
	Sat, 13 Sep 2025 20:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794167; cv=none; b=VM+ZMsKBT//hPNLJdtXulDK+uDGDEuf0tjSZjKMU2DcHabOj3Qwp7ORiE0r5cCF78pQJ6bB8ThsjpdHMmcxKDJJQvlNlYljMPfcvREyJQaMFekdwhCPYuZz4evZLYp1a/9sMOLs3Z8zks4/yEKb+VHdb28gGbLjxZVUe7srUWPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794167; c=relaxed/simple;
	bh=JcEtxV2oPd8E5doDvFAK0j+6xSCOLDUCCR7aokuDBr4=;
	h=Date:To:From:Subject:Message-Id; b=EG1ciRTcBl0EyIbvmLpuRZiQKl/qP1GXwrex10TTxXJSGNjnQtjZ62NITI+AFylg+1EGDqeShrZyMJRYbD9rgfMeG7LAcqNmRUI96wp9CJGv+Lg9MlJ5d1fJMblXmo+2G3wXMtCON9lne1snbXhnOsyFj+CITtobMGSZFIkjWgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OKhPmlIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OKhPmlIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A75C4CEEB;
	Sat, 13 Sep 2025 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794166;
	bh=JcEtxV2oPd8E5doDvFAK0j+6xSCOLDUCCR7aokuDBr4=;
	h=Date:To:From:Subject:From;
	b=OKhPmlIof1HnxWs7lK133NF1TAIFNoAuS2hspLxLH4VqTdIlPZsTAseQnTSjL1RS1
	 YNQ4V/ziZ3bbf997DiJ+/VX6nT0sYUdsSywxONLtWiNehzoe5FFHDgHKER3V7Oeyoz
	 WLPc4ZGdusWt1k5ShkxcvRWeeZELDo8dgFQm6EhQ=
Date: Sat, 13 Sep 2025 13:09:25 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch removed from -mm tree
Message-Id: <20250913200926.66A75C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: revert "mm: vmscan.c: fix OOM on swap stress test"
has been removed from the -mm tree.  Its filename was
     mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: revert "mm: vmscan.c: fix OOM on swap stress test"
Date: Mon, 8 Sep 2025 15:21:12 -0700 (PDT)

This reverts commit 0885ef470560: that was a fix to the reverted
33dfe9204f29b415bbc0abb1a50642d1ba94f5e9.

Link: https://lkml.kernel.org/r/aa0e9d67-fbcd-9d79-88a1-641dfbe1d9d1@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test
+++ a/mm/vmscan.c
@@ -4507,7 +4507,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from hughd@google.com are

mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

