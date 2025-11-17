Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B546F212548
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343117; cv=none; b=RZiELqwLWRARbz49riZdzyLHppsHTGDBUago+u8n1wQJQyvz2RLBssi/81C4XzdCYO5M1mdX9PY7/qc2zvXR4eyRzxWUuiEu+bIWrFAOW2napr+i2pU3voQFKBphdbKasmz2fapQOy6BP5vLS2fPTyzj0qkd4xSMBcP3HQtLwTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343117; c=relaxed/simple;
	bh=mopHmNdngL955ARRrc1kFGUNONYZbLnliQkuxAPpQjM=;
	h=Date:To:From:Subject:Message-Id; b=DIwJ0yDwEmTc0JcyvMDuZ1sG7TATH3D6XQkkWgodlOf4HJCAOYa/R+2IKksnDXW2GDSKqHeTqAubGHTVx+zmfm4t6Eq9/Zgy2NF6WaL+kmko+qifqYCG9TnVUf1RanjHtPxA/dKGt36W0U7Zw9/imsRmBeIT7TbIDhXmrMNane0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UKRadxaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UKRadxaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A39C116D0;
	Mon, 17 Nov 2025 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343117;
	bh=mopHmNdngL955ARRrc1kFGUNONYZbLnliQkuxAPpQjM=;
	h=Date:To:From:Subject:From;
	b=UKRadxaK5Sk0C9jLgJw4jBxoYFAUegYyTbI4JgcPB7DZDFatoiDbFh2W2vxedW6Q8
	 WiaIz1zDyKd9J4F0dBzuhcedTjPynKPM36Y0eN2i/3TvP6XPowOwnRBf7/MJ1BcoSe
	 3C33jq2dahPSs4YF1NtKyAtb1F7v+P+0n06NBmWQ=
Date: Sun, 16 Nov 2025 17:31:57 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sj@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch removed from -mm tree
Message-Id: <20251117013157.89A39C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: allow overcommitting gigantic hugepages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/hugetlb: allow overcommitting gigantic hugepages
Date: Thu, 9 Oct 2025 18:24:31 +0100

Currently, gigantic hugepages cannot use the overcommit mechanism
(nr_overcommit_hugepages), forcing users to permanently reserve memory via
nr_hugepages even when pages might not be actively used.

The restriction was added in 2011 [1], which was before there was support
for reserving 1G hugepages at runtime.  Remove this blanket restriction on
gigantic hugepage overcommit.  This will bring the same benefits to
gigantic pages as hugepages:

- Memory is only taken out of regular use when actually needed
- Unused surplus pages can be returned to the system
- Better memory utilization, especially with CMA backing which can
  significantly increase the changes of hugepage allocation

Without this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
bash: echo: write error: Invalid argument

With this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
./mmap_hugetlb_test
Successfully allocated huge pages at address: 0x7f9d40000000

cat mmap_hugetlb_test.c
...
    unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
    addr = mmap(NULL,
                ALLOC_SIZE, // 3GB
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
                -1,
                0);

    if (addr == MAP_FAILED) {
        fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        return 1;
    }
    printf("Successfully allocated huge pages at address: %p\n", addr);
...

Link: https://lkml.kernel.org/r/20251009172433.4158118-2-usamaarif642@gmail.com
Link: https://git.zx2c4.com/linux-rng/commit/mm/hugetlb.c?id=adbe8726dc2a3805630d517270db17e3af86e526 [1]
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-allow-overcommitting-gigantic-hugepages
+++ a/mm/hugetlb.c
@@ -2223,7 +2223,7 @@ static struct folio *alloc_surplus_huget
 {
 	struct folio *folio = NULL;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic_no_runtime(h))
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
@@ -4285,7 +4285,7 @@ static ssize_t nr_overcommit_hugepages_s
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &input);
@@ -5172,7 +5172,7 @@ static int hugetlb_overcommit_handler(co
 
 	tmp = h->nr_overcommit_huge_pages;
 
-	if (write && hstate_is_gigantic(h))
+	if (write && hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


