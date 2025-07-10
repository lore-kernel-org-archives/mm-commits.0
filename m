Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19E469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122331; cv=none; b=ZQ+T7Seg6buo8fHUGEaH0h4bG+S1PI7Xk7ibARLdoUFB0pd9YK8a2S/Q//xm/362QWO89UqHoCcyi4npiX1TS/TSqFcBtL+yCxyfj1k8TOkZKZIwo+n8oqvloxrowrLsbUoNgyLWMwZ+XzFmromKOj7siV5CdrMsb/MievfZ1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122331; c=relaxed/simple;
	bh=mxVac+QQ4XlAdBAZzE4ByorwxHOehTSJukDlyJ9SahY=;
	h=Date:To:From:Subject:Message-Id; b=j67i4pEKvSh+5OT/MFGxWD/87aUb4xk7mqmWiupSbsB8xzDCSFbn++GLDUdJxJwASoTRzPHfhmswZdvhs+yNDsXQUyVHUbLXioyztX2cdtNm2U3nW13cpgSajya/hVVetgAZlUmAv+YNIWbLUN2uD9aVffGoBbVZJC1LW9EKyzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1fqu9xjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1fqu9xjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41C5C4CEE3;
	Thu, 10 Jul 2025 04:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122330;
	bh=mxVac+QQ4XlAdBAZzE4ByorwxHOehTSJukDlyJ9SahY=;
	h=Date:To:From:Subject:From;
	b=1fqu9xjhgwf3cNFbRHPtYDAn+PFq3nFAqzPxSmmSTuv2N9WaQZn9EGK9nU/T3fepB
	 wBws7cWP5MXqfucYcr55G2zovhykA2hUxc0b6kXdLjhKTp9l2dDxlIw2pbbCO9Nujx
	 vDLE190a4lGx0aW3zH/GE/+WTnDA3XpVTmDMslsI=
Date: Wed, 09 Jul 2025 21:38:49 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,jack@suse.cz,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch removed from -mm tree
Message-Id: <20250710043850.C41C5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix
has been removed from the -mm tree.  Its filename was
     mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch

This patch was dropped because it was folded into mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix
Date: Thu, 19 Jun 2025 12:07:05 +0100

this into the patch?
A use-after-free issue was reported againt this patch. The problem is that I'm accessing the vma after unlocking it. So
the fix is to move the unlock to after the if/else.

Link: https://lkml.kernel.org/r/ea7f9da7-9a9f-4b85-9d0a-35b320f5ed25@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reported-by: syzbot+8e4be574cb8c40140a2a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/hi6tsbuplmf6jcr44tqu6mdhtyebyqgsfif7okhnrzkcowpo4d@agoyrl4ozyth/
Cc: Jan Kara <jack@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix
+++ a/mm/filemap.c
@@ -3265,7 +3265,6 @@ static struct file *do_sync_mmap_readahe
 	if (mmap_miss > MMAP_LOTSAMISS)
 		return fpin;
 
-	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	if (vm_flags & VM_EXEC) {
 		/*
 		 * Allow arch to request a preferred minimum folio order for
@@ -3299,6 +3298,8 @@ static struct file *do_sync_mmap_readahe
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
 	}
+
+	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	ractl._index = ra->start;
 	page_cache_ra_order(&ractl, ra);
 	return fpin;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-honour-new_order-in-page_cache_ra_order.patch
mm-readahead-terminate-async-readahead-on-natural-boundary.patch
mm-readahead-make-space-in-struct-file_ra_state.patch
mm-readahead-store-folio-order-in-struct-file_ra_state.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

