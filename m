Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E62E334C1D;
	Mon,  1 Jun 2026 04:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289465; cv=none; b=eyTUepK26V1aPpQXrbYzD+hidTcbwSklWeFrVMz8dpj9fltKdFaITZmS2wwtHwzcd5QKVCzlZF1EhOBnLFkAy2OQwChVxdomJHaPBUQxyDMIY+n0McHmhLMfuNvwO2gf8/Jfa4AJml6eFjgEF/DnrLtB9YDIDrLFuH1wbjCDsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289465; c=relaxed/simple;
	bh=qmQnAV71DyGMVvjNqen0OtYxxVy60xKWmsH1DxugWeM=;
	h=Date:To:From:Subject:Message-Id; b=gMtAlG2gT/RNs706eOEmfIOm3Z2oDoTgkEnDhaU2qjVSg0qQHRCHr8LjXEw0T0jrL8fbekMKV4LE5lnIeIpufAQJDmDmofIUXGvWAJnAZVwDHruuKqEFGyP9eUFTP6z8iOWaojMOU5TJyKoYpJlFToOODPxOBgVkTBwvEO5qPMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mzYO8x8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mzYO8x8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197181F00898;
	Mon,  1 Jun 2026 04:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780289464;
	bh=46SEHwCQlIYX7Q8WurwKOtTgklDUZtpshc4M9+cihNk=;
	h=Date:To:From:Subject;
	b=mzYO8x8OCYtR4rjGycuh7TCLJJ62gIEV5T7tkhVTM6Zsg5HiBXzgY0RtYrU9m/5Jt
	 gN7tIRCa5YlkDI5gJ7PbujCx8mg2L/XPqy7hC8pL/U0GnE98xz2da3Rz9BhQh8YAZ3
	 DBok6+jfS77iXVvrFKXYEVU4YevvE48AG/bp6TsA=
Date: Sun, 31 May 2026 21:51:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang.shi@linux.alibaba.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chenjun102@huawei.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,yintirui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-update-file-pmd-counter-before-folio_put.patch removed from -mm tree
Message-Id: <20260601045104.197181F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: update file PMD counter before folio_put()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-update-file-pmd-counter-before-folio_put.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Jun <chenjun102@huawei.com>
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


