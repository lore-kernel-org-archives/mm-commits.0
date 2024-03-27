Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68F112D747
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567397; cv=none; b=faWYsxeUEOBh6jPR2xUGumyMelWsbri5jUIMJXxoxysQA+D8neBPGtrX/u4lfYEzDSWbUKB+m86kRCPTG5sis1THUjqa5KdvrJ5o7IPz83aur0clVzUuQX3WCId78ZQDeByYAZoDOIdHByFzIB1lnThJk9xorvaqritMvnU97NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567397; c=relaxed/simple;
	bh=OwsFzqr+S1LhBhGwQHQgR0YZv647FKob050cIDqWM/I=;
	h=Date:To:From:Subject:Message-Id; b=ecHm6YR0OGMmyReR4FumAKIRmw9QeZBM3i92KL/W+ALt7tj7a1FbyYmLBeB5iBSlqyStmetYnlgwcj9PREQC4oy7wIqndYlil06bKTe405H25PGZbxvKzO1nQzcovzWIwtZ7rh4VvLT7Dzh3xGMFp6YmAbosrE7FRsw+ZjUnf3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OU4Hbyst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OU4Hbyst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B589C433C7;
	Wed, 27 Mar 2024 19:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567397;
	bh=OwsFzqr+S1LhBhGwQHQgR0YZv647FKob050cIDqWM/I=;
	h=Date:To:From:Subject:From;
	b=OU4Hbyst7oKkPd6Bu6pcYWIEjfjDBRkwTtbwm+2I/4RbPdhtI6vmJKFdv+f6jrXa+
	 IMcvCNvbghNzbpIAM6JuqUD4ldf0o/I3DouFSE1xDdrW9zK2mjRSWBWQdEm4dGdAhN
	 9V7Y0KGbm8qa8NFy62iWrQGQfPBhWNovcxlSwfao=
Date: Wed, 27 Mar 2024 12:23:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-__set_page_dirty_nobuffers.patch added to mm-unstable branch
Message-Id: <20240327192317.4B589C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove __set_page_dirty_nobuffers()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-__set_page_dirty_nobuffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-__set_page_dirty_nobuffers.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove __set_page_dirty_nobuffers()
Date: Wed, 27 Mar 2024 22:30:08 +0800

There are no more callers of __set_page_dirty_nobuffers(), remove it.

Link: https://lkml.kernel.org/r/20240327143008.3739435-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-__set_page_dirty_nobuffers
+++ a/include/linux/pagemap.h
@@ -1158,7 +1158,6 @@ static inline void folio_cancel_dirty(st
 bool folio_clear_dirty_for_io(struct folio *folio);
 bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
-int __set_page_dirty_nobuffers(struct page *page);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 #ifdef CONFIG_MIGRATION
--- a/mm/folio-compat.c~mm-remove-__set_page_dirty_nobuffers
+++ a/mm/folio-compat.c
@@ -58,12 +58,6 @@ bool set_page_dirty(struct page *page)
 }
 EXPORT_SYMBOL(set_page_dirty);
 
-int __set_page_dirty_nobuffers(struct page *page)
-{
-	return filemap_dirty_folio(page_mapping(page), page_folio(page));
-}
-EXPORT_SYMBOL(__set_page_dirty_nobuffers);
-
 bool clear_page_dirty_for_io(struct page *page)
 {
 	return folio_clear_dirty_for_io(page_folio(page));
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch

