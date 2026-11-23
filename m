Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795412339;
	b=t18byZc7R+hVocKfnrckT+PvSQWkRwv7BbaY1p9mdPof6+xnTNKFlYk+EgOMVr52UcAg
	 rzTtMyUeu+W3mbdmJTFegtmByBA8y4/4YjAqw0UFxLJLYYcmaJPNN8VLKRLL8pnJAFa9M
	 t/UexwNa3IXErZ9CQOh5X763hickGj2OB7LooPt70T0IZ+/yIIi1jBTcpNoMaldVrbNpX
	 2mLvyS/rNAjgI26yCB65l0FJbx+piZM7IwW+xwh0UXjcm4XSjp25o31HqdSMDKNpfge4f
	 YoZPlpeq06PXA/YX0rS1y4w47WjgrRUVfxQZjyqpjK4N6nZqvwgAfBRlROW0lvwvGbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795412339;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=r1UVk9PC+bS6T8UlO2jjijoYg5uUF+jKP8peQ0BOBDk=;
	b=kBoz7sblR5AsXnglcYhbZ4r8mDu5BVpSksmyGpNcgpwGkRPM4Zcf90SHcVRCoeARBPn3
	 wb7B4tETLqxI0lwOsYqM0Xbht/nOHkFR4e+kEf8BnqkziKaUpDl3r4FyUsTgPuIZyAHci
	 lg5IktwcuNib6P4Inc4/gmMMRvSOUSo/wraVTKX6bH6DVvnTq2AuC5dyFikSTa6hoPMdO
	 iG5dR8RQx3WJXnX01SBOS7RHs8wT1ZsQwk3zWnOrvgiI5BLTv7aaj6nJul38/ttwcegE+
	 cEZ2/pVpPCR0uOdqd6+46hJ7dX+MmLkKFKp4N5quKwBaMAZu9ceU5yU3NqL3gJhxJ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=edivmLTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA28606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 05:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=edivmLTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7241F000CF;
	Mon, 23 Nov 2026 05:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795412338;
	bh=r1UVk9PC+bS6T8UlO2jjijoYg5uUF+jKP8peQ0BOBDk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=edivmLTBE1Q6cE1SwWS390xgJNPIqFO4765HYGjPpna0Kvw5cDLPKB8RLHFQE2Tqv
	 rPTtTdmN0VY4ABUyUoUSDs31LVqAPVlL6DMlp0fc6+qrF73eriCu1U+3Zu4w6m0eQM
	 QbLUwoRDSEw7SuyBb9VhdBUHaCfnNaTXvb1znAfk=
Date: Sun, 22 Nov 2026 21:38:58 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	skhan@linuxfoundation.org,shakeel.butt@linux.dev,rppt@kernel.org,
	rmk+kernel@armlinux.org.uk,rdunlap@infradead.org,qi.zheng@linux.dev,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,
	corbet@lwn.net,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
References: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
Subject: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
Message-Id: <20261123053858.BC7241F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm: fix stale split page table lock references
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-fix-stale-split-page-table-lock-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-stale-split-page-table-lock-references.patch

This patch will later appear in the mm-unstable branch at
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
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Docs/mm: fix stale split page table lock references
Date: Mon, 23 Nov 2026 11:09:03 +0800

The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
Documentation/mm files still refer to the old names.

Update both references.  Point readers to mm/Kconfig for the dependencies
instead of restating information that can become stale.

Link: https://patch.msgid.link/6E11B4A6A6E0DCF9%2B20261123030904.57369-1-zhaozhengzhuo@uniontech.com
Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Russell King <rmk+kernel@armlinux.org.uk>

 Documentation/mm/process_addrs.rst         |    2 +-
 Documentation/mm/split_page_table_lock.rst |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-stale-split-page-table-lock-references
+++ a/Documentation/mm/process_addrs.rst
@@ -659,7 +659,7 @@ acquired in :c:func:`!__p4d_alloc`, :c:f
    references the :c:member:`!mm->page_table_lock`.
 
 Allocating a PTE will either use the :c:member:`!mm->page_table_lock` or, if
-:c:macro:`!USE_SPLIT_PMD_PTLOCKS` is defined, a lock embedded in the PMD
+:c:macro:`!CONFIG_SPLIT_PMD_PTLOCKS` is enabled, a lock embedded in the PMD
 physical page metadata in the form of a :c:struct:`!struct ptdesc`, acquired by
 :c:func:`!pmd_ptdesc` called from :c:func:`!pmd_lock` and ultimately
 :c:func:`!__pte_alloc`.
--- a/Documentation/mm/split_page_table_lock.rst~docs-mm-fix-stale-split-page-table-lock-references
+++ a/Documentation/mm/split_page_table_lock.rst
@@ -37,8 +37,8 @@ There are helpers to lock/unlock a table
  - pmd_lockptr()
 	returns pointer to PMD table lock;
 
-Split page table lock for PTE tables is enabled compile-time if
-CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
+Split page table lock for PTE tables is enabled at compile time when
+CONFIG_SPLIT_PTE_PTLOCKS is enabled; see mm/Kconfig for its dependencies.
 If split lock is disabled, all tables are guarded by mm->page_table_lock.
 
 Split page table lock for PMD tables is enabled, if it's enabled for PTE
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are

docs-mm-fix-stale-split-page-table-lock-references.patch

