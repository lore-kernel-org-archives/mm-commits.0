Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1036D1A7
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669498; cv=none; b=Y7ryu5wBXTNz1UlHLlzHZ+uG8kqBleZmzbfXWseNCfbFz6SWSV4i0m1X4MFRmfG83rk47hO7qHDgpP9Ib5tVEDl1uEp3B71VVQSjVpn0cPYsci53sNJ9qq5eSwCU+WTzochk8kbg5B/U6ZuUXHEudkYnftRsTeFgo+DExEsOZZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669498; c=relaxed/simple;
	bh=uEOWqpJRF3uH4LcpXiruKWhh30NaBWP1EPbeuJYNb0g=;
	h=Date:To:From:Subject:Message-Id; b=U8Rf5HCysf08lYJSQJyJgl36HOA6jd0xgm6yKjsWa6RfAgfdj4aelqOzgZ1yXFSiHF5+7Vg9mGWPrJvncxKMMfF3RV0N6oJnj1wN8eTefNW6D4mabhVPORIGfpKG986FcaLmDnnxjZgCBi3zgP3TocNCkFpIs2R3iymCAMKoYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lSUkouLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lSUkouLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5212C4CEED;
	Sun, 31 Aug 2025 19:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669497;
	bh=uEOWqpJRF3uH4LcpXiruKWhh30NaBWP1EPbeuJYNb0g=;
	h=Date:To:From:Subject:From;
	b=lSUkouLD18jW9W20zgwur1G+41BnhZI9z3pg1fXHopHSu0jtkCDey4wAkz3roIre9
	 UAjyWhNGHXowDRn02lneNKdJyVcKp4lEP2DqMPE4TwRyxZQ68tGay2/IzhMTa45WPh
	 w2jiEaUstNgFhbfL91HqZqN93+DVd9Q8If4S7pfI=
Date: Sun, 31 Aug 2025 12:44:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch added to mm-new branch
Message-Id: <20250831194457.C5212C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check content to see whether mremap corrupt data
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch

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
Subject: selftests/mm: check content to see whether mremap corrupt data
Date: Sun, 31 Aug 2025 02:27:01 +0000

After mremap(), add a check on content to see whether mremap corrupt data.

Link: https://lkml.kernel.org/r/20250831022701.2595-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-content-to-see-whether-mremap-corrupt-data
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
 
 	/* smap does not show THPs after mremap, use kpageflags instead */
 	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
+	for (i = 0; i < pagesize * 4; i++) {
+		if (pte_mapped[i] != (char)i)
+			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+
 		if (i % pagesize == 0 &&
 		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
 			thp_size++;
+	}
 
 	if (thp_size != 4)
 		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch

