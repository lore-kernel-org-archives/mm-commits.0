Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8BE4C61B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291712; cv=none; b=aeL05cZGaS3gOOGNcXCXXeWDb78Quvq1z36cPWBQ88VSviz/Qu58Ta3m2MYBkLJEOyq34BaePFdjdfRmnyUQM0TVcbbPMqBEfj3COPBDiep5LhEK6AKJKEbL0Kz4Duvb4LxuIANfKjxld1yGpvImTMFbyaU9cHNuw2XB58c6NRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291712; c=relaxed/simple;
	bh=SV5otnyctqIupAYHmQMIqOltVuOQlqveEJMn05pSMME=;
	h=Date:To:From:Subject:Message-Id; b=LDWy6T6QAA+9yFrY17S5sz9NwtL0TYekjGDuXM+NRrQIn/ZnFsDmFVF5kETjFL6ZvA/HHoUQud68vQhqCn9jMnRXd4zY+9fRdlq2EmNdtJRqH2r6krVcTok/qoPvaWwt+H0jj8ZoyCcZRDXXHv1ZhrBS3lWew5eZDgcnjH5NByU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yA8ykpaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yA8ykpaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06180C32782;
	Tue, 25 Jun 2024 05:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291712;
	bh=SV5otnyctqIupAYHmQMIqOltVuOQlqveEJMn05pSMME=;
	h=Date:To:From:Subject:From;
	b=yA8ykpaG9VkTPCzdiX+fls7Iy24dZFyp2JvNBqF2IQ+OMYSfNYYo6tbEYXn5yxjqz
	 zF5RLg1oPBXdJr4EqIYzbLPxckF9KHOsU6gwD7jGMjzLw44IwdYKZUSmn8+JIj7DTi
	 eCB2j0Htvx4p8/VgTncSLM666pgg8bRSUk0OdXCs=
Date: Mon, 24 Jun 2024 22:01:51 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch removed from -mm tree
Message-Id: <20240625050152.06180C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: don't export hwpoison_filter() when !CONFIG_HWPOISON_INJECT
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: don't export hwpoison_filter() when !CONFIG_HWPOISON_INJECT
Date: Wed, 12 Jun 2024 15:18:29 +0800

When CONFIG_HWPOISON_INJECT is not enabled, there is no user of the
hwpoison_filter() outside memory-failure.  So there is no need to export
it in that case.

Link: https://lkml.kernel.org/r/20240612071835.157004-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406070136.hGQwVbsv-lkp@intel.com/
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject
+++ a/mm/memory-failure.c
@@ -294,6 +294,7 @@ int hwpoison_filter(struct page *p)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hwpoison_filter);
 #else
 int hwpoison_filter(struct page *p)
 {
@@ -301,8 +302,6 @@ int hwpoison_filter(struct page *p)
 }
 #endif
 
-EXPORT_SYMBOL_GPL(hwpoison_filter);
-
 /*
  * Kill all processes that have a poisoned page mapped and then isolate
  * the page.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


