Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057B914199A
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876023; cv=none; b=RkW2FAVbe1PhlNlkUrxxG/w3VLWZeFKh9S7xyqDOj8PSiHm3a95kKlW0vHGdN7UnR8qQxo1cKYa3dcRAqY6CMEqWzd4KZhCPP2u0kxYjlNhGt2IfC8gLJoGVAaxk8uEFzKRYiM1WXJ46iH7VDLI/RAginELXqQQZV2qo4zYr/Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876023; c=relaxed/simple;
	bh=0uA5NXw78o8aHso+EfymvifC/RE536h1Y2qyUyDQNFQ=;
	h=Date:To:From:Subject:Message-Id; b=AS/c+xHPGGUiNZ0bVcb8khbgXhj/IR/TyZgBTNKPy6z98qwgEkk/Lz1PN/+JKkMO9C/PHfT3T6FQPz36oi7N/ox601kfc4ipcfKeUq8H+aeQsxv6OfsEgRtwJgye60CHsBvpMvPhoesaBjc9K1IO1jihRrutPokVh25KThLVImE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LkWNRRNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LkWNRRNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B266C433F1;
	Fri,  2 Feb 2024 12:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876022;
	bh=0uA5NXw78o8aHso+EfymvifC/RE536h1Y2qyUyDQNFQ=;
	h=Date:To:From:Subject:From;
	b=LkWNRRNHnk5F4McjtbeP4qHXeaiCF+Ted+Zq+XgpnSSqwpR4jUsmxBGpjHQCYFng4
	 m7c5qvFpFJ3FqZ4hrZlGo5FkKtrVnddk9q5zvkSai8ILy/VoJ61ni2fM1NUvz44G3m
	 48cIuM/BSgtxwGlfU0NpXWs6pA357CI5Kor2afJI=
Date: Fri, 02 Feb 2024 04:13:40 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch added to mm-unstable branch
Message-Id: <20240202121342.3B266C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
Date: Wed, 31 Jan 2024 21:16:26 +0800

Currently we will use 'cc->nr_freepages >= cc->nr_migratepages' comparison
to ensure that enough freepages are isolated in isolate_freepages(),
however it just decreases the cc->nr_freepages without updating
cc->nr_migratepages in compaction_alloc(), which will waste more CPU
cycles and cause too many freepages to be isolated.

So we should also update the cc->nr_migratepages when allocating or
freeing the freepages to avoid isolating excess freepages.  And I can see
fewer free pages are scanned and isolated when running thpcompact on my
Arm64 server: k6.7 k6.7_patched Ops Compaction pages isolated 120692036.00
118160797.00 Ops Compaction migrate scanned 131210329.00 154093268.00 Ops
Compaction free scanned 1090587971.00 1080632536.00 Ops Compact scan
efficiency 12.03 14.26

Moreover, I did not see an obvious latency improvements, this is likely because
isolating freepages is not the bottleneck in the thpcompact test case.
                              k6.7                  k6.7_patched
Amean     fault-both-1      1089.76 (   0.00%)     1080.16 *   0.88%*
Amean     fault-both-3      1616.48 (   0.00%)     1636.65 *  -1.25%*
Amean     fault-both-5      2266.66 (   0.00%)     2219.20 *   2.09%*
Amean     fault-both-7      2909.84 (   0.00%)     2801.90 *   3.71%*
Amean     fault-both-12     4861.26 (   0.00%)     4733.25 *   2.63%*
Amean     fault-both-18     7351.11 (   0.00%)     6950.51 *   5.45%*
Amean     fault-both-24     9059.30 (   0.00%)     9159.99 *  -1.11%*
Amean     fault-both-30    10685.68 (   0.00%)    11399.02 *  -6.68%*

Link: https://lkml.kernel.org/r/994af744828efe3c060128445204a56ab41e3ebb.1706706820.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages
+++ a/mm/compaction.c
@@ -1882,6 +1882,7 @@ done:
 	if (order)
 		prep_compound_page(&dst->page, order);
 	cc->nr_freepages -= 1 << order;
+	cc->nr_migratepages -= 1 << order;
 	return page_rmappable_folio(&dst->page);
 }
 
@@ -1904,6 +1905,7 @@ static void compaction_free(struct folio
 	list_add(&dst->lru, &cc->freepages[order].pages);
 	cc->freepages[order].nr_pages++;
 	cc->nr_freepages += 1 << order;
+	cc->nr_migratepages += 1 << order;
 }
 
 /* possible outcome of isolate_migratepages */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

