Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F491E5B86
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741298633; cv=none; b=NM6PzFYoYotTmbgqgEnjRM3ykp7i2UqFD0hFioaIhJ3eNfbilxCfNk2P7RL3tmR5skbbQldTpW2bJBDnQnEBiAV9uGpKmG/n/l5E3xAvmJUNy1oKfJ/rVU5lqhNhxljTH2utMcCbUAbz5+OSluZdJ3ZoEZSzpZfPJEmF2VX2hIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741298633; c=relaxed/simple;
	bh=xXlAc51f9oc+8PSc6+0BPgtqs5QEMNyAzd7cKsn/fBU=;
	h=Date:To:From:Subject:Message-Id; b=QaDTP1t5TgJ0uN1XXjcf892WsCR7WFlBic8xdNKpTsH6oJau9hiHDezjuBybEfWyKVa9ASfBReHdtttNHYyWGiXgAuIOWOq8d1EV+4dNV/4U1LeEREDqoUlfpvlbRricGAYzwcWajTnYtLdTqDSymwFGq0ADBbJBIMQ0nJZLNRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w439JqQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w439JqQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E566EC4CEE5;
	Thu,  6 Mar 2025 22:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741298633;
	bh=xXlAc51f9oc+8PSc6+0BPgtqs5QEMNyAzd7cKsn/fBU=;
	h=Date:To:From:Subject:From;
	b=w439JqQL2rjsoKx2oObCzNNcZfXzKIOiagz6RlZdpw6YHE4w/5u79d0TVa0IWnF7V
	 qZj2QYaGy+p+aNTENqk+mImBllWh/3eMxC1AH49V+hs2srLG3ayoxA9TJN8o0UInNj
	 0DntVrYjdG3FlPw06IPohz4sk540tqxOg6Wcs4+s=
Date: Thu, 06 Mar 2025 14:03:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-redundant-return-in-set_huge_zero_folio.patch added to mm-unstable branch
Message-Id: <20250306220352.E566EC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove redundant return in set_huge_zero_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-redundant-return-in-set_huge_zero_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-redundant-return-in-set_huge_zero_folio.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: remove redundant return in set_huge_zero_folio()
Date: Thu, 6 Mar 2025 20:13:15 +0530

It is the responsibility of the caller to check pmd_none(); in any case,
we are not achieving anything by returning since there is no return value
to tell the caller that we succeeded or not.  So remove this check.

Link: https://lkml.kernel.org/r/20250306144315.21907-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/huge_memory.c~mm-remove-redundant-return-in-set_huge_zero_folio
+++ a/mm/huge_memory.c
@@ -1309,8 +1309,6 @@ static void set_huge_zero_folio(pgtable_
 		struct folio *zero_folio)
 {
 	pmd_t entry;
-	if (!pmd_none(*pmd))
-		return;
 	entry = mk_pmd(&zero_folio->page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-remove-redundant-return-in-set_huge_zero_folio.patch

