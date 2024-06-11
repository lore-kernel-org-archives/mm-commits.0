Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A4838FA1
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718129217; cv=none; b=LF7oFpljqug2ngB8NIoITKDmVmxgH3eCj7Tv1JmjEpjzjhyC7t3/a7MCr/076yt3UUKhBP1+2LlSqVyNsBkN3sRBHlWKRfS7tEBbD8dK0CD/PKXqiHlYSYbqLPTbDSqxeKMTIjZSWvSu5chzPnp7S7QcW28N13yekZ+OKCJrgqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718129217; c=relaxed/simple;
	bh=k+MwGRS45Tc87hSmQFQPIrvT6FGr6azSt9Yse+vYWTI=;
	h=Date:To:From:Subject:Message-Id; b=LbPym7rdsJ4MGvr5yCWXaBVWFZPeHHF8sS4hL0d5PkLO7ZfAmUvIR0NEIxIWylip//5E/rLl42X/em3fZhj0rXq6hWOUHVZrVbY2TpvLlf/gffTaZ8hCqMO50yESeriZ+ntzzbiAVGEZDN6Uu0+4I/n8G14FiotWZak/w1Ab0HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wDkW80pY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wDkW80pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11822C2BD10;
	Tue, 11 Jun 2024 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718129217;
	bh=k+MwGRS45Tc87hSmQFQPIrvT6FGr6azSt9Yse+vYWTI=;
	h=Date:To:From:Subject:From;
	b=wDkW80pYBDZRSN6F/UoHmagnJt5tP8ecPz/hkX47CZUrkv9J1+4KBFZxtPgJyBFEf
	 GzB2xA1XW8fhiv29ZyZJRtRT7tk74qvWSlyfoJLTfh4ONaC4iBjNBgDexXXhviyHsj
	 Tdp+812fGFgjMyVmFAKKauu4h0BOrYPza5pJcPQA=
Date: Tue, 11 Jun 2024 11:06:56 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,abrestic@rivosinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-dont-require-head-page-for-do_set_pmd.patch added to mm-unstable branch
Message-Id: <20240611180657.11822C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: don't require head page for do_set_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-dont-require-head-page-for-do_set_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-dont-require-head-page-for-do_set_pmd.patch

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
From: Andrew Bresticker <abrestic@rivosinc.com>
Subject: mm/memory: don't require head page for do_set_pmd()
Date: Tue, 11 Jun 2024 08:32:16 -0700

The requirement that the head page be passed to do_set_pmd() was added in
commit ef37b2ea08ac ("mm/memory: page_add_file_rmap() ->
folio_add_file_rmap_[pte|pmd]()") and prevents pmd-mapping in the
finish_fault() and filemap_map_pages() paths if the page to be inserted is
anything but the head page for an otherwise suitable vma and pmd-sized
page.

Link: https://lkml.kernel.org/r/20240611153216.2794513-1-abrestic@rivosinc.com
Fixes: ef37b2ea08ac ("mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()")
Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-dont-require-head-page-for-do_set_pmd
+++ a/mm/memory.c
@@ -4699,8 +4699,9 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	if (page != &folio->page || folio_order(folio) != HPAGE_PMD_ORDER)
+	if (folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
+	page = &folio->page;
 
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise
_

Patches currently in -mm which might be from abrestic@rivosinc.com are

mm-memory-dont-require-head-page-for-do_set_pmd.patch

