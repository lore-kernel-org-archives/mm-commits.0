Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE17D35892
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9ifrz/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A83C433CB;
	Fri,  5 Jan 2024 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478709;
	bh=IvIC5VDqHMlpchvXIyxzPp6YpxBL9vw5rRRV685uC00=;
	h=Date:To:From:Subject:From;
	b=X9ifrz/0Pzvz6KA5B2oanck/QA+BPMT4HguJsbbFtam3VCTX3gENMvcWchl2Z1Olo
	 /hrKObBbpjAPBofuLuyaJMb0nF7yN8sQBwUHowPuo4YrOLVCy/OHH6yam+IotkSRr2
	 lTh/dn2p1gD8DA6WqqqQKB7AemNtOBGwGuIGhtos=
Date: Fri, 05 Jan 2024 10:18:28 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-fix-unintended-successful-return.patch removed from -mm tree
Message-Id: <20240105181829.40A83C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: fix unintended successful return
has been removed from the -mm tree.  Its filename was
     buffer-fix-unintended-successful-return.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: fix unintended successful return
Date: Mon, 1 Jan 2024 09:38:48 +0000

If try_to_free_buffers() succeeded and then folio_alloc_buffers() failed,
grow_dev_folio() would return success.  This would be incorrect; memory
allocation failure is supposed to result in a failure.  It's a harmless
bug; the caller will simply go around the loop one more time and
grow_dev_folio() will correctly return a failure that time.  But it was an
unintended change and looks like a more serious bug than it is.

While I'm in here, improve the commentary about why we return success even
though we failed.

Link: https://lkml.kernel.org/r/20240101093848.2017115-1-willy@infradead.org
Fixes: 6d840a18773f ("buffer: return bool from grow_dev_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/buffer.c~buffer-fix-unintended-successful-return
+++ a/fs/buffer.c
@@ -1028,8 +1028,8 @@ static sector_t folio_init_buffers(struc
  *
  * This is used purely for blockdev mappings.
  *
- * Returns false if we have a 'permanent' failure.  Returns true if
- * we succeeded, or the caller should retry.
+ * Returns false if we have a failure which cannot be cured by retrying
+ * without sleeping.  Returns true if we succeeded, or the caller should retry.
  */
 static bool grow_dev_folio(struct block_device *bdev, sector_t block,
 		pgoff_t index, unsigned size, gfp_t gfp)
@@ -1051,10 +1051,17 @@ static bool grow_dev_folio(struct block_
 			goto unlock;
 		}
 
-		/* Caller should retry if this call fails */
-		end_block = ~0ULL;
-		if (!try_to_free_buffers(folio))
+		/*
+		 * Retrying may succeed; for example the folio may finish
+		 * writeback, or buffers may be cleaned.  This should not
+		 * happen very often; maybe we have old buffers attached to
+		 * this blockdev's page cache and we're trying to change
+		 * the block size?
+		 */
+		if (!try_to_free_buffers(folio)) {
+			end_block = ~0ULL;
 			goto unlock;
+		}
 	}
 
 	bh = folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
_

Patches currently in -mm which might be from willy@infradead.org are


