Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E39749252E
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575609; cv=none; b=PPLlbTq69Lx6o0TIYzZG2c73LXEI/DtZL8dzX/eB0XheX9Pp1Yzb766hFZ65so+V+lThTYVnycgcSmwd/C6kdovCxTGYex5gxeYmMi5KQdYPR17YwXTzdP/hiQgkIJ1tfM1sLpItux1mFrJLelZ4f28oDQ5S0pSfldf+LPnBiCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575609; c=relaxed/simple;
	bh=I8F90jDnSt/RgoKijgMTxjqmFBGpEIeekS3Pd5QWRpY=;
	h=Date:To:From:Subject:Message-Id; b=iJNl8nSiGD+c/u3sj2SHR5rmj4NLhaClezzOC2rxLQRbMBy587VLTQ5BVbIxxA8dozKEvo7RCQtx9gblhPgtP6YGUcC7VGuYQVwFZOguoJp4KPj5Lr59raZxlJy2vv6mfH9HyYP/WowNGm1r6qLPlhfa+B6+llO9WvvowmVT7DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EpGjAeAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EpGjAeAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423DB1F000E9;
	Wed, 12 Aug 2026 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786575608;
	bh=i0u2QAnneC/Jz2vAsHr8OoKVbRKx7vQdrstYRIxhS6Q=;
	h=Date:To:From:Subject;
	b=EpGjAeAfm0aX0VOQkYXFmLZ0Hu+MwQrmojc/THFioXtWo2hKhy7gMQPk4WoYMi72C
	 OXrWC1TqQc9YiqgdsyuU12nOjf+B0iXrWGxonPoDeKB/5tJiwHZvRwTzu1a3nk7KNR
	 4tCbgTxWTVrM/qefbd9kmGr3EvC10s4HE4QBep4o=
Date: Wed, 12 Aug 2026 16:00:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-fix-outdated-radix-tree-in-page_migration.patch added to mm-unstable branch
Message-Id: <20260812230008.423DB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm: fix outdated "radix tree" in page_migration
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-fix-outdated-radix-tree-in-page_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-outdated-radix-tree-in-page_migration.patch

This patch will later appear in the mm-unstable branch at
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
From: Song Hu <husong@kylinos.cn>
Subject: Docs/mm: fix outdated "radix tree" in page_migration
Date: Wed, 12 Aug 2026 15:57:39 +0800

Steps 7 and 9 of the migration description still say "radix tree", unlike
steps 5 and 11 which already use "i_pages lock".  The page cache moved to
the XArray at mapping->i_pages long ago.  Use "page cache tree" for the
two remaining references.

Link: https://lore.kernel.org/20260812075739.325441-1-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_migration.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/page_migration.rst~docs-mm-fix-outdated-radix-tree-in-page_migration
+++ a/Documentation/mm/page_migration.rst
@@ -110,13 +110,13 @@ Steps:
 6. The refcount of the page is examined and we back out if references remain.
    Otherwise, we know that we are the only one referencing this page.
 
-7. The radix tree is checked and if it does not contain the pointer to this
-   page then we back out because someone else modified the radix tree.
+7. The page cache tree is checked and if it does not contain the pointer to this
+   page then we back out because someone else modified the page cache tree.
 
 8. The new page is prepped with some settings from the old page so that
    accesses to the new page will discover a page with the correct settings.
 
-9. The radix tree is changed to point to the new page.
+9. The page cache tree is changed to point to the new page.
 
 10. The reference count of the old page is dropped because the address space
     reference is gone. A reference to the new page is established because
_

Patches currently in -mm which might be from husong@kylinos.cn are

docs-mm-fix-outdated-radix-tree-in-page_migration.patch

