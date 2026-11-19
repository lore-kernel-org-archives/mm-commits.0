Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066539;
	b=2hYL+U9yOqovSnuB+nPTtoJ668o1agriIYIXZcPsowGLw907jSM2cVsylUh5gFnhTGFL
	 TlDkjfwGCYGQVE86aD4Omz6RRECfRrkr/xRXC/fITmtidfD1oONQdDSoKbo1qNVkx26Az
	 WgeQAooKs3b9M27gKkHlG6bbiN0GHnDsGuLFkIXLobNvNQ0nqrkMNSMRwKKMB0JzW9OqJ
	 Zknv9y/kTnoG7Iq9AbSvOMPYH7v3nUr3tp52Jejcpj78U70It8uaf9TbV4C/DUarp1rSE
	 f2LCQs2V+fN0g9eAqpFQeoKMxxdSU47F03G/AMvLqPzKF0z+ZZfvmLsfNOETtlQ3QoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066539;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=P7DSe+2rTVqVLxWldqAm0EiX0RWne4hLwAVexkYkS0Q=;
	b=kZU5grI5ycHQmdX6V8Vt1JlX7rZq6bl5M8ov1L1UU+x0mqHwF4g6nK+rkuAheIXIZo5/
	 5oCKlTBNdQ4EOikKxmfowytxojn806lWcNJZ2oAEYfbRDm05eGqDPShMymRAB7UZxLzM1
	 CXNgGP28GtNcqKNhG/fX6JD0VMa0R4a1AlXZoGU27PL94I6OPJsMPo7lL/xS2xeWOQiLh
	 IzhpcRTM9km4X6E9OqxOIL94PF0KIg4RbP0IxRk9R87LSwjlU0swxSecXHYmPSgvLgtAW
	 A7zlATvMNmjOUwkCGFm0SxeQlUS1YVvXuVGi9mmPoE7YaeSDjaBaYnBcMVywe+dDhxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eXVA+sco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BD4606CC5B
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eXVA+sco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81BD1F000C4;
	Thu, 19 Nov 2026 05:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066538;
	bh=P7DSe+2rTVqVLxWldqAm0EiX0RWne4hLwAVexkYkS0Q=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=eXVA+scolakcCOI+JfOGvZ4r0QqFetnR8C6oWt3k3cb5ASqbRzJpEweYbtNY2LmNx
	 KzaZrEfAK6O4BzQhO0+deiM13mjZtB1KD7AUNNv2pU3RVpmOK5LPxEuOQciwdb9zyi
	 k6yCPczCSawCenLm0cBMJVKGQbfDkw9BdzJxtUxY=
Date: Wed, 18 Nov 2026 21:35:38 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,willy@infradead.org,
	vbabka@kernel.org,shikemeng@huaweicloud.com,senozhatsky@chromium.org,
	pfalcato@suse.de,nphamcs@gmail.com,minchan@kernel.org,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,jannh@google.com,jack@suse.cz,
	dev.jain@arm.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
Subject: + mm-zsmalloc-remove-unused-zpdesc_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20261119053538.D81BD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/zsmalloc: remove unused zpdesc_lock()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-zsmalloc-remove-unused-zpdesc_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-unused-zpdesc_lock.patch

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
Subject: mm/zsmalloc: remove unused zpdesc_lock()
Date: Tue, 17 Nov 2026 07:16:51 +0000

It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
trylock_zspage()/lock_zspage()") but has never had a caller.

Link: https://patch.msgid.link/20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>

 mm/zpdesc.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-remove-unused-zpdesc_lock
+++ a/mm/zpdesc.h
@@ -107,11 +107,6 @@ static_assert(sizeof(struct zpdesc) <= s
 	const struct page *:		(const struct zpdesc *)(p),	\
 	struct page *:			(struct zpdesc *)(p)))
 
-static inline void zpdesc_lock(struct zpdesc *zpdesc)
-{
-	folio_lock(zpdesc_folio(zpdesc));
-}
-
 static inline bool zpdesc_trylock(struct zpdesc *zpdesc)
 {
 	return folio_trylock(zpdesc_folio(zpdesc));
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-remove-unused-helpers-from-pagemaph.patch
mm-swapops-remove-unused-make_guard_swp_entry.patch
mm-swap-remove-unused-folio_to_swp_tb.patch
mm-zsmalloc-remove-unused-zpdesc_lock.patch
mm-nommu-remove-unused-heap_stack_gap.patch

