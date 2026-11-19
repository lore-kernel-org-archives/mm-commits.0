Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066534;
	b=jynEbu3LaJ+/57Jg2hITYMHGcmjD81E7lbvKXJXUdNF/omXHrpm3zt7IPssdMzud+7pB
	 ybWB80uc/WbIEwj5QeZLMIB8yXp+9UT1j723FEtTIuA2FWzVUdmaQcb2jwaK62IDSDMHm
	 fzPtJtVQCbk0O1nf0PtYtRs4da4bqZXAFyljA5iKyYhk5rCiq4dAv6EEn3Th6cbuWXtAb
	 ELn1Zc6E/lCJEI72t/t8SSpDlccUo0SlDot1kyg9wQiIOZOVF2bg6nS2pNPJsSzK/x+kV
	 NM329VpLGqBWTZR/CeyZYEY3yyRiXxmD44XPL0GUf14n/4wXTLrhDWYZi+i2ZtbXOhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066534;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ad6aPithCKwiqs2EsL8gF8eJSyGNsQyjUL0rvrqdSFA=;
	b=rka4ZgoAJOBBJHflqPbUJQ3tjssRUtJIAAi3bBPk+IKjZSmsQ3+UGCH6JqPFCRu+5W5X
	 ifaSFMNP56p8cNmVu2JQoyRfGjOzYhFomAtpZfPSvWdyEvUX9HZTB189oI7P3XhmFnkBA
	 6GyQElXhE8gdJ5fc6QZ/kLIOWa+6kcJsKNsIXofhVB02SuVQRdiwtDqOPPkA8I9Occuv4
	 o9WVgOMjjY/3BVnbGycKi7ug0EiO6ULZEqPdZCnoLYNufmEzbPzoWDqYOdyKA/MqcvcpA
	 twiOuUdxETzzCYLHV1NQf4RP5qhxly+4dJf7zZbW8pk5UTAgfiPctrW6Frc2GhbXgAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EAqMKVEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD235606BE2C
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EAqMKVEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3701F000C5;
	Thu, 19 Nov 2026 05:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066534;
	bh=ad6aPithCKwiqs2EsL8gF8eJSyGNsQyjUL0rvrqdSFA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=EAqMKVEopWsaLa5kTABl5iRcs6Mn9Z+NiYbBnRlkeZFtQtZdkYjwzQw8hBUa6ZBHL
	 A+q+FlPcqazrnhEff0CkIjTfTZLiRt4ikoTvfiVcU12YOmIXCw6a/ZefMIWOnc1jGQ
	 udeWLaWImPfhKGeqPDydceO+0v63dYYV9LAFkQfw=
Date: Wed, 18 Nov 2026 21:35:34 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,willy@infradead.org,
	vbabka@kernel.org,shikemeng@huaweicloud.com,senozhatsky@chromium.org,
	pfalcato@suse.de,nphamcs@gmail.com,minchan@kernel.org,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,jannh@google.com,jack@suse.cz,
	dev.jain@arm.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,
	shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
Subject: + mm-swapops-remove-unused-make_guard_swp_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20261119053534.8B3701F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swapops: remove unused make_guard_swp_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-swapops-remove-unused-make_guard_swp_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapops-remove-unused-make_guard_swp_entry.patch

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
Subject: mm/swapops: remove unused make_guard_swp_entry()
Date: Tue, 17 Nov 2026 07:16:49 +0000

make_guard_swp_entry() was added in 7c53dfbdb024 ("mm: add
PTE_MARKER_GUARD PTE marker"), has never had a caller, and none has
been posted in 2 years.

Link: https://patch.msgid.link/20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
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

 include/linux/swapops.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/swapops.h~mm-swapops-remove-unused-make_guard_swp_entry
+++ a/include/linux/swapops.h
@@ -306,11 +306,6 @@ static inline swp_entry_t make_poisoned_
 	return make_pte_marker_entry(PTE_MARKER_POISONED);
 }
 
-static inline swp_entry_t make_guard_swp_entry(void)
-{
-	return make_pte_marker_entry(PTE_MARKER_GUARD);
-}
-
 struct page_vma_mapped_walk;
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-remove-unused-helpers-from-pagemaph.patch
mm-swapops-remove-unused-make_guard_swp_entry.patch
mm-swap-remove-unused-folio_to_swp_tb.patch
mm-zsmalloc-remove-unused-zpdesc_lock.patch
mm-nommu-remove-unused-heap_stack_gap.patch

