Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93719503913
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 20:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790713738; cv=none; b=tx80DyF3lw+08UH2AK9ENXGVybYe21pfn1T+Ki2iSKXkUWq2VcWfUFgjqoeUF/N9j62oS4Id83QUqXgrYTj1mfv+sy26XA6FMMTqecItpUmRYGtUTHWFCX+1sIp+Tv9wPi5ItXbzd/1Sw4SHZ24QgEn86X/Ho30EcoU7/9rVYCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790713738; c=relaxed/simple;
	bh=Tiaxg9VBHZjuvmpJK8gF5sPZhCvllNGAmFUxsuqcJww=;
	h=Date:To:From:Subject:Message-Id; b=rPfHRKY7bkrAkwE2bNdY+DPe+hNluPg0leKP3Jb9581+cVzkRnfNwqroGou05xOse7uWmn7gK9lWU1Muh2jq8I9ZZwoFzKGukvfda6bvuU9RPABgcXc3ih+ZUvAqMh1rl1ooLWdiSQ57HFdqXW1MJ5KlLUpaJajFdw9Y7ZhhVH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gwWS/23G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gwWS/23G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5A91F00893;
	Tue, 29 Sep 2026 20:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790713737;
	bh=Vk0JPkdWIN8zePlX+qQsT9z8+AJcUgUfylP/rY8Sgwc=;
	h=Date:To:From:Subject;
	b=gwWS/23GPyI411FO1eT856hqKVx/ymA1oOeoHXSxkk/3tQkYjj4lyGC8JR+LkBvqk
	 00LzXsmFz/38ixy8T8YnGsT7Q4/yBYL/7ESdDybLuPQRtxOS6pbqbIK43ENDRCX65j
	 kXFpq4f3yudlea1YL9W7YU0gZ2U6eHbKtf09jvcI=
Date: Tue, 29 Sep 2026 13:28:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-mm-fix-intermittent-failure-khugepaged-test.patch removed from -mm tree
Message-Id: <20260929202857.1C5A91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: fix intermittent failure khugepaged test
has been removed from the -mm tree.  Its filename was
     kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: fix intermittent failure khugepaged test
Date: Wed, 23 Sep 2026 16:29:52 +0100

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  // while running ./khugepaged -s 2

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before
wait_for_scan() is called, causing a sanity check that expects uncollapsed
pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them
again before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon.  This prevents khugepaged from
collapsing it again before c->collapse() is called.

This failure was observed on NVIDIA Spark with 16KB page.

Link: https://lore.kernel.org/20260923-fix_khugepagd_fail-v3-2-b387e92fe1a9@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-fix-intermittent-failure-khugepaged-test
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -618,6 +618,9 @@ static bool wait_for_scan(const char *ms
 		usleep(TICK);
 	}
 
+	if (is_anon(ops))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch
kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

