Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6419F200B7
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717193981; cv=none; b=f0pha3VTbg0WSreImi0Y+2fWmdXecmLAza2WvnYQxe6MR6yO3MT4w5Cj3v1214ktN74nU/iShhipBYVE1Q9pbviqDnZol59s+cYahUhvk2/qt6jQ+fRp3UXa2shKJC74XcYggC1k1bWb+hJaxm60sMTq8jv9bWkMTnFsvBKVXZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717193981; c=relaxed/simple;
	bh=SsSd4S0Tf5umypoTx5L+GkKTbavyjoO8l1Fv04ccLto=;
	h=Date:To:From:Subject:Message-Id; b=bPeiJppoU9uweHLemPAHE4KF3aoJ8EcyWz5lOvY2oLkWrVDiTA0LfBDUc2gWA5FnKw78wqEQdsGcFnF1p4rV5H6Pr3TtnVZ5QIfvntdDwNC2P4be5VgUx3HHJDM9gVLv6bNr6HwROj0hrhtvvX81pjXMnFsqpgqUNohJ/OZ+7Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OZTP7Ako; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OZTP7Ako"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F006C116B1;
	Fri, 31 May 2024 22:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717193980;
	bh=SsSd4S0Tf5umypoTx5L+GkKTbavyjoO8l1Fv04ccLto=;
	h=Date:To:From:Subject:From;
	b=OZTP7AkoX9DotvORGT4jkKIIvAEv59+Wa2yYpjzOtMjUQIICNuul7UMsTD0ZhcCzg
	 3yF0DtDoJValH1NgMk5CYkPJfAWXGj/qn+Lc/TnIpcawEGI+JpRCe2AzeT2hR79BU8
	 mfCs57UgWYoH959AEZB0sf1nFrKGFK85X+746pzg=
Date: Fri, 31 May 2024 15:19:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,kees@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-xyz_noprof-functions-calling-profiled-functions.patch added to mm-hotfixes-unstable branch
Message-Id: <20240531221940.9F006C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix xyz_noprof functions calling profiled functions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-xyz_noprof-functions-calling-profiled-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-xyz_noprof-functions-calling-profiled-functions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix xyz_noprof functions calling profiled functions
Date: Fri, 31 May 2024 13:53:50 -0700

Grepping /proc/allocinfo for "noprof" reveals several xyz_noprof
functions, which means internally they are calling profiled functions. 
This should never happen as such calls move allocation charge from a
higher level location where it should be accounted for into these lower
level helpers.  Fix this by replacing profiled function calls with noprof
ones.

Link: https://lkml.kernel.org/r/20240531205350.3973009-1-surenb@google.com
Fixes: b951aaff5035 ("mm: enable page allocation tagging")
Fixes: e26d8769da6d ("mempool: hook up to memory allocation profiling")
Fixes: 88ae5fb755b0 ("mm: vmalloc: enable memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 mm/mempool.c |    2 +-
 mm/util.c    |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~mm-fix-xyz_noprof-functions-calling-profiled-functions
+++ a/mm/filemap.c
@@ -1000,7 +1000,7 @@ struct folio *filemap_alloc_folio_noprof
 		do {
 			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
-			folio = __folio_alloc_node(gfp, order, n);
+			folio = __folio_alloc_node_noprof(gfp, order, n);
 		} while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return folio;
--- a/mm/mempool.c~mm-fix-xyz_noprof-functions-calling-profiled-functions
+++ a/mm/mempool.c
@@ -273,7 +273,7 @@ mempool_t *mempool_create_node_noprof(in
 {
 	mempool_t *pool;
 
-	pool = kzalloc_node(sizeof(*pool), gfp_mask, node_id);
+	pool = kmalloc_node_noprof(sizeof(*pool), gfp_mask | __GFP_ZERO, node_id);
 	if (!pool)
 		return NULL;
 
--- a/mm/util.c~mm-fix-xyz_noprof-functions-calling-profiled-functions
+++ a/mm/util.c
@@ -705,7 +705,7 @@ void *kvrealloc_noprof(const void *p, si
 
 	if (oldsize >= newsize)
 		return (void *)p;
-	newp = kvmalloc(newsize, flags);
+	newp = kvmalloc_noprof(newsize, flags);
 	if (!newp)
 		return NULL;
 	memcpy(newp, p, oldsize);
@@ -726,7 +726,7 @@ void *__vmalloc_array_noprof(size_t n, s
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
-	return __vmalloc(bytes, flags);
+	return __vmalloc_noprof(bytes, flags);
 }
 EXPORT_SYMBOL(__vmalloc_array_noprof);
 
@@ -737,7 +737,7 @@ EXPORT_SYMBOL(__vmalloc_array_noprof);
  */
 void *vmalloc_array_noprof(size_t n, size_t size)
 {
-	return __vmalloc_array(n, size, GFP_KERNEL);
+	return __vmalloc_array_noprof(n, size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc_array_noprof);
 
@@ -749,7 +749,7 @@ EXPORT_SYMBOL(vmalloc_array_noprof);
  */
 void *__vcalloc_noprof(size_t n, size_t size, gfp_t flags)
 {
-	return __vmalloc_array(n, size, flags | __GFP_ZERO);
+	return __vmalloc_array_noprof(n, size, flags | __GFP_ZERO);
 }
 EXPORT_SYMBOL(__vcalloc_noprof);
 
@@ -760,7 +760,7 @@ EXPORT_SYMBOL(__vcalloc_noprof);
  */
 void *vcalloc_noprof(size_t n, size_t size)
 {
-	return __vmalloc_array(n, size, GFP_KERNEL | __GFP_ZERO);
+	return __vmalloc_array_noprof(n, size, GFP_KERNEL | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vcalloc_noprof);
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-fix-xyz_noprof-functions-calling-profiled-functions.patch

