Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794B91D278D
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727902537; cv=none; b=NA6Fl/r/bT25itTdre+qoXo1ePk7pA77DNTxm/nF0PPytazxk2JKEgxDqZl7tJOeOp3GfgFQvEO3cC5vHwJp2UB1kgDOpQkFw/Y5Fpo1Z12BOokoj8TY1pwdFZlQchzooBsqYr0R92AgZ68DgzaRRW87hbJrvExHOEvA8ClgsWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727902537; c=relaxed/simple;
	bh=lASL+tkudpurBdEkLdy+6w9JLFMqHWYqRP3dY8GLBRI=;
	h=Date:To:From:Subject:Message-Id; b=Cm/AXACn++APvg8xbIjT/LnXJm/Fi1Jdwx7SiqQ1g/bIJ8+YQ7vjcqupasT58B1z0/nT9gU3XLAcS0iC7v+a6y7Qk2xqdrDsFFHT9fSWtVatvSMbOlHKRio30gQ5tgJDi9nda75YfcilJL/kwEB6w6c9zT/NDe2c2C/nUvzc6mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYmg6NRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYmg6NRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77E5C4CEC2;
	Wed,  2 Oct 2024 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727902536;
	bh=lASL+tkudpurBdEkLdy+6w9JLFMqHWYqRP3dY8GLBRI=;
	h=Date:To:From:Subject:From;
	b=fYmg6NRp9ULgF0EeijJJGb0EzKSwMYUEjaCypkwCK3zA+5YNRqoYRlpO9ehQSNlX1
	 MWGbFg9NfEevEf0+duIuFqLsRwedHKDgnKxr8TfzEFQtj4VgQ/G+PZku+iZ6Ng92v1
	 YoSDz7pM9+ElaOTe5TzZOdeVFhg5rkgq8xkjKVFE=
Date: Wed, 02 Oct 2024 13:55:36 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pageanonnotksm.patch added to mm-unstable branch
Message-Id: <20241002205536.C77E5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add PageAnonNotKsm()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pageanonnotksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pageanonnotksm.patch

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
Subject: mm: add PageAnonNotKsm()
Date: Wed, 2 Oct 2024 16:25:30 +0100

Check that this anonymous page is really anonymous, not anonymous-or-KSM. 
This optimises the debug check, but its real purpose is to remove the last
two users of PageKsm().

Link: https://lkml.kernel.org/r/20241002152533.1350629-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-add-pageanonnotksm
+++ a/include/linux/page-flags.h
@@ -689,6 +689,13 @@ static __always_inline bool folio_test_a
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool PageAnonNotKsm(const struct page *page)
+{
+	unsigned long flags = (unsigned long)page_folio(page)->mapping;
+
+	return (flags & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_ANON;
+}
+
 static __always_inline bool PageAnon(const struct page *page)
 {
 	return folio_test_anon(page_folio(page));
@@ -1129,14 +1136,14 @@ static __always_inline int PageAnonExclu
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(!PageAnon(page) || PageKsm(page), page);
+	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
 static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(!PageAnon(page) || PageKsm(page), page);
+	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch

