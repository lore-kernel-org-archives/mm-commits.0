Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9221DE4EF
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939994; cv=none; b=Ikstyrq9iA4pLK9/D73WVbztQVl6c9ulutXksXOKGhvoUWT+zXFS0o6E7VJVxLvm/4XnfpLYyJX4GwSldlv1YBb8Eb1cFUc5KfEWzW5ZufO4uo/o/p8aytxftbzJ4u+L0/FnSflvTI3zIDkttnpwRRtrOknYnIHwvwd7GSUdZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939994; c=relaxed/simple;
	bh=RELRcNISoMHXLHRJndEgsdAnD7hv7eDLga6x0RMz9Rc=;
	h=Date:To:From:Subject:Message-Id; b=Ojwhtmbu657RqxYvCyKvWmJUeKVHl1qjmRWblWQETnoWsVyzBlpvdlQlDrlyNroGvdS5y5mF08NMBy8Xd7MXjAyogKSvAGN3UwHiJv/uVhdrPl5wsu6xh3E+XcxCbQwIIxtoUUugQd3VyXxDlH+NrWiNAj/dHRMqKLXbVLoKCrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P7b/FhN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P7b/FhN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F33C4CEF7;
	Thu, 12 Feb 2026 23:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939994;
	bh=RELRcNISoMHXLHRJndEgsdAnD7hv7eDLga6x0RMz9Rc=;
	h=Date:To:From:Subject:From;
	b=P7b/FhN7HumrpTMLE/ROD95E0Rb/Vcn72jK5PbpItyWotFQW8dM41YrtnpdKLsGPJ
	 ptA4hgfBnSH0oSeEKuy5gy/LHcnKUfnkz6WmgbCEUkQcwlb9rKlYfLptnh48TgA/dd
	 CRVsxRsOw/Db2diwCUhn0dJS4CDSbznDeO6bIvR0=
Date: Thu, 12 Feb 2026 15:46:33 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-remove-unnecessary-warn_onerr-in-kho_populate.patch removed from -mm tree
Message-Id: <20260212234634.65F33C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: remove unnecessary WARN_ON(err) in kho_populate()
has been removed from the -mm tree.  Its filename was
     kho-remove-unnecessary-warn_onerr-in-kho_populate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: remove unnecessary WARN_ON(err) in kho_populate()
Date: Thu, 12 Feb 2026 11:11:46 +0000

The following pr_warn() provides detailed error and location information,
WARN_ON(err) adds no additional debugging value, so remove the redundant
WARN_ON() call.

Link: https://lkml.kernel.org/r/20260212111146.210086-3-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-remove-unnecessary-warn_onerr-in-kho_populate
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1507,7 +1507,7 @@ void __init kho_populate(phys_addr_t fdt
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
-		if (WARN_ON(err)) {
+		if (err) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto unmap_scratch;
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


