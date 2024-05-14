Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1751181CF9
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715724120; cv=none; b=qe6kBWoMCf0LOoBxa+TAJ3YwVXcHF3yyNvwk98K6E1HU9nlrhy3aDX1jPd+Dv3Bv1kCeXJTmTsqxp9nTvT6dXz3oy/J17cPWG6eBnYSC8m6Ee7ifWoJXYC1NmUBKWrYibh/ftA44QF9gCsfFC9UkZonIDwl5jh8HXvi42GrDQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715724120; c=relaxed/simple;
	bh=eRSDmAIJrZfL98G6937lSHgYk7i2uKo5sUt5uvmys3w=;
	h=Date:To:From:Subject:Message-Id; b=HdLbnKCwS606mwrKnPsCLR5Fnky0lmGPemDlJMh1s21kMt5TUIKB8p062IQoZcLEqQruOm3tLT/NeVULSUcZuTFRIW2gOpH3b3/rnKRTFGolKWBH+ftbAToLOsmkd0E/MH1DfPjOkr7UDPmIo+LDbtXfLI1roDaas1TrcKfRN5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/mb/p8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/mb/p8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E404C2BD10;
	Tue, 14 May 2024 22:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715724120;
	bh=eRSDmAIJrZfL98G6937lSHgYk7i2uKo5sUt5uvmys3w=;
	h=Date:To:From:Subject:From;
	b=x/mb/p8/leXdlTeio0lyUgF29mEwyupqEO1herxWNHmxPa7tjHTdzQwtn+FgVdgQD
	 rn+UH8pPTB6oQSBelDZthbC/0A/u/SbVuuRRD73gvUZw/t8uh9a89V4apHnOucv7re
	 MRlRsHF6CPADRNMkiK+aq/bhavbI7MYLU5kqTuXM=
Date: Tue, 14 May 2024 15:01:59 -0700
To: mm-commits@vger.kernel.org,xuyu@linux.alibaba.com,willy@infradead.org,shy828301@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch removed from -mm tree
Message-Id: <20240514220200.7E404C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix-fix
Date: Tue May 14 02:13:29 PM PDT 2024

s/clear/set/doh

Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-mark-huge_zero_page-reserved-fix-fix
+++ a/mm/huge_memory.c
@@ -212,7 +212,7 @@ retry:
 		folio_put(zero_folio);
 		goto retry;
 	}
-	__folio_clear_reserved(zero_folio);
+	__folio_set_reserved(zero_folio);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-add-version-into-proc-allocinfo-output-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

