Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB200210EE;
	Fri,  4 Oct 2024 02:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008775; cv=none; b=SFa9aiI1oBMCTNPxKA1ZG5cFDmFnrx2grHr45IeGabE2XGD7lxUyqqQ+zvgQPGU33gSa+nkAIaGOVHpyaDAPnpiVdmAu4gh7gUpFEYBN9liOvm/dO/jrfXifgfY67JyS7wXfdVZ13BuKE6eJhWP5qE2OhkbXr7Dn9wGqHiPF0GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008775; c=relaxed/simple;
	bh=v1JHYJ6KF5ib7Z5DqzQZsUHTP1r6m3/DD/zEydzJeLk=;
	h=Date:To:From:Subject:Message-Id; b=fzfmiLAPiEO5EdQt1s+xtjSWedWs1FlBiGTGOU3UdZB6FCpQv4Ct59hWxnmbZadOMYq9Sv30qX7BhjY+AegJ1wKW2ijJmFdGdFjAUtLeV8X1ttImha18b5o9X6dNXI2SYXh7U4nRUkq/WFzSvFcac3CEcirJI9V2K+IaVNzG6oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cdwjVbtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cdwjVbtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DF1C4CECC;
	Fri,  4 Oct 2024 02:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008774;
	bh=v1JHYJ6KF5ib7Z5DqzQZsUHTP1r6m3/DD/zEydzJeLk=;
	h=Date:To:From:Subject:From;
	b=cdwjVbtxQREYIq4M+bhFe6s6SL8GPL6TZ9z8ciLwCOuKXdGO7UmxYpEtJ/mJc2q1l
	 Xe0CU6pvRBTHNGjuHS311t1oQXcYOh9t5uHYu6PqFw5u+0kgrBNJLT1teSR3UIB4R6
	 Ktn++JhN+9R14m47asiaYZMn8OrU7JTLEWhazhTw=
Date: Thu, 03 Oct 2024 19:26:13 -0700
To: mm-commits@vger.kernel.org,zhaojianxiong.zjx@alibaba-inc.com,stable@vger.kernel.org,joao.m.martins@oracle.com,dan.j.williams@intel.com,llfl@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] device-dax-correct-pgoff-align-in-dax_set_mapping.patch removed from -mm tree
Message-Id: <20241004022614.77DF1C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: device-dax: correct pgoff align in dax_set_mapping()
has been removed from the -mm tree.  Its filename was
     device-dax-correct-pgoff-align-in-dax_set_mapping.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kun(llfl)" <llfl@linux.alibaba.com>
Subject: device-dax: correct pgoff align in dax_set_mapping()
Date: Fri, 27 Sep 2024 15:45:09 +0800

pgoff should be aligned using ALIGN_DOWN() instead of ALIGN().  Otherwise,
vmf->address not aligned to fault_size will be aligned to the next
alignment, that can result in memory failure getting the wrong address.

It's a subtle situation that only can be observed in
page_mapped_in_vma() after the page is page fault handled by
dev_dax_huge_fault.  Generally, there is little chance to perform
page_mapped_in_vma in dev-dax's page unless in specific error injection
to the dax device to trigger an MCE - memory-failure.  In that case,
page_mapped_in_vma() will be triggered to determine which task is
accessing the failure address and kill that task in the end.


We used self-developed dax device (which is 2M aligned mapping) , to
perform error injection to random address.  It turned out that error
injected to non-2M-aligned address was causing endless MCE until panic.
Because page_mapped_in_vma() kept resulting wrong address and the task
accessing the failure address was never killed properly:


[ 3783.719419] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3784.049006] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3784.049190] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3784.448042] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3784.448186] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3784.792026] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3784.792179] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3785.162502] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3785.162633] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3785.461116] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3785.461247] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3785.764730] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3785.764859] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3786.042128] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3786.042259] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3786.464293] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3786.464423] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3786.818090] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3786.818217] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered
[ 3787.085297] mce: Uncorrected hardware memory error in user-access at 
200c9742380
[ 3787.085424] Memory failure: 0x200c9742: recovery action for dax page: 
Recovered

It took us several weeks to pinpoint this problem,  but we eventually
used bpftrace to trace the page fault and mce address and successfully
identified the issue.


Joao added:

; Likely we never reproduce in production because we always pin
: device-dax regions in the region align they provide (Qemu does
: similarly with prealloc in hugetlb/file backed memory).  I think this
: bug requires that we touch *unpinned* device-dax regions unaligned to
: the device-dax selected alignment (page size i.e.  4K/2M/1G)

Link: https://lkml.kernel.org/r/23c02a03e8d666fef11bbe13e85c69c8b4ca0624.1727421694.git.llfl@linux.alibaba.com
Fixes: b9b5777f09be ("device-dax: use ALIGN() for determining pgoff")
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
Tested-by: JianXiong Zhao <zhaojianxiong.zjx@alibaba-inc.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/device.c~device-dax-correct-pgoff-align-in-dax_set_mapping
+++ a/drivers/dax/device.c
@@ -86,7 +86,7 @@ static void dax_set_mapping(struct vm_fa
 		nr_pages = 1;
 
 	pgoff = linear_page_index(vmf->vma,
-			ALIGN(vmf->address, fault_size));
+			ALIGN_DOWN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
_

Patches currently in -mm which might be from llfl@linux.alibaba.com are


