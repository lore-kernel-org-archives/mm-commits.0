Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF53DABFF
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477816; cv=none; b=MBMPhQGiz7Q9Acb2mTxBQ6p88LHe2cXKys6lYjGuDwAhRaiJN8Ip6sz50Xe25h+sLNoPLguZJvIYgjOXIGkc8n6wPXgYs//08dwnvf4vksn9vFdocKIQXg00sLU1yxa1eiBcb2B6kyRVRaxEuIMT9/kZHh4x1mANt1q6HcszBnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477816; c=relaxed/simple;
	bh=BBC8+Kbtx6sdbqpBqpjyjc3N+1DAcoXYt+KujEuQb08=;
	h=Date:To:From:Subject:Message-Id; b=tSsqlT9Na+b4uKlkus4nVLMWURmWN0RCdN2wOeyiGxAf8/1d4toznB4S8oCPuIpNnQNlInpLa7QD1k/twuybPcT6LBAPgJ1QQT0E55WMf5UToQs8nSLAGhj22bvfkEA1gFDWJIJ+yIKUM0VCvLHiLitL70bIBiwCZa6tpwmhD1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ip3PUTke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ip3PUTke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24955C43390;
	Tue, 26 Mar 2024 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477816;
	bh=BBC8+Kbtx6sdbqpBqpjyjc3N+1DAcoXYt+KujEuQb08=;
	h=Date:To:From:Subject:From;
	b=Ip3PUTkeMqyatq7Rj3B68uems+J3s381sT4KmY9Nc4Wo2zOpnm+EC5fcjOWgIO+T/
	 1qY5N5K77c0R/ii0e5kLtTCPNzS/dLzOPshujEclDKTXWI37nPAMoj+a42EuxXWE5Q
	 z18HYE0y/7ykH1W1nfdPDqeztOwSNt/yZQBelZuk=
Date: Tue, 26 Mar 2024 11:30:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch added to mm-unstable branch
Message-Id: <20240326183016.24955C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make folio_test_idle and folio_test_young take a const argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make folio_test_idle and folio_test_young take a const argument
Date: Tue, 26 Mar 2024 17:10:26 +0000

If these functions are defined in page-flags.h, they already take a const
argument; make it true for these alternate definitions too.

Link: https://lkml.kernel.org/r/20240326171045.410737-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/page_idle.h~mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument
+++ a/include/linux/page_idle.h
@@ -13,7 +13,7 @@
  * If there is not enough space to store Idle and Young bits in page flags, use
  * page ext flags instead.
  */
-static inline bool folio_test_young(struct folio *folio)
+static inline bool folio_test_young(const struct folio *folio)
 {
 	struct page_ext *page_ext = page_ext_get(&folio->page);
 	bool page_young;
@@ -52,7 +52,7 @@ static inline bool folio_test_clear_youn
 	return page_young;
 }
 
-static inline bool folio_test_idle(struct folio *folio)
+static inline bool folio_test_idle(const struct folio *folio)
 {
 	struct page_ext *page_ext = page_ext_get(&folio->page);
 	bool page_idle;
@@ -60,7 +60,7 @@ static inline bool folio_test_idle(struc
 	if (unlikely(!page_ext))
 		return false;
 
-	page_idle =  test_bit(PAGE_EXT_IDLE, &page_ext->flags);
+	page_idle = test_bit(PAGE_EXT_IDLE, &page_ext->flags);
 	page_ext_put(page_ext);
 
 	return page_idle;
@@ -91,7 +91,7 @@ static inline void folio_clear_idle(stru
 
 #else /* !CONFIG_PAGE_IDLE_FLAG */
 
-static inline bool folio_test_young(struct folio *folio)
+static inline bool folio_test_young(const struct folio *folio)
 {
 	return false;
 }
@@ -105,7 +105,7 @@ static inline bool folio_test_clear_youn
 	return false;
 }
 
-static inline bool folio_test_idle(struct folio *folio)
+static inline bool folio_test_idle(const struct folio *folio)
 {
 	return false;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch

