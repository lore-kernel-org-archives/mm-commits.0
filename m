Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3E77C6EB
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103947; cv=none; b=IVzyimYwy/0QUp9NM4lnp0BSOSjNvwmTmVkq68AM2iIRgq9O9Wk8rJTPt7LK10hHvfbFiy6ajAY7zLVXij+3KTVAXD/WjDg43ILYrHXgdzUNuiT+NH5slbh5Bx/FXGgb8vcBf1eY4DuYLQTFSZVQUL7Lq/j6gKAYum8HR2aE1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103947; c=relaxed/simple;
	bh=k2YqHSaOnolaFHevsSFxeFZDZ3RcO/8d1hqbos6lrfE=;
	h=Date:To:From:Subject:Message-Id; b=qKY+TkW/tEOp2bKO4c24AP42r5+TCcquIpqtllrjYQyFYAJd9bQ0ev/lC5mpJk8Qu9VeV5Onvw+RIozeIco4/ygii3NgnE11W+TlDvg+AaqtHFxCVDTWpIcfSJGn5GH7MnL3TWspFPjwj4dxsoU3ZGTT5Gcwolusn2qRVlCdyeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e6c7UAE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e6c7UAE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB81DC113CD;
	Fri, 26 Apr 2024 03:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103947;
	bh=k2YqHSaOnolaFHevsSFxeFZDZ3RcO/8d1hqbos6lrfE=;
	h=Date:To:From:Subject:From;
	b=e6c7UAE7GSS2EPw097q4qw9mZbhXYmbs77oVbVWvcyeeQtXia6/5PuUZFP9KTfHsE
	 0LL5huxw4TYo2nH/E9GPsxfs8psfsDfpNOOOqc3TW85Eibi5WvRr5Mi9bfQzYBVszE
	 K4dY1aR0uOA7ZFNPPtU6KzJJbGIiMla4ProlbSso=
Date: Thu, 25 Apr 2024 20:59:06 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-make-__pagemovable-return-bool.patch removed from -mm tree
Message-Id: <20240426035906.EB81DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: make __PageMovable return bool
has been removed from the -mm tree.  Its filename was
     mm-page-flags-make-__pagemovable-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page-flags: make __PageMovable return bool
Date: Thu, 21 Mar 2024 11:22:56 +0800

Make __PageMovable() return bool like __folio_test_movable().

Link: https://lkml.kernel.org/r/20240321032256.82063-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-page-flags-make-__pagemovable-return-bool
+++ a/include/linux/page-flags.h
@@ -707,7 +707,7 @@ static __always_inline bool __folio_test
 			PAGE_MAPPING_MOVABLE;
 }
 
-static __always_inline int __PageMovable(const struct page *page)
+static __always_inline bool __PageMovable(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
 				PAGE_MAPPING_MOVABLE;
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-mmap-make-vma_wants_writenotify-return-bool.patch
mm-mmap-make-accountable_mapping-return-bool.patch
mm-page-flags-make-pageuptodate-return-bool.patch

