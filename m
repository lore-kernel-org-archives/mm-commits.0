Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055E64D8BC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247731; cv=none; b=ScKOA4rVmsNPWp93CuZNZ7jZW9uCwP/32pAcM8JNVgYXG4Qm8fDhdHhK2E9GyKL/yehRP/k9e1znFg+WW4+2mOrEwghCD7nIa6yxHZ8zseidxowMxrMNrEMI8vHnHmooMRDh6IN7Ux05+oSsPJzbKt9A4PjQUWYyfqekcadaGUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247731; c=relaxed/simple;
	bh=tnntl5MUhrjyqtyEHPFRrVftY5KHt5BsB++Uqw41Udk=;
	h=Date:To:From:Subject:Message-Id; b=MC/nl6M2EeNKxC2bbutJfg4/hxYb2uVubh3iskjuHY2un4e5Ojo1XMdh6NZzP8L1CHBmwDASuIsnOXCPHea6afnwbgBkMJQSO2tcgyffrfGHxRSqlDGG9N1ZPJicS8JBLX/deR0Pas+AW0+0aLaHfggHcnt6vz1aNkwdBM4QJbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DMRbyYVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DMRbyYVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9FAC4CEC2;
	Mon,  2 Sep 2024 03:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247730;
	bh=tnntl5MUhrjyqtyEHPFRrVftY5KHt5BsB++Uqw41Udk=;
	h=Date:To:From:Subject:From;
	b=DMRbyYVqISFDS/18O7ujzub5iC7/3asfSMLbOfjEkmpJ8D1pGia5xyAKvim8rMzfw
	 a5AgVbryJ9/ZE9y+wMJRoC4ElUiMD9kfDdYIFblEiMANY/VBeEhnCQNUsLWreJexEy
	 T4peyHWycmzu82zW3kqMh4WTv7xxWCCNL8OhK0H8=
Date: Sun, 01 Sep 2024 20:28:50 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch removed from -mm tree
Message-Id: <20240902032850.CE9FAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clarify folio_likely_mapped_shared() documentation for KSM folios
has been removed from the -mm tree.  Its filename was
     mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: clarify folio_likely_mapped_shared() documentation for KSM folios
Date: Wed, 31 Jul 2024 18:07:58 +0200

For KSM folios, the function actually does what it is supposed to do: even
having multiple mappings inside the same MM is considered "sharing", as
there is no real relationship between these KSM page mappings -- in
contrast to mapping the same file range twice and having the same
pagecache page mapped twice.

Link: https://lkml.kernel.org/r/20240731160758.808925-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios
+++ a/include/linux/mm.h
@@ -2132,14 +2132,19 @@ static inline size_t folio_size(const st
  * MM ("mapped shared"), or if the folio is only mapped into a single MM
  * ("mapped exclusively").
  *
+ * For KSM folios, this function also returns "mapped shared" when a folio is
+ * mapped multiple times into the same MM, because the individual page mappings
+ * are independent.
+ *
  * As precise information is not easily available for all folios, this function
  * estimates the number of MMs ("sharers") that are currently mapping a folio
  * using the number of times the first page of the folio is currently mapped
  * into page tables.
  *
- * For small anonymous folios (except KSM folios) and anonymous hugetlb folios,
- * the return value will be exactly correct, because they can only be mapped
- * at most once into an MM, and they cannot be partially mapped.
+ * For small anonymous folios and anonymous hugetlb folios, the return
+ * value will be exactly correct: non-KSM folios can only be mapped at most once
+ * into an MM, and they cannot be partially mapped. KSM folios are
+ * considered shared even if mapped multiple times into the same MM.
  *
  * For other folios, the result can be fuzzy:
  *    #. For partially-mappable large folios (THP), the return value can wrongly
@@ -2148,9 +2153,6 @@ static inline size_t folio_size(const st
  *    #. For pagecache folios (including hugetlb), the return value can wrongly
  *       indicate "mapped shared" (false positive) when two VMAs in the same MM
  *       cover the same file range.
- *    #. For (small) KSM folios, the return value can wrongly indicate "mapped
- *       shared" (false positive), when the folio is mapped multiple times into
- *       the same MM.
  *
  * Further, this function only considers current page table mappings that
  * are tracked using the folio mapcount(s).
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

