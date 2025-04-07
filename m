Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF02AE90
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002495; cv=none; b=Ih0ReQYaKII/5bHnFrFqYkjxsNnV4/MP72wLOfIILq3L1WsUK7qB9ZqT6VlzEDmUdzfNY2N4YS5XmnCUnNw2oipNvUmFAhfV6uknMColctOpnHxMQMsaQ3y8pYZAgQ6A20/tctbidrEBP4AJgitIALKXFs24dIGpqzLkLhjbTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002495; c=relaxed/simple;
	bh=JacFw2BaQ7uKl0PTxjie49hD7lv6/DV4SjhVvg9P6Ck=;
	h=Date:To:From:Subject:Message-Id; b=ZOBe3yOF8BtH6J9KYqpWZogZAQ0PMu8ReUM0lYijCKFjgzqbYQ39ddrvCdClF9e1z4IGp4N/ryrIMVg0THEZP7n7pB2639ibf8umDN5iJQEcWB//SPae8M/KCu1g3jZT5+qfx/OfOYKXyzKaKgOwMl+Ty9fHhL8scOi8QAmiwuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvlDGjO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvlDGjO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CADFC4CEDD;
	Mon,  7 Apr 2025 05:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744002495;
	bh=JacFw2BaQ7uKl0PTxjie49hD7lv6/DV4SjhVvg9P6Ck=;
	h=Date:To:From:Subject:From;
	b=nvlDGjO5WwpNqPTs7RNESUueHEnb456J7B8hC0o0Ek5WL24zymW6Yo1Z/qXIM11Sg
	 F2xgiZP7n/xOwAbDnu/Azgn0dx/h2NXPoT1lSeAxZNVZVT4Epcmk4bqFh/R/r/ATQm
	 ZFquGd/hoE2GXc6u+7qlQDF2KfKQf6eu5LMi63IU=
Date: Sun, 06 Apr 2025 22:08:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,linmiaohe@huawei.com,gshan@redhat.com,gehao@kylinos.cn,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch added to mm-new branch
Message-Id: <20250407050815.6CADFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch

This patch will later appear in the mm-new branch at
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
Subject: mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix
Date: Sun Apr  6 10:06:36 PM PDT 2025

simplify __dump_folio(), per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: gehao <gehao@kylinos.cn>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix
+++ a/mm/debug.c
@@ -74,7 +74,9 @@ static void __dump_folio(struct folio *f
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	mapcount = page_mapcount_is_type(mapcount) ? 0 : mapcount;
+	if (page_mapcount_is_type(mapcount))
+		mapcount = 0;
+
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch

