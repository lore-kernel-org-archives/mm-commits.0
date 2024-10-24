Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD33C14A0A3
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 04:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729743574; cv=none; b=DeJNaC7vSJselkrm0b67QhLOIX6mNUOeIVNMhbrQAfpq58d8/zf4t9u/K9mQSqLCtlqX13u6njAnxGeRswsDoG/aMMp3LnFpJoQSg/zaewzNMf0xFNX+DXGNYIjYS2Eg7U8SHZmWKdQ0jjebVZs9XEwA4dvyZ4d8YKFeDsFFlow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729743574; c=relaxed/simple;
	bh=X8/2DTS5iPdzRY9MrDlmPgjj52O1DK8+DvFYoXDrRF0=;
	h=Date:To:From:Subject:Message-Id; b=KVT1A85/5Nqun6Mv1UoGAAo0XVCKA5PIonWyJAxfz96WFVkTPbMZ1VHAF6Rm2TnGp1auGxJc+vYEX2Ihvp8zRHilWuNsVmQ3dSZgk8Z07k6bsqMbfQjBfBq4IobmRa3cjjEw0xhXIbRigTs5WpRJaXiil81mMRMn4dL3Q4wARPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/unXE14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/unXE14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565A6C4CEC7;
	Thu, 24 Oct 2024 04:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729743574;
	bh=X8/2DTS5iPdzRY9MrDlmPgjj52O1DK8+DvFYoXDrRF0=;
	h=Date:To:From:Subject:From;
	b=Q/unXE1458XZJkGPTP+psPGt/5j7mc8+yut8Wglqq1l4qsZMFiaEQ/5eIpMH28PEa
	 FsUsTZgtrOyNJ7iisWj45R/LFTOWIn3i3QxcQovDR5sn9vOBHk7fMQDWWRGrTrUPDn
	 eE48uiOS+iIWs3Kl0MCktROJXnmKNzORCIWf35FQ=
Date: Wed, 23 Oct 2024 21:19:33 -0700
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,hbathini@linux.ibm.com,david@redhat.com,bhe@redhat.com,liad.per@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] makefile-remove-unused-filechk_cat.patch removed from -mm tree
Message-Id: <20241024041934.565A6C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Makefile: remove unused filechk_cat
has been removed from the -mm tree.  Its filename was
     makefile-remove-unused-filechk_cat.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Liad Peretz <liad.per@gmail.com>
Subject: Makefile: remove unused filechk_cat
Date: Wed, 23 Oct 2024 10:06:11 +0300

Link: https://lkml.kernel.org/r/20241023070611.67449-1-liad.per@gmail.com
Signed-off-by: Liad Peretz <liad.per@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/Makefile~makefile-remove-unused-filechk_cat
+++ a/kernel/Makefile
@@ -146,8 +146,6 @@ targets += config_data config_data.gz
 $(obj)/config_data.gz: $(obj)/config_data FORCE
 	$(call if_changed,gzip)
 
-filechk_cat = cat $<
-
 $(obj)/config_data: $(KCONFIG_CONFIG) FORCE
 	$(call filechk,cat)
 
_

Patches currently in -mm which might be from liad.per@gmail.com are


