Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832261;
	b=1Ruds2wGrqrDpwOxWv9EDWcG6eFtBWmbvbpr3ljpZTF2YOjnfSBh+ZEb32a6Ok6Mzvis
	 GIkbteQundeS687FlCmuE0Xh5LEvcsgIanfplwKSUjl7H/o11D569VV30uLzrhYeMbcGi
	 PKEaPVl6gbeOvtcnAKU/daar7/mMJI05C6J+UH3qrTS0xa3Uwrn2Sz6SISNCme6PnaZwo
	 Gk9BOi19KHOXM90MdemGcAuIEtn3PVI10aQHBu2QpPeWUPtMdcbGvB1t4gbqxUSgf1t44
	 ZT6ZbBObzZIj9T37wcYSGgKZwrzi/fi//yWr5t5dCQwfRYKofLKy01HRrrwGPO+2P7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832261;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=R5aB5wiWj1S0HP5jJyQmDI1K76Y3LBQlAGYZnNkcs/w=;
	b=1b4ih/bBJsKR3sm4LqWohmDt/SZcZrz4wOCdL4Z6MdbdCzmJ1vOPscXpVZQdpUVCNZcr
	 A7HT/KprjSvRLImZ8OK5ojtFSkmpcL+oZC/aASPs5uqm2FIRF6r2tdU5QMXBYoQFiX1rq
	 uSpTDIGGgVUp7Xcaz8xQi0B9IJmi6b8sQ8n2MEDn/bcK40x3tqPCGKeSBnlz2FqIqq1q8
	 xU62mdlHEIopIzPo7RoA7KViZE3P05LFCrjJm6yOV5eOiC2aTORQMY0npPAR33AmVm7Lg
	 1/ZoX9Bop3iZKlc6cHw9vnRd5ui1K15Jh30/jT7cj4P1tA1t5oL2rZ0TGyi+7sXxqQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eNzDYzx9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E30A606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eNzDYzx9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239BA1F01829;
	Sat, 24 Oct 2026 08:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832261;
	bh=R5aB5wiWj1S0HP5jJyQmDI1K76Y3LBQlAGYZnNkcs/w=;
	h=Date:To:From:Subject;
	b=eNzDYzx9n/8TuRG/ABcSBL39yE+cUMCKpZLkBMYZO0GfQlTxEShbvgPu+5/ijKiay
	 RdsK96sqi3i81YMHxvd+bbEQSh3DaRyJ5vDf67qkXpIon5kran7RLLGV+MQhNqNk+b
	 YwL0qaYfmu+JqeOIn5z0PG7N+zVG+CNr0r9tvvWQ=
Date: Sat, 24 Oct 2026 01:57:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-fix-intermittent-failure-khugepaged-test.patch removed from -mm tree
Message-Id: <20261024085741.239BA1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kselftest: mm: fix intermittent failure khugepaged test
has been removed from the -mm tree.  Its filename was
     kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: fix intermittent failure khugepaged test
Date: Tue, 29 Sep 2026 11:33:19 +0100

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

Link: https://lore.kernel.org/20260929-fix_khugepagd_fail-v4-2-2169c18f2576@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-fix-intermittent-failure-khugepaged-test
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -618,6 +618,16 @@ static bool wait_for_scan(const char *ms
 		usleep(TICK);
 	}
 
+	/*
+	 * The file and shmem tests rely on refaults to install PMD mappings
+	 * after collapse. MADV_NOHUGEPAGE would prevent those mappings.
+	 *
+	 * Apply MADV_NOHUGEPAGE only to anonymous VMAs to prevent khugepaged
+	 * from unexpectedly collapsing pages during the test.
+	 */
+	if (is_anon(ops))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are


