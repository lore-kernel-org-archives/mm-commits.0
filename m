Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066537;
	b=F4/rI8MbartTG4ckMYC1+QB5tTBNppNbbYsBX5bJQ2bF7axk8E2QrEXlEvEbmkiPmN2r
	 sSkiYFg4tukuhD6pCz6ALZtDboJbrSd7a9UA4TW6P73a9b1KoH5/t4RiUSmd7JURlVN87
	 ACwlrGkWUID+EZAcNIsA+NaETMD6eBptdDzGJh3EfJX0kZL+Bxmhhky73SOpgwE2Lv37y
	 xor8C01N7sqBNu+ysWobWIrPmuJrHAN1AQcwy17k1NdinnHI8ELp/7qTpNtqZXvyqnNqv
	 laFyB4V3GA9ZMx9bHH8b0om4Ay4OAiIrWXlnOpmLlW0UACUNlptE8VF4J1YOFOsrdSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066537;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=LluL5xLTabcxIVPDpRZgdlsKpF8rq5W+znvc4nNxeuk=;
	b=jWzDK8k2OobIFh6CYpODejaTbBd2LSul3NpvBL2VjJGrkZrd3dvPwsmPM8OFzJcT7Hqc
	 yKkGpoo3RZUNNfR6g0fk+2BDTqtVlJt9tr4jUDkL1nqcuiDhqLbuqgM3WCxFydY9aNYf9
	 8nQfDrWXf6yTW5Y5E5r8nv6rxcQRRp0aNt5UpNnJKmQmXQQrfcMHgor8w3AUDE48btTDh
	 sa/91a68HwD+yw0TBnrgWPek69Y8EaXh+j1dKlzfWO6frR21dxdvr14CLc28KL1XgX468
	 obslbC1wxP+k2vBrQI0ZgmvkYhNbrortmBJvQwilzT1Efv0V6KYozh4PD+Bu02uN1iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jpi0UbAx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F223606BE37
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jpi0UbAx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09A81F000C7;
	Thu, 19 Nov 2026 05:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066536;
	bh=LluL5xLTabcxIVPDpRZgdlsKpF8rq5W+znvc4nNxeuk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=jpi0UbAxNyh29iD4lBG04U5ziEDO1pUd47XZwYgP7gzr0wDctmeO7CPsVx80Yr+9O
	 H191eUNEfBcZ9i6xbYbSWRNHe8n3rgLEClxTlhY21ZwlFuQ+/hcplDEQi0ng6GG0WO
	 9wDnbF1HEUqxOyyPYBirQ7PeMQGd7SHGXy7PLhIU=
Date: Wed, 18 Nov 2026 21:35:36 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,willy@infradead.org,
	vbabka@kernel.org,shikemeng@huaweicloud.com,senozhatsky@chromium.org,
	pfalcato@suse.de,nphamcs@gmail.com,minchan@kernel.org,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,jannh@google.com,jack@suse.cz,
	dev.jain@arm.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
Subject: + mm-swap-remove-unused-folio_to_swp_tb.patch added to mm-nonmm-unstable branch
Message-Id: <20261119053536.B09A81F000C7@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swap: remove unused folio_to_swp_tb()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-swap-remove-unused-folio_to_swp_tb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-unused-folio_to_swp_tb.patch

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
Subject: mm/swap: remove unused folio_to_swp_tb()
Date: Tue, 17 Nov 2026 07:16:50 +0000

Its last users were removed in commit 0d6af9bcf383 ("mm, swap: use the
swap table to track the swap count").

Link: https://patch.msgid.link/20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>

 mm/swap_table.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/swap_table.h~mm-swap-remove-unused-folio_to_swp_tb
+++ a/mm/swap_table.h
@@ -135,11 +135,6 @@ static inline unsigned long pfn_to_swp_t
 	return swp_tb | __flags_to_swp_tb(flags);
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned char flags)
-{
-	return pfn_to_swp_tb(folio_pfn(folio), flags);
-}
-
 static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned char flags)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-remove-unused-helpers-from-pagemaph.patch
mm-swapops-remove-unused-make_guard_swp_entry.patch
mm-swap-remove-unused-folio_to_swp_tb.patch
mm-zsmalloc-remove-unused-zpdesc_lock.patch
mm-nommu-remove-unused-heap_stack_gap.patch

