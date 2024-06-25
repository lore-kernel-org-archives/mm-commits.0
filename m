Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5844C61B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291711; cv=none; b=VUtxcoJg9JVIJh1cNTb3bPoL1p/PDXRctnE5uIxjIaQjUvo9M/xhdkOMHdkjUvE6mWwp6Qs25IERW28UiP14+3kvArPuEv39E4jbxzikKhAq6z68WVWb4sD+jfm65EL1MZc2XN5wcP+q8ZosTtwA6Zfh/UXkU7CXjh5Zw+Flutc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291711; c=relaxed/simple;
	bh=P3SrzBmVACfB4/WCRorUkQgVcSeY9XGQ3i/MZ77F/z0=;
	h=Date:To:From:Subject:Message-Id; b=J2+TKPyJya13d2L4CNvb7RkEM1DjvEdFtuf5+vQjzzUssHDDQUFnmfyzVp5YhI84qXtWu6bBaPZD3LBIgW0/OwjNE0gZnhYDxd81Tmfo0B7NkvN+YiOuaUTWQwTvJsBKj1s37Bg1UeRt5Cr0R+xT0AYP087Sx9oZ6dlm1x/Uzzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LhdeS8R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LhdeS8R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0C4C32782;
	Tue, 25 Jun 2024 05:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291711;
	bh=P3SrzBmVACfB4/WCRorUkQgVcSeY9XGQ3i/MZ77F/z0=;
	h=Date:To:From:Subject:From;
	b=LhdeS8R9ekJo8tUCq294oLkhfqQgLhvB2FLQXZ78GmNpPYYtD3b5Jz2VoFTXBVout
	 eMY0htKEV7aL4A5wO9qVX0XKIH7/tKeyEk9ZgVq4GCu0BKk9tkXLoyQzuZ9A1DZtn2
	 suCpaxMP22Mq8i8RhZV8AwrUhD6m4Zgs9mXHlnsc=
Date: Mon, 24 Jun 2024 22:01:50 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-confusing-initialization-to-count.patch removed from -mm tree
Message-Id: <20240625050150.EC0C4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove confusing initialization to count
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-confusing-initialization-to-count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove confusing initialization to count
Date: Wed, 12 Jun 2024 15:18:28 +0800

It's meaningless and confusing to init local variable count to 1.  Remove
it.  No functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-7-linmiaohe@huawei.com
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

--- a/mm/memory-failure.c~mm-memory-failure-remove-confusing-initialization-to-count
+++ a/mm/memory-failure.c
@@ -2542,7 +2542,7 @@ int unpoison_memory(unsigned long pfn)
 	struct folio *folio;
 	struct page *p;
 	int ret = -EBUSY, ghp;
-	unsigned long count = 1;
+	unsigned long count;
 	bool huge = false;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


