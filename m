Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795497696;
	b=E35rsQ85o18kl6dRIuQKeREMEcbksEnxLPDfrX496KcefyfGRsffJrUjAiR8nTEEqgNf
	 b3Fl/EOqzFbBry6t2CXAmR7wv2cEDT2giBfTOzYC7SLp0sH1NT/ZembOTlA3vxvt9jbuj
	 yHzYzQUYhh/Hy+VuQfCAZ27MxnJeGKxeHtdBmcynUJv+rJTPDXIGLygMQdoC3JyyO8DT2
	 S7wVViQWl/db4OclLB4FDCHnnCJ6OH84ZzLrqssO3ac/GTn9u1cEsggkOo6tH0jOKnICg
	 zm8P8CYsoPSYwc0TZErAlKsHCy/aqhROn8PluJo7eZTsRvUl8+GNGT0EQeXMEL1ZP5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795497696;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=9xQqiKKOqpe8NYoFkh19kBq35dfonM2FubbicrLc7sw=;
	b=jshti0Lgk+ilR+y2TBnxCtInJDVBgYOWMp9hVcMmVwQvarn14DivqveP9tmcJR7rH9zo
	 8lKV6fdLcI+/z4J7h4B2up3NA+zJzER5hsy8jiY9a+bXpILYKgrmnETWlkavtfXN4sNL6
	 J3jtaBBfHaDdk6LVEshJCQBVhJpJXvA58L9GpVJPSHqTI+uq+rHPSQg0/PNxhGKInl58u
	 twTgIi+6PGYzRGvgaTFWRsPYdqsUmbsf7EiS5mChxY01RqvuHkcj5med/CKB3AQzHtWZP
	 fOERK3XDYY3VhqXfOVA1MmiPSeqn4XhDR6GYhnFte871nyz7lOX5Bk1CpP+y+Wdnhlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UZzFunOa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1877606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 05:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UZzFunOa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B1A1F000C0;
	Tue, 24 Nov 2026 05:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795497695;
	bh=9xQqiKKOqpe8NYoFkh19kBq35dfonM2FubbicrLc7sw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=UZzFunOaDO5cbKhTZuex4wASmcsJPmUkLfyOTg+Xmn9K9bFztymk/RoZ8TbsODh2W
	 2AAphz+VPTP0K+ddlLvpQ2NRe5mw0i3DtiWMAztFuDw8PEsu5gwVs/QrVQA+I9R3Eo
	 31P9OJIvQ2bZ6d7rp+5WHWdH/sulzBIQcOmKJjGs=
Date: Mon, 23 Nov 2026 21:21:34 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,
	david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
References: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
Subject: + mm-hugetlb-fix-nr_hugetlb-accounting-for-kept-surplus-folios.patch added to mm-new branch
Message-Id: <20261124052135.78B1A1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: fix NR_HUGETLB accounting for kept surplus folios
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-nr_hugetlb-accounting-for-kept-surplus-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-nr_hugetlb-accounting-for-kept-surplus-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb: fix NR_HUGETLB accounting for kept surplus folios
Date: Tue, 24 Nov 2026 12:41:02 +0800

Commit a11a13ebbc5d ("mm/hugetlb: account restored reservations before
freeing folios") reworked the free path of gather_surplus_pages(): when
the pool was resized concurrently, folios that are no longer surplus are
kept and enqueued directly instead of being freed.

However, folios on the surplus list are accounted in NR_HUGETLB when
allocated in alloc_surplus_hugetlb_folio(), and every other path that
returns an already accounted folio to the free list decrements NR_HUGETLB
first, as folios on the free list must not be counted.  The new enqueue
branch skips that decrement, so the folio remains counted while on the
free list, leaving NR_HUGETLB permanently overcounted by
pages_per_huge_page for each kept folio.  Nothing corrects that later,
whichever path the folio takes next.

Fix this by decrementing NR_HUGETLB before enqueueing the folio, as done
in the other enqueue paths.

Link: https://patch.msgid.link/20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn
Fixes: a11a13ebbc5d ("mm/hugetlb: account restored reservations before freeing folios")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-nr_hugetlb-accounting-for-kept-surplus-folios
+++ a/mm/hugetlb.c
@@ -2489,6 +2489,8 @@ free:
 		 * count as persistent and we must keep them.
 		 */
 		if (!h->surplus_huge_pages_node[folio_nid(folio)]) {
+			mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+					    -(long)pages_per_huge_page(h));
 			enqueue_hugetlb_folio(h, folio);
 			continue;
 		}
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch
selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch
selftests-mm-protection_keys-use-_exit-in-aarch64-ptrace-tracee.patch
mm-hugetlb-fix-nr_hugetlb-accounting-for-kept-surplus-folios.patch

