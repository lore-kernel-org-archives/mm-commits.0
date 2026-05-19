Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA70E19CD0A
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779151593; cv=none; b=MmuQVsp94aRrzPRY2MQ4rQbCeTPCmEwPMcLFMGEXSPzW4/aN3r3wNbYb1EpuUp8Ovwx6l65IzsX54ys66qichzildKrvEEgHwDbRA8yitD/ULSB6b/GJZTCPlutis3f4VQj0noHpq1z/kkHsn2yOvUI9vOkzkJA+KJBiZSdX7lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779151593; c=relaxed/simple;
	bh=/EFRj0rjzYScjN7u5TMB7kop97uzkPHQnXisC9NmdnI=;
	h=Date:To:From:Subject:Message-Id; b=UKaoOqACy9YaJym2Ck98wAE1gLpqCcfKeDGkrgbLKhkfuVm8JnyNSlNe7TfyOfOBgwQNEVYuRMORC1PvuFNKp0EKCdZCp0xNIFIINtDtEJ/86FFtEQ+Xpp30KgzcZp5VkIp1LSTGCa1ZUbO8EcPQuIGMHNVobA/G3mPhAfK6RWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NL8BZK8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NL8BZK8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638A9C2BCB7;
	Tue, 19 May 2026 00:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779151593;
	bh=/EFRj0rjzYScjN7u5TMB7kop97uzkPHQnXisC9NmdnI=;
	h=Date:To:From:Subject:From;
	b=NL8BZK8kZcU5aVzf1xHmT+U8kKteWqV+DzWebvTAw8k+c0THM/Zik7WtjWX3BiOvl
	 m/GSmqqJ2LjkrTUHxkTHE+uEJVVIQsGgTlRxoVMw7P6h4irg8KaxKF3ciGCvN2hwMG
	 BB5OIRtM4dRChskrniiW4ge07sqikYyc5CuGGwoA=
Date: Mon, 18 May 2026 17:46:32 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-test_hmm-check-alloc_page_vma-return-value.patch removed from -mm tree
Message-Id: <20260519004633.638A9C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: check alloc_page_vma() return value
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-check-alloc_page_vma-return-value.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: check alloc_page_vma() return value
Date: Mon, 18 May 2026 11:19:03 +0800

Return VM_FAULT_OOM if page allocation fails, which avoids a NULL pointer
dereference when calling lock_page().

Link: https://lore.kernel.org/20260518031903.63455-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value
+++ a/lib/test_hmm.c
@@ -1063,6 +1063,17 @@ static vm_fault_t dmirror_devmem_fault_a
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are

lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch

