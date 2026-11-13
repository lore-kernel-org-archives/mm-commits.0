Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794610745;
	b=OrDJF4SfyTzQHQW8iIJf9EEP0W6p8MAIFb/nFg1JxW3+0lbjWrL4I3jD5jb9cgqWaVFt
	 mYDo5ZV7xY+J/ct0qE3OInyOP7TZ7q5/HRbp3952vkTiepGq3r0F/ukdEaGK1kb5qVLZ3
	 EXJs4LQ7E97F5LmaerRwY89HdzV498fvK5GcyZOe0ElCmHgFNScCkJ75yl0Kn/2pRQC3j
	 Ut+pNyMEq5mRl8mydmdf1WMZPfrlJ+LnYQ8fBKc4TGlpLrRaM3EnFo70H7cqyYKyy3OcY
	 jnJW8P8HMPJlyDQGRfLY0KHy71L2UtvOiBBuAB2bNWet7erz4v8rpnxWwuKKBhEfNnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794610745;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=954OI/BM2Sj1ZQvB/6VG2CulWyy8PA4vs12zuccnLfU=;
	b=PsZLTNuxGxsZiZJcLL0HpJfTRdjuENzGtR5Yvl5GRlYhDVObgL8nbh64R/XOIYp8v8Fr
	 wYicwf2KCFKBq12hC7PHqGNFZVB+TBCQAnys9tS49bhz7WvLRVfXj6fv9eS3bdZ3A5SWY
	 +Xhzqtq837TKzqKHHvuv3cD7Kj+ep56ooF6AQvUySrymwiZ+gh0fCpBfEn3fK7D3GYiY2
	 V9H16vNRUfttwNkEarH6ST7SVNMwjHL2Phrq4iuRhjKHGwUK9D7GghwqtN69zbXWkMzTT
	 JgfMMtZtA9gjOv2drNoI7yR5rcfBbAUeZrc7Dn8PDgNq4KO8eKPkbwbw6cQSOTHNpCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a4MgJS39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1387A606A330;
	Fri, 13 Nov 2026 22:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a4MgJS39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C521F000C4;
	Fri, 13 Nov 2026 22:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794610744;
	bh=954OI/BM2Sj1ZQvB/6VG2CulWyy8PA4vs12zuccnLfU=;
	h=Date:To:From:Subject;
	b=a4MgJS398YKLw8o2LfEceaThivnDQqC/FIAQiTMpFyv+08b3kT0NOY1DaBxVSa1SP
	 YUBppoX7UV1mmr+S3rk728z+CqLxR2uGCl1Ry6ad6fyRc251SLReV9Yp6j2pUg3j3b
	 ptFAnPGqOB9vNwRbALryqyHl1kI7k0qncQTr89qM=
Date: Fri, 13 Nov 2026 14:59:04 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,
	ivanrwcm25@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-pfn_phys-in-phys_mem_access_prot.patch added to mm-hotfixes-unstable branch
Message-Id: <20261113225904.81C521F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: use PFN_PHYS() in phys_mem_access_prot()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-use-pfn_phys-in-phys_mem_access_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-pfn_phys-in-phys_mem_access_prot.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Subject: mm: use PFN_PHYS() in phys_mem_access_prot()
Date: Fri, 13 Nov 2026 16:38:12 -0300

phys_mem_access_prot() stores "pfn << PAGE_SHIFT" in a phys_addr_t.  The
shift is evaluated as unsigned long, so on a 32-bit kernel with
CONFIG_PHYS_ADDR_T_64BIT an address above 4 GiB is truncated before
uncached_access() compares it with __pa(high_memory).

mmap_mem_prepare() already shifts in phys_addr_t, so the mapping is
accepted and then left cacheable.  PFN_PHYS() casts before the shift.

On a MIPS32 XPA Malta guest, mmap of /dev/mem at 0xf00000000 without
O_DSYNC used the boot CCA.  The same mapping with O_DSYNC was uncached. 
With PFN_PHYS() both are uncached.

Link: https://lore.kernel.org/20261113193812.1239880-1-ivanrwcm25@gmail.com
Fixes: 7e6735c3578e ("/dev/mem: use phys_addr_t for physical addresses")
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/char-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/char-mem.c~mm-use-pfn_phys-in-phys_mem_access_prot
+++ a/mm/char-mem.c
@@ -272,7 +272,7 @@ static pgprot_t phys_mem_access_prot(str
 				     unsigned long size, pgprot_t vma_prot)
 {
 #ifdef pgprot_noncached
-	phys_addr_t offset = pfn << PAGE_SHIFT;
+	phys_addr_t offset = PFN_PHYS(pfn);
 
 	if (uncached_access(file, offset))
 		return pgprot_noncached(vma_prot);
_

Patches currently in -mm which might be from ivanrwcm25@gmail.com are

mm-use-pfn_phys-in-phys_mem_access_prot.patch

