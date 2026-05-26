Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9681DED49;
	Tue, 26 May 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779821417; cv=none; b=nBpuwYLPN+L0K7F1TNhTEMGAiLzzkZbWpksEn8lEGcKYroGmMxXkAJGuf+RXpkGJR4dA9qZLNicuWOBOcHXVBS9wM0XTFeomRBkMDv3IYYUwD6vJSbt/nqZWPbqrKFTdFpDEn2A1Vm/eLH2ZW7pQq0HZbVVNuNs+ECrzcnclo5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779821417; c=relaxed/simple;
	bh=xOXrgx/QcDXGaQa3npDlnYZI42ZSV9MlFT9UmBCQrq4=;
	h=Date:To:From:Subject:Message-Id; b=dr+yg/rexDtYUgz0u9Gu4NyKb34h7fBigoJzEfdEpSb5yV0CMgGcJf8T6omPrPtEb+SejkmqYZWStuZjpqFrssTu/LdU+Wiv2d2PpaGxgWIMB+piHiRBhwPmR1evF7HOB75ZRWC1O8foZesje9QiO3UmdG28BWkk6Z5Q/ETot7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=peaLySlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="peaLySlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC6A1F00A3D;
	Tue, 26 May 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779821416;
	bh=BH+zKlUABN2HrDgz32xxEgnZRuZrUUE03D6HUP/hnvA=;
	h=Date:To:From:Subject;
	b=peaLySlH7X1pxYHCuGMokLF+tQWe9ytay+JMWGLUcw6qWdSLHhYN4MWxB7khtvAIW
	 WrIMom2MmUE1suHi+aGGNmB1TO8lyk52BscK03zTYCdL3D3FQ9yYZ8sY1y/rV8bb8+
	 jwP17GXCeXlOt9Ssm2RKVW5eCrCn+pysRAyXbBAE=
Date: Tue, 26 May 2026 11:50:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang.shi@linux.alibaba.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chenjun102@huawei.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,yintirui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-update-file-pmd-counter-before-folio_put.patch added to mm-hotfixes-unstable branch
Message-Id: <20260526185016.3AC6A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: update file PMD counter before folio_put()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-update-file-pmd-counter-before-folio_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-update-file-pmd-counter-before-folio_put.patch

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
From: Yin Tirui <yintirui@huawei.com>
Subject: mm/huge_memory: update file PMD counter before folio_put()
Date: Tue, 26 May 2026 18:13:37 +0800

__split_huge_pmd_locked() updates the file/shmem RSS counter after
dropping the PMD mapping's folio reference.  If folio_put() drops the last
reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Link: https://lore.kernel.org/20260526101337.1984081-1-yintirui@huawei.com
Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-update-file-pmd-counter-before-folio_put
+++ a/mm/huge_memory.c
@@ -3133,7 +3133,9 @@ static void __split_huge_pmd_locked(stru
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
 				folio_set_referenced(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
+			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);
+			return;
 		}
 		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 		return;
_

Patches currently in -mm which might be from yintirui@huawei.com are

mm-huge_memory-update-file-pud-counter-before-folio_put.patch
mm-huge_memory-update-file-pmd-counter-before-folio_put.patch

