Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED6D57C8D
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 23:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714691731; cv=none; b=n6kxwwHTIjLrQl6gr2/28ULHvswaKaheOot0AAUaC4Eicva8vzGDmymKjtowCb3Se16Qbdt1JJdWh0zGTLeheg+fDH2ld16jsZQGxto2QmlUlJ+u6cwyo50wxTEPdFgXNOET7iNFU36ltn+y8DG2lnLvv6CpWN0v+rfqkDkXqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714691731; c=relaxed/simple;
	bh=2ELxZHwrXuVzBPIHCu0Goq18797yxcxSAO0Y137O2SQ=;
	h=Date:To:From:Subject:Message-Id; b=VKSf3kwU15CmgDW1tOhidXXE3L6nUopLNUAa3LGX4BTgEux7fUBajU1PrxFv6P8Bxvf5nSpf4lOLWCF9jU2MVjLP3L8VKPPUP2IH4oUnI/np3Gp7sC42rIvXrt917PipLDZeWOrAS9tNhn3Vrbji/7cfqZEjpxRyUDG7x7uR27w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1sOrTavs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1sOrTavs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141CAC113CC;
	Thu,  2 May 2024 23:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714691731;
	bh=2ELxZHwrXuVzBPIHCu0Goq18797yxcxSAO0Y137O2SQ=;
	h=Date:To:From:Subject:From;
	b=1sOrTavsFUJaT7To8DQgf198UFpyo51m9YaC/U9Fqlb6eYFA9aJ2NyiDBlhG8sO6L
	 T81HTbJSql0pTazoInkFat1fL2VScAWsbV6V2BBo3VycdjW/8SANfRmCvYQb8lGFbN
	 8xTri2jbJfSJZzbNEhIQK6I0XlENtrkK6c4c+eFk=
Date: Thu, 02 May 2024 16:15:30 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch added to mm-unstable branch
Message-Id: <20240502231531.141CAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch

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
Subject: mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix
Date: Thu May  2 04:07:39 PM PDT 2024

update for folio conversions

Cc: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix
+++ a/mm/memory-failure.c
@@ -2170,16 +2170,15 @@ out:
  * election for MCE early killed will be honored.
  */
 static int kill_procs_now(struct page *p, unsigned long pfn, int flags,
-			struct page *hpage)
+			struct folio *folio)
 {
-	struct folio *folio = page_folio(hpage);
 	LIST_HEAD(tokill);
 	int res = -EHWPOISON;
 
 	/* deal with user pages only */
 	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
 		res = -EBUSY;
-	if (!(PageLRU(hpage) || PageHuge(p)))
+	if (!(folio_test_lru(folio) || PageHuge(p)))
 		res = -EBUSY;
 
 	if (res == -EHWPOISON) {
@@ -2324,7 +2323,7 @@ try_again:
 		if (try_to_split_thp_page(p) < 0) {
 			if (flags & MF_ACTION_REQUIRED) {
 				pr_err("%#lx: thp split failed\n", pfn);
-				res = kill_procs_now(p, pfn, flags, hpage);
+				res = kill_procs_now(p, pfn, flags, folio);
 				goto unlock_mutex;
 			}
 			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

