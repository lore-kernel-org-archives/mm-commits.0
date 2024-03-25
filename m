Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294255E59
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711389474; cv=none; b=rCOduQzPMh/H3lQsbwd74clLJYh0FTqJW+l+aOryXqSYtIAoEvJVLJ22PAhz+b3EpW2i4lbozk9eXgVfYXIhlbQvUyN6crzCJuiOPxN0AqaLCClosVdemdOSigAc6hEm33dHpdYHsqAlvhnbt0tB1Q+uOby2uWZaoRA/s3tx9SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711389474; c=relaxed/simple;
	bh=Bs4vaE7tTyW+MBy2BZ6u2pTViRyIxsvu+dPmp4re95g=;
	h=Date:To:From:Subject:Message-Id; b=T15pD1KvY1BsHNf8ynA1BXhiYHLsM8Rp20i8nw66Uu7Gea7fmnPyP6Rp0vDJt+P4etZB5xSQ6r90EL3jhsmtxsttdww+oat3BiGynIvJssUdaMjQEOSsb+Vz/56PfFziLonyY4f9YP9ONuaTlr3idTNcqdK7T3W4sZrmySR6zVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=poREihkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="poREihkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53764C433F1;
	Mon, 25 Mar 2024 17:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711389474;
	bh=Bs4vaE7tTyW+MBy2BZ6u2pTViRyIxsvu+dPmp4re95g=;
	h=Date:To:From:Subject:From;
	b=poREihkrZ5276tZFFZIkGvmu43MI1n355c965KVvtQnYux28QIkJzndl7RYRfpFUs
	 74xQ3lWBBLpG8Juz6/EcyqvnfRMKwpsOq8j9qoFYU1d8WDsgjE51qAjzmnkdVfUXYg
	 mT+ZqJ4Pmcngo0QqcWtgDFQ064C2hzmNmJ60ybps=
Date: Mon, 25 Mar 2024 10:57:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-up-pg_slab-fix.patch added to mm-unstable branch
Message-Id: <20240325175754.53764C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-free-up-pg_slab-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-up-pg_slab-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-up-pg_slab-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-free-up-pg_slab-fix
Date: Mon, 25 Mar 2024 15:19:20 +0000

update vmcoreinfo

Link: https://lkml.kernel.org/r/ZgGV-O8WYQ_83kxp@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/vmcore_info.c~mm-free-up-pg_slab-fix
+++ a/kernel/vmcore_info.c
@@ -198,7 +198,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
-	VMCOREINFO_NUMBER(PG_slab);
+#define PAGE_SLAB_MAPCOUNT_VALUE	(~PG_slab)
+	VMCOREINFO_NUMBER(PAGE_SLAB_MAPCOUNT_VALUE);
 #ifdef CONFIG_MEMORY_FAILURE
 	VMCOREINFO_NUMBER(PG_hwpoison);
 #endif
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

