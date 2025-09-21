Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68828DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489815; cv=none; b=cnpMdIrQAxV67Jyqk3g+4dqxb5FEPhJB9CwJF+XW6aX0919oeNmmFS2DgjQTM0/Ng0+PsHNZ4EpD7kcHkBLVwddvccTpDHuM4Bcr4gJpSOaKRL67mlDYKXPQSkAHDX+P/eARXIG8FIBgsB43N6iz8RyzQ1ULGdG8aJTASW7j5g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489815; c=relaxed/simple;
	bh=B3coRZUbkxCzJWQ7j33HNSV9A16q9kik1XhhXAgoceI=;
	h=Date:To:From:Subject:Message-Id; b=T/TO+OEZD2BHEmzuo4zB5xbTEZ9Cv6KG0R9vFSO+VMVbxM48TbNMj1MbZrmmJ8eLcPAWftY0qOPXj5g/8kBO++sIrl/hzrNer0vmMNfGI85Duhuk6Ed7Ss77YLcXjpTI2Y4npQ/q4qwNx0Akt8HF6gWUM0fSsoEtLD2YO/AwYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ietHaphq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ietHaphq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7A3C4CEE7;
	Sun, 21 Sep 2025 21:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489815;
	bh=B3coRZUbkxCzJWQ7j33HNSV9A16q9kik1XhhXAgoceI=;
	h=Date:To:From:Subject:From;
	b=ietHaphqHoQ5Hs1eqO8hHPjLLEGT+QnWqpxYpNZRCStlbNDtTGovtijfxtC6VAurb
	 Sgbo2dtWi1ZknhlPFU/+DhNVfclmBps9CPys7hJNbWA91cEC2wl54NJyJxPGOsB9IW
	 mJDOvC8AvdYoE2I+3K+aooFG3o9oMtJNu47Q4N94=
Date: Sun, 21 Sep 2025 14:23:34 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages.patch removed from -mm tree
Message-Id: <20250921212335.4F7A3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
has been removed from the -mm tree.  Its filename was
     mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Mon, 1 Sep 2025 17:03:28 +0200

Let's reject unreasonable folio sizes early, where we can still fail. 
We'll add sanity checks to prepare_compound_head/prepare_compound_page
next.

Is there a way to configure a system such that unreasonable folio sizes
would be possible?  It would already be rather questionable.

If so, we'd probably want to bail out earlier, where we can avoid a WARN
and just report a proper error message that indicates where something went
wrong such that we messed up.

Link: https://lkml.kernel.org/r/20250901150359.867252-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memremap.c~mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages
+++ a/mm/memremap.c
@@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
+		      "requested folio size unsupported\n"))
+		return ERR_PTR(-EINVAL);
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
_

Patches currently in -mm which might be from david@redhat.com are


