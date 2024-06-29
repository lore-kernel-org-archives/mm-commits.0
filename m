Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17108488
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627501; cv=none; b=R+STRu4o0LR5NP8qcOR2sTmHlzu1p2DA7QN4QCB+RMQVJeoiXgB8rQyt2NQH/FaV2G8Moc4225TjK492b8rTu8tDiHU87yS+sD380rB+NVGwp9CtcFxuoS2ecEwg8AvuRDQOo/tdATbq4fMSFgKh/u5CbmD1QtWlLFtKbM6FfXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627501; c=relaxed/simple;
	bh=t05lb5U8ntT+vLB8zd26GFcyZVYUsisrHzvzJpTRCfc=;
	h=Date:To:From:Subject:Message-Id; b=V2lRWPIASv2UkChrKB6L3w1HVcqQpyikRmDDG16reTRNM/U5hYWn3jVl5qUc40iKgydJuMxMTkfxppbnvw92aP92oa89UKw95932uOju+TVcBoHk7fQeYgoYn9h7FwQY0YuK3HJTAquRIJqaV69/FlhxoV5FtOf8VhuVp9AHttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wk0oyvVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wk0oyvVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F15CC116B1;
	Sat, 29 Jun 2024 02:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627501;
	bh=t05lb5U8ntT+vLB8zd26GFcyZVYUsisrHzvzJpTRCfc=;
	h=Date:To:From:Subject:From;
	b=Wk0oyvVnc3EwSVqk/A6HqAO1gelr92KbVNlTUy2HbjzRYJDDgfOO6+Fd4t1agDirj
	 NbJPFLzzCsPVHX2OHPB0vJM/N6sGvJDJ0M+yAi29vG+83od5kYMO72CN22hnm3n21a
	 /XNdU4GK1C0O9Tu58TI/S0o2e6jO1CQO8XJqSCas=
Date: Fri, 28 Jun 2024 19:18:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,david@redhat.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch removed from -mm tree
Message-Id: <20240629021821.0F15CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix
has been removed from the -mm tree.  Its filename was
     mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch

This patch was dropped because it was folded into mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix
Date: Wed May 29 12:04:52 PM PDT 2024

fix PG_hugetlb typo, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix
+++ a/include/linux/page-flags.h
@@ -945,7 +945,7 @@ enum pagetype {
 	PG_offline	= 0x20000000,
 	PG_table	= 0x10000000,
 	PG_guard	= 0x08000000,
-	PG_hugetlb	= 0x04008000,
+	PG_hugetlb	= 0x04000000,
 	PG_slab		= 0x02000000,
 
 	PAGE_TYPE_BASE	= 0x80000000,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memoryc-fix-used-uninitialized.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

