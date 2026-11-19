Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066541;
	b=R05hAV3xOJt04qWffhBvBtwvuRGBRZk5PdZr8Hc0/5jEBmJAxi0sm8IvmVjdsLCjb7uL
	 6Ge+IN4pIJRb/vutkClWDlp7pxLRa6dYLPhHB2zeKzo+25IX2S306qU6HeVefTVkwBwWO
	 pBcWbb3081F8muAI2j+J8yr9MwWSWJH2DW+NzX5rwEBVdsO1GTNdDAu0xNlo6CxvFJ5Zj
	 gjm07F45urujpSigZC/NGO0Xrx16CwyeRjreaTl4OfYPoYhnR9CzNJ6hntvhoEjJYYclE
	 /1lh5VlVvfnN7+z8zfjGt5VcHT3jXktn3lNkSvKhUDvpb8j7HSVMSCVqyxaLKgQ1fpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066541;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=PfRO+5lGq9vC1lGMG9bKEcYzlfCnizJPaLUK7H8tGio=;
	b=0lYnrQqASn4NudJziVolxfUi6uxvung9tCdFlEp0HhvLULmf8fTSTuERHEB9Inu4zrdD
	 d532mdvOHOLL17skh09uKCSINZSkyPzFHJQdCJVCPkssA8bsa2cVt9mTPygQvskOd0njk
	 yOx0VWgSVkkBw/bLnF71eTwPpL188R0DDJ5y/8cYTygIZ55arYIein0d7g80xFVdm/gue
	 rDtn9fsLbTrNN2PTwtE86B9ZEhc3Ka4E/9EXIzOxDJ1ZFYhti6gu37kDTeFLzPcrh5RwX
	 K1cxT68gsH3w5qyLkVCVJhtNLdYIl1glqAegdwXFSu8RWIr+hSCFg5s21qI/eVelDdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zBLdyxYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7926A606D91D
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zBLdyxYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EC81F000C4;
	Thu, 19 Nov 2026 05:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066541;
	bh=PfRO+5lGq9vC1lGMG9bKEcYzlfCnizJPaLUK7H8tGio=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=zBLdyxYPKyd+V9hNJDyUmVRPXaecZLnCTj/ez672jm15Yl8WPg4iwil/68R+zICkm
	 eFM+ZU3t19JjE1xTrc1oIfObXonN/F1zRrtIxopP08a5CBweYE7wB+xdeb4XO27x3I
	 b5msOv98sB3IrE4EcgYHm/F51rLDL9Yleoc97Gkk=
Date: Wed, 18 Nov 2026 21:35:40 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,willy@infradead.org,
	vbabka@kernel.org,shikemeng@huaweicloud.com,senozhatsky@chromium.org,
	pfalcato@suse.de,nphamcs@gmail.com,minchan@kernel.org,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,jannh@google.com,jack@suse.cz,
	dev.jain@arm.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
Subject: + mm-nommu-remove-unused-heap_stack_gap.patch added to mm-nonmm-unstable branch
Message-Id: <20261119053541.03EC81F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: nommu: remove unused heap_stack_gap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-nommu-remove-unused-heap_stack_gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-remove-unused-heap_stack_gap.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm: nommu: remove unused heap_stack_gap
Date: Tue, 17 Nov 2026 07:16:52 +0000

heap_stack_gap has been unused since at least the start of git history,
commit 1da177e4c3f4 ("Linux-2.6.12-rc2").

Link: https://patch.msgid.link/20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com
Link: https://lore.kernel.org/linux-mm/20140430083620.GA4711@dhcp22.suse.cz/
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>

 mm/nommu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-remove-unused-heap_stack_gap
+++ a/mm/nommu.c
@@ -43,7 +43,6 @@
 #include "internal.h"
 
 unsigned long highest_memmap_pfn;
-int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-remove-unused-helpers-from-pagemaph.patch
mm-swapops-remove-unused-make_guard_swp_entry.patch
mm-swap-remove-unused-folio_to_swp_tb.patch
mm-zsmalloc-remove-unused-zpdesc_lock.patch
mm-nommu-remove-unused-heap_stack_gap.patch

