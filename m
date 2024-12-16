Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715FC1BC064;
	Mon, 16 Dec 2024 06:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734329231; cv=none; b=rhxc1/+s85ZJ1+32ag0UUJpPWr/AcvFiwpJip/tBnVKxyncjnUlwd0t4BGKvcwLDaXAPD4nGcJKhXU1FiU/6XXYQlXc3/GcLTZDtfu3L6Jj8raOeLJ6CsTeETxtowaCFCYvYKnuFqSdruwInJ13df/aR/vYxqGHocq0nc9tMjdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734329231; c=relaxed/simple;
	bh=ARLGYqALIicpIa9hKrxfiET/QNDzMb6BhlkAwLVgXAU=;
	h=Date:To:From:Subject:Message-Id; b=SnrxeRsYzGuuRnk4uPFiFyjKeTQbJlHQxwhZubupMyZsVtc75HuszxOx8xaZyacTYYqVxA9jdtnFTBad2F41o/7VerXJaOXpzOCdVGk/PTq8tdXpQGxWUXwN+lVMcW6eJyyxkvKbI84SAqS72QREjHt59HDT7FBdrNV/YqsJMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2swRzczA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2swRzczA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84A5C4CED0;
	Mon, 16 Dec 2024 06:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734329231;
	bh=ARLGYqALIicpIa9hKrxfiET/QNDzMb6BhlkAwLVgXAU=;
	h=Date:To:From:Subject:From;
	b=2swRzczAccmTN7qWGLiqZc60cYaUdCMYadN0hcBN5n3QRNctnJe54UtpCsYznioU4
	 RkxKlHK7jdAAEI7ogC0iwaoO9Z63kOzcp0FedbjPs1vw3ebmkhEnYCG3FUn/hDwnDn
	 arVl5n6utflbh9DnSp10XOnlZFOTutZbk6jqGlYE=
Date: Sun, 15 Dec 2024 22:07:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,dafna.hirschfeld@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio.patch removed from -mm tree
Message-Id: <20241216060710.E84A5C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: change ENOSPC to ENOMEM in alloc_hugetlb_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Dafna Hirschfeld <dafna.hirschfeld@intel.com>
Subject: mm/hugetlb: change ENOSPC to ENOMEM in alloc_hugetlb_folio
Date: Sun, 1 Dec 2024 03:03:41 +0200

The error ENOSPC is translated in vmf_error to VM_FAULT_SIGBUS which is
further translated in EFAULT in i.e.  pin/get_user_pages.  But when
running out of pages/hugepages we expect to see ENOMEM and not EFAULT.

Link: https://lkml.kernel.org/r/20241201010341.1382431-1-dafna.hirschfeld@intel.com
Fixes: 8f34af6f93ae ("mm, hugetlb: move the error handle logic out of normal code path")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@intel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -3113,7 +3113,7 @@ out_end_reservation:
 	if (!memcg_charge_ret)
 		mem_cgroup_cancel_charge(memcg, nr_pages);
 	mem_cgroup_put(memcg);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(-ENOMEM);
 }
 
 int alloc_bootmem_huge_page(struct hstate *h, int nid)
_

Patches currently in -mm which might be from dafna.hirschfeld@intel.com are


