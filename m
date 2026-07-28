Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54D3BB57;
	Tue, 28 Jul 2026 00:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199227; cv=none; b=i9OJGwGj01GJNXA+4gquBn9kMt6vhro7+Vc8RCNrVproAFF8oWDP/0VCC3n1N2mYW0HUw5qVuCz0ABMVJGsWrCmrUnjG9guHeeqIfyIUNsGvYsdXHQXnfgQSIj7590oyiT2zCCsuwsJUc2cF2i9t5XaVmZl4uosgOY4Ng1V5ibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199227; c=relaxed/simple;
	bh=advwP7Tos0iJ9akCfY4Q0GxBD43sEPL00JWthZoSwGw=;
	h=Date:To:From:Subject:Message-Id; b=gbd87+bTBncdYvqTnpW4wDSBbt+qwanmEGMH9wAAPMM08EtJaOGpAFIFzTboKQ39BEaG4ad9IDyqzU8HF16gzRXIHg2YDJsYPsE6yd2IX2fl3fFAX1kjIrjwYdFP3CSEqWXbXUqaDKLNJxQgUgP2ND03E3aOaL1dbaj/0K4AefU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JOSHxGa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JOSHxGa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5441F000E9;
	Tue, 28 Jul 2026 00:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785199225;
	bh=OVE3TN6djSZuqxMO5+JH+snVGKKwkdtcVjpf+wARneM=;
	h=Date:To:From:Subject;
	b=JOSHxGa/mlCvL1GHhwK/lqvDDCL9xExi/kz6fcxxGbVATsl+kw6l+IM6dvDqQuJhw
	 q5MyAdznLcLT+GzcnBz6WNn5mezxIbUiSzM+9HRedHk+8bwGoEbclsP8YsJyhYVJ1t
	 3GJnNgZRpodDMsoA4prWQFFUSQKjGGiWdv/lCgLk=
Date: Mon, 27 Jul 2026 17:40:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch added to mm-hotfixes-unstable branch
Message-Id: <20260728004025.8F5441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: putback folios on invalid migrate nid
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: liyouhong <liyouhong@kylinos.cn>
Subject: mm/damon/ops-common: putback folios on invalid migrate nid
Date: Sun, 26 Jul 2026 09:48:15 +0800

damon_pa_migrate() and damos_va_migrate() isolate folios into a local list
and then call damon_migrate_pages().  When target_nid is invalid
(including the scheme default NUMA_NO_NODE / -1), damon_migrate_pages()
returns early without putting the folios back to the LRU.

Callers then discard the list head while those folios remain isolated with
an extra reference taken by folio_isolate_lru().  The pages stay off the
LRU for as long as the mapping exists (anon active+inactive counts drop
while RSS does not), and the leftover references can pin the pages after
the mapping is gone.

Put the folios back on the invalid-nid path so ignored migration requests
still return them to the LRU.

Link: https://lore.kernel.org/20260726014815.1280757-1-dayou5941@163.com
Fixes: 7e6c3130690a ("mm/damon/ops-common: ignore migration request to invalid nodes")
Assisted-by: Cursor:grok-4.5
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-putback-folios-on-invalid-migrate-nid
+++ a/mm/damon/ops-common.c
@@ -392,8 +392,15 @@ unsigned long damon_migrate_pages(struct
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY))
+			!node_state(target_nid, N_MEMORY)) {
+		while (!list_empty(folio_list)) {
+			struct folio *folio = lru_to_folio(folio_list);
+
+			list_del(&folio->lru);
+			folio_putback_lru(folio);
+		}
 		return nr_migrated;
+	}
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
_

Patches currently in -mm which might be from liyouhong@kylinos.cn are

mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch

