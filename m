Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8100222E3F0
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 02:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756954798; cv=none; b=L58E4jP9doRDJShOZRIvt+qnz0yuwaCc+x8iDjNs83WtFE5CajNZAcmw680m7Q3POpI1oBrg5hhmtPBbqzdKN3LQ7uD5euRlEkBDylosIje2ACzoViV9dIbIG4OI5yAVKL7g6c1NYVL9UobBH5mdgjCqhFJ+TS0ydItnpnweMrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756954798; c=relaxed/simple;
	bh=1UqQIZPZyf0NsxMgUo0GOVLLP73ZYOkEkxX8cQn5kXI=;
	h=Date:To:From:Subject:Message-Id; b=twDVIDkboNFqOCwFOvw3Wc3gddkbLn/12qR0kveBuJC1VH0UeyX0/eVep+87tx7u0jlSleqTM7BTYNwIpFyrWAzfNCKNVLBONhwuAydsss1zxGIWu4HFrsZp315EBKuz4gsPJjvKg9n+iKcATfXVLO94iPN3tqx50IguDFRolzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZVpaSV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZVpaSV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC982C4CEE7;
	Thu,  4 Sep 2025 02:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756954798;
	bh=1UqQIZPZyf0NsxMgUo0GOVLLP73ZYOkEkxX8cQn5kXI=;
	h=Date:To:From:Subject:From;
	b=zZVpaSV/3mDZVJOnu0bUvuCqUUM99cXbVG2O/v5Es0ekrWQ89sfScM17WZiK98XUN
	 jChPqTIMFeV8wPk/nqR5nVWjlHYXz+BnutkPz0FCXAkl3pyNS3XyZRnIiBFfmvooyn
	 d0ZVA2vlRBAiw/zcx2kYn17WGdtcrTzMWN89K24w=
Date: Wed, 03 Sep 2025 19:59:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sfr@canb.auug.org.au,rppt@kernel.org,lorenzo.stoakes@oracle.com,jcmvbkbc@gmail.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch added to mm-unstable branch
Message-Id: <20250904025957.EC982C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
Date: Wed Sep  3 07:51:59 PM PDT 2025

nastily "fix" folio_page()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-constify-highmem-related-functions-for-improved-const-correctness-fix
+++ a/include/linux/page-flags.h
@@ -316,9 +316,9 @@ static __always_inline unsigned long _co
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-static inline struct page *folio_page(struct folio *folio, unsigned long n)
+static inline struct page *folio_page(const struct folio *folio, unsigned long n)
 {
-	return &folio->page + n;
+	return (struct page *)(&folio->page + n);
 }
 
 static __always_inline int PageTail(const struct page *page)
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

