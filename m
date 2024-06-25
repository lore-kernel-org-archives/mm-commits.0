Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE9A144315
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291716; cv=none; b=fEW8Hl0MifAYv5bOfcBv4qZZh5N+mjPT39VlPTZDSTIfO4utvdXtHKGu64ahKrsk0qiOA9cLtXJB0rKPP0N9FXwfylc4mLvSgL06+DTMm67g1hDS2mADfpjWLw6vajQhcJ1dtR1ii02SR2WoT4hFW63fbogcxO3tDL6NSx/gIn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291716; c=relaxed/simple;
	bh=JHDk80PAmJFQEy3gLzZlTBe4ffCbp/QwvHrhZPDBgXQ=;
	h=Date:To:From:Subject:Message-Id; b=QjYB6S7hnNKhCRcbylqySRjEcZiGSNDG2EaAKc+DW8SY+5Va1pU36fVnKRkBY5+SwgQzWvMFRJnYqtd2dpAiAm9UovTXhf7i1aysmBBb3XjUCo/uwjBgPgdce2Ix8GWmQaFjT7OGbAJ5gFhsAZilbxz7K45PYFOwLkOpDb2P7yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uBApFb+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uBApFb+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57B1C32782;
	Tue, 25 Jun 2024 05:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291716;
	bh=JHDk80PAmJFQEy3gLzZlTBe4ffCbp/QwvHrhZPDBgXQ=;
	h=Date:To:From:Subject:From;
	b=uBApFb+ks6o5rWanFxeHAkIgncWM1zxNdWRTd6q37NfU5vgTwgmGrSL7jq7mTai2P
	 fImfjAInxe07c3d4NKWuQRfa9cdRSNcpEp3Lsia/K69hWu5b1ERxg2+J402kvADe79
	 DntIZwFFIwKrFvRcQwQaK2gD77exJ2oTORheLf0E=
Date: Mon, 24 Jun 2024 22:01:56 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-fix-comment-of-get_hwpoison_page.patch removed from -mm tree
Message-Id: <20240625050156.A57B1C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix comment of get_hwpoison_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-comment-of-get_hwpoison_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix comment of get_hwpoison_page()
Date: Wed, 12 Jun 2024 15:18:33 +0800

When return value is 0, it could also means the page is free hugetlb page
or free buddy page.  Fix the corresponding comment.

Link: https://lkml.kernel.org/r/20240612071835.157004-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-comment-of-get_hwpoison_page
+++ a/mm/memory-failure.c
@@ -1525,7 +1525,7 @@ static int __get_unpoison_page(struct pa
  * the given page has PG_hwpoison. So it's never reused for other page
  * allocations, and __get_unpoison_page() never races with them.
  *
- * Return: 0 on failure,
+ * Return: 0 on failure or free buddy (hugetlb) page,
  *         1 on success for in-use pages in a well-defined state,
  *         -EIO for pages on which we can not handle memory errors,
  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


