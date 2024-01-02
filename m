Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106BA15ACB
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dEDs+Wmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1CAC433C8;
	Tue,  2 Jan 2024 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704222492;
	bh=T+xgOwJFYGRe+I1DIibPO9oMkqTsfXsKenuDLZlWLjM=;
	h=Date:To:From:Subject:From;
	b=dEDs+WmoEgk3IvMqmD7CYMXIpRv85CKf6EFkVkl0m7afbepXpZLSnvndWgB7Se2fz
	 5wPGCQLpW/sx3C0tr5nmO+wweuXEFmAPNHaoSSzRtMa9B2qw6LZVUOzZ32KqqaI9B/
	 TZXJ67GUONm4vxuFj/Ruis7BpX4XTh5/cFELOOR0=
Date: Tue, 02 Jan 2024 11:08:11 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-unintended-successful-return.patch added to mm-unstable branch
Message-Id: <20240102190812.8F1CAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: buffer: fix unintended successful return
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-unintended-successful-return.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-unintended-successful-return.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

buffer-fix-unintended-successful-return.patch
mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

