Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049A61799F
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 01:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755481557; cv=none; b=f7cfZRRcz8ADCwM1Rs35v8NcsznjMlnYnhXC1Uuar13UNkz5OF4OkTDqABgWfxTsKVKzZCbiWwV6mdDsT/ZFKu4Iobd5qhVyvTyV4DqNOehBuLLPQdHJjedeFm3Vj6d1JxJwCoygcze65D9/dGb+5q9hKelkzF/KGx/eJTCF0Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755481557; c=relaxed/simple;
	bh=7ZV4SChyXq1oRe+fDVs4ap79vkYWFP58D/Hjth1NXI8=;
	h=Date:To:From:Subject:Message-Id; b=QsjEAfxa2OLvEilKvdy7E9Z1EBbwltd25UF6QoUZZ9I4VkJY6/0ZorbBpdrkYCuuuqWJ3Nc+xMddWlMhz1XUE1fI3hVGV4Mdodl7ZjGs3S2M06m7dut0aLlZyIR5cDk8QmR08EmfeHsDeIcOTzc6MBpo4ANAPZGgqoMq6tPp2a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4lbNrw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4lbNrw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68020C4CEEB;
	Mon, 18 Aug 2025 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755481556;
	bh=7ZV4SChyXq1oRe+fDVs4ap79vkYWFP58D/Hjth1NXI8=;
	h=Date:To:From:Subject:From;
	b=N4lbNrw765brPLieRq9Al14hKtycJHJSHVnLQqwbOu7VkGwkRGOzGiq0/k4Ny9uAa
	 fbuhp/XSgHO5JHK7I74VumNGgO7oXROnlMHsKFdEu2xe1sJ/wKOI63+2eH/Rj9pCIi
	 Hkim3QaheZn/5g01/P8YoF/EAXXBJqH/MfWavO1U=
Date: Sun, 17 Aug 2025 18:45:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch added to mm-new branch
Message-Id: <20250818014556.68020C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
Date: Sun, 17 Aug 2025 03:26:46 +0000

At this point, we are in an if branch conditional on (nr <
ENTIRELY_MAPPED), and FOLIO_PAGES_MAPPED is equal to (ENTIRELY_MAPPED -
1).  This means the upper bits are already cleared.

It is not necessary to mask it off.

Link: https://lkml.kernel.org/r/20250817032647.29147-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-not-necessary-to-mask-off-folio_pages_mapped
+++ a/mm/rmap.c
@@ -1749,7 +1749,7 @@ static __always_inline void __folio_remo
 				nr_pages = folio_large_nr_pages(folio);
 				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
-				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
+				nr = nr_pages - nr;
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
 					nr = 0;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch

