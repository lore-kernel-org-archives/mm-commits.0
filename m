Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3C21ABC2
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750377357; cv=none; b=FmlcG7OKeaOrFaTfNOTWaPCNHWDokDMykAKJAxIUG+6+Ba+4m99pRSOXMZDJitrMg2Ue2Y9ODipQ6HoU8ttXwj/waVhecWUZFMIIFp3piN6oU91c9o0QGbKZ7wQ99sNe0w9uIzwEuKvUejGBoIgRDBNOn4DnWXRem0MkKkYwPrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750377357; c=relaxed/simple;
	bh=z2k+9poDsrB6F74q1/QgiCe8Gx42PXCZVLouaiSQIlM=;
	h=Date:To:From:Subject:Message-Id; b=eMpkY3WUQLOBADwZqp3LMqR+20IIYaUhjB48AvJbZiLgZyfoKBRwqbDpqGlfOPiS2xZJyUBw8RQ66TFIscQjP14goCxI+nz3I0++J8CzwkTU1Ew8hZtdkkvSaZkbZw2Xqj5dxbo54XtMwX4Yx1PdlWr0n/NMxJAE8D8ERo4a85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hcw8VpSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hcw8VpSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0703C4CEEA;
	Thu, 19 Jun 2025 23:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750377356;
	bh=z2k+9poDsrB6F74q1/QgiCe8Gx42PXCZVLouaiSQIlM=;
	h=Date:To:From:Subject:From;
	b=hcw8VpSXUvDTmTSw227fq0XqWb9YCZedDogUokAj+OmL96y9jrI6ZwvMkr7GdSzWF
	 JxaJ5peo4HCMI1QREJlHLBNNS+pE0DuI4a1Oi49t+cAFuodGdXGZ5CXdV5E8VuRXXK
	 kWYVsF9NoCUNgUff1aMsCR5M4GZvqv0JgRru/Ot0=
Date: Thu, 19 Jun 2025 16:55:56 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,jack@suse.cz,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch added to mm-unstable branch
Message-Id: <20250619235556.B0703C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch

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
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

