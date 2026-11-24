Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509685;
	b=Xm1FMUi0E9ZJO0KWpCjGptdG9man6ZoXky09uA8v/NbOxUaCPBlqZnAw1VAkhygN+dPz
	 sO/JiepkAt9hOmqOvjkfJLRFq5pzGfAWMm20+4mhYMbs1Vo4/aLQYlXIvKZNuTQmb2JCm
	 L5eHLogwtCIa69ayg+CpQ0Xt9salo0g/wCRLb5bE3QUu9jSIvFDw8xoX3SoZic41mDz35
	 fOStrbk1rQtNPGj4iL2e3dfJOycozIhKyD03FBNCXCJPB8/6SZV1jOnhi76H8F4C1wrNc
	 jxG4EyMwSbrCk8Q7maQM4G2FOBe3ABGg2puzWiPEKUO3fgh+4PjXSqvflKy7NF2rVEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509685;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=GyitqHie4zHmW6jBaILs5Xo0dYxT3WQWhEWPN2yJDr0=;
	b=fpRjWMuVFGdYlwGIp94KXYzQl1KTkQ7QNVWBiCB8wJU3cyIEfNgPw2U94TpvNAKhfWg2
	 jzNxHwfEiBYVBfpEmeQFgfS40qxkYZ3g5K6ViVRDGg0c2UgRhKDI9vPyehkq9ttC4Fydz
	 BXapoJXUDMv3Kg1gXwJCR9V8fsFOqMzRiVWS9GiZIMK8UPHlHEvpYVGrzu+b80OBAqTDN
	 NUl/xuW95c7RjwvhoRIxteKM4taOrq+ES8YONRJ1H2nui56pOQXZ5GhuTeVa6cWJhWutD
	 Za4bRevX3DGfIvC5qd5o2gLBn5TTibdjen0buN2Va0T2CloHx+RvbQUuWlrXubEHOzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e8ByBqrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52E0606A322
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 08:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e8ByBqrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07F11F000C0;
	Tue, 24 Nov 2026 08:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795509684;
	bh=GyitqHie4zHmW6jBaILs5Xo0dYxT3WQWhEWPN2yJDr0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=e8ByBqrwKj4AsCffYPykCXvaZcfAPmrY+1437Gf2iISFTyH84kc5Cw8suC4WRCNHO
	 ukbepFvNGVVit2pHOamCf67ffHuix+AGVIlPa0G/Rtc1P4H6W10M9JYp7svN/8UZ0Q
	 xnIAmZhjVVnVqw8N5lHNTr9z5qjOJT+EQctA/9g4=
Date: Tue, 24 Nov 2026 00:41:24 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	skhan@linuxfoundation.org,shakeel.butt@linux.dev,rppt@kernel.org,
	rmk+kernel@armlinux.org.uk,rdunlap@infradead.org,qi.zheng@linux.dev,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,
	corbet@lwn.net,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
References: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
Subject: [merged] docs-mm-fix-stale-split-page-table-lock-references.patch removed from -mm tree
Message-Id: <20261124084124.C07F11F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Docs/mm: fix stale split page table lock references
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-stale-split-page-table-lock-references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


