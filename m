Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795481818;
	b=HKjpBQbS0URRFOpMnkQZt22XiYMjv6EYox1+Jf9vmT4LVtSDTsSvZItgnJwBAam0j7c9
	 v0/IEBK07bglygwU7MMgpiai3rJYKignTiMOv6NL/3meXRXJC7XJaajGvA4bnpX/kPrqA
	 pwztEqalDSDMl3rmWXsD8WFtDwjSH1UK/qKAUZJOqsZi+MULskdYM/yrU4Rvi/HNmpr2h
	 Qed0nsgs4Vecafli5AXUp0DEKUpJnl1z2EY7ntpYH0YOsBiBTqubqSUJH5iZmLyWqAK7P
	 6JJjT4gPEZDgn82XkiIEQoYDDNQvGSSIuN3a7041TESGXzb/smta12f3zCJ6RfcRMmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795481818;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=xwavzPqBlYOEGbind+t7fNwhd7VGlp6kvnLrYr/3288=;
	b=zN0p+IYzKZ3QhVBEyKLvs2MrB8bV0sJa3jW1yE3xINvUQUT+Uz1Ci8t0lwEKavdMeXDb
	 tUfXkkFEXemgmd2+xiK8LSZPicomCR+eT3eQ8CyoBpJqhb+D6xVQiPDiN1k1kPRbAE2M7
	 /5r2JWbfnAVUmX6YmZcCElWYEvJgVUOIh1dG2Q6BpYTrdJCl7q9DubIEYjJDmgGF3Wp0N
	 7U2zLdhHuM8VC9QqewmDLSXr1+/zZLmECiFJ5mdoDwpfIeVAgf1CU/6bxCgG7Vwngdqiq
	 wX/uHqDguyCgDpki5Jeg3E8jnJwR7VB7/N0B+YEnnxt0bEVzxU0ZyFeJ6/pjyzM+UAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BayJwELy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC5A606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 00:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BayJwELy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22ED1F000C0;
	Tue, 24 Nov 2026 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795481818;
	bh=xwavzPqBlYOEGbind+t7fNwhd7VGlp6kvnLrYr/3288=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=BayJwELyOuLqSmzkHlqCYt2StNuKbfxDHb6zCfKEUedljInGgOHzRXIBgcjcRrm1b
	 CXbA0UCXWbX1r/thko5l4Innd1OFynZOeEnRczlAKCSLja1lgQyzq3M9jBtSnBB8Ty
	 zFz/JjV03k3R8AowCxfYocLZQ6HIOiIyQ/FriwIg=
Date: Mon, 23 Nov 2026 16:56:57 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,shakeel.butt@linux.dev,pfalcato@suse.de,mawupeng1@huawei.com,
	liam@infradead.org,jannh@google.com,dingf3ng@gmail.com,david@kernel.org,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
Subject: + mm-msync-return-enomem-if-page-aligned-length-overflows.patch added to mm-hotfixes-unstable branch
Message-Id: <20261124005657.D22ED1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/msync: return -ENOMEM if page-aligned length overflows
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-msync-return-enomem-if-page-aligned-length-overflows.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-msync-return-enomem-if-page-aligned-length-overflows.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/msync: return -ENOMEM if page-aligned length overflows
Date: Fri, 20 Nov 2026 10:59:56 +0000

Currently the msync() system call will simply return 0 if you provide a
length parameter which, when page-aligned (rounding up) overflows (i.e.
SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)

This requires broken input, and nobody has complained about this, but for
correctness this should really return -ENOMEM, so do so.

Also, since error is assigned within the following loop, remove the
unnecessary assignments prior to it.

Link: https://patch.msgid.link/20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org
Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ding Feng <dingf3ng@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Wupeng Ma <mawupeng1@huawei.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>

 mm/msync.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/msync.c~mm-msync-return-enomem-if-page-aligned-length-overflows
+++ a/mm/msync.c
@@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		goto out;
 	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
 		goto out;
-	error = -ENOMEM;
+	if (!len)
+		return 0;
 	len = (len + ~PAGE_MASK) & PAGE_MASK;
 	end = start + len;
-	if (end < start)
-		goto out;
-	error = 0;
-	if (end == start)
-		goto out;
+	if (end <= start)
+		return -ENOMEM;
 	/*
 	 * If the interval [start,end) covers some unmapped address ranges,
 	 * just ignore them, but return -ENOMEM at the end. Besides, if the
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

