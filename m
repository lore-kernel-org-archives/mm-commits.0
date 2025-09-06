Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B061A17E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118409; cv=none; b=jdK0XPqKQkYSoxY3HF7M8hup34Ss4J+tCaVKCLpEr7wH1av8Q89zYmIgm+F6fPEJfBxDNLZDz+94KIi1JujahsgxFVgLw8t0oBgqzocQwJCjddifQAgc28Aeg4YbOWRv/eUjY6xXU8CvT2FoxLu4byWZUFq+5UUWxnk0asghv+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118409; c=relaxed/simple;
	bh=BCKJqPoNbLjeDWhcoyBV2yPC6hwKjJuesez2FVZcs/Y=;
	h=Date:To:From:Subject:Message-Id; b=OiD2S861/XFgbFZUgXo/Ukntg5/MmqjF4tdNAPiVn81/3TarRGYM3SauBCOQScL9YgxkWF9pAZWd0OGceZNdaqc/1qAtmjkwvNTRpgm9PzWdnGGYchwsUlcPO1ugQ24Ila4z4yfhJESDe+TQ2mTy3zIOkFdwlUWEhG2qqRXODtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZprfE9zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZprfE9zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320ACC4CEF1;
	Sat,  6 Sep 2025 00:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118408;
	bh=BCKJqPoNbLjeDWhcoyBV2yPC6hwKjJuesez2FVZcs/Y=;
	h=Date:To:From:Subject:From;
	b=ZprfE9zcBFRM+p6md51IsD9ynUyfQz9e72uaMhhkCHzQ8oOq4H0KOt6CjBA+i1FJq
	 EfhEb8dYSxjVUNoWD4oYw/rXio0XdxqgIXi7b8C0phgVRHW5Jfaam5rbsBtXkD5Wf2
	 x1eBcHGPMNpC21YQQTaGzxt3/ecRQl2F9vWa6YQ4=
Date: Fri, 05 Sep 2025 17:26:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-document-for-swap-table-fix.patch added to mm-new branch
Message-Id: <20250906002648.320ACC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-mm-add-document-for-swap-table-fix
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-add-document-for-swap-table-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-document-for-swap-table-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-mm-add-document-for-swap-table-fix
Date: Fri Sep  5 05:21:05 PM PDT 2025

fix typos, per Chris

Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/swap-table.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/swap-table.rst~docs-mm-add-document-for-swap-table-fix
+++ a/Documentation/mm/swap-table.rst
@@ -32,8 +32,8 @@ was in.
    the transient state of swap out or swap in. The folio data can be in
    the folio or swap file, or both.
 
-3. shadow: The shadow contains the working set information of the swap
-   outed folio. This is the normal state for a swap outed page.
+3. shadow: The shadow contains the working set information of the swapped
+   out folio. This is the normal state for a swapped out page.
 
 Swap Table
 ----------
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
docs-mm-add-document-for-swap-table-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

