Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD49372B50
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622943; cv=none; b=D29r/xTUJH++kEE2jDOvNAzL2IDrwlh2/ouWgiqDGDr41LBQxi2BubAcgtf9WKjRmXCn2Thx5NBgSGtCzSC78DncSjNf82h/Nuxk4Vj3Lu3ZqzNsoBO3OpD/oPKT6GPUz9PaN4U3B5OrowaW2vglVpN9O/c8abHqsW44N+FKZ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622943; c=relaxed/simple;
	bh=Pqiu2UF+5A39bxT953KSNwuz37/ETDKB0cGb2+PCK5I=;
	h=Date:To:From:Subject:Message-Id; b=sGMO8Lsffa5ZkZ9KACm7HOTHe+dIMFJDRNxXIMuK12jE2fBYINJ5SsT0ogmw7HJXJ2em4WUvxx3+OOtlC8E6mZ6HHowNb3yoBIiJ/S2X9X1ggj6VhDjTEGdkNAyyvVId4PARwVoHPnV1UVi6sE9sZLwOBCmKB55jHy4xbkm+Byg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zLec5ElT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zLec5ElT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87DB1F00A3A;
	Tue, 25 Aug 2026 01:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622942;
	bh=h2E8gS7aPyVZk9OE95zRRNMhZg1Z+Bry+iCijCrg3CU=;
	h=Date:To:From:Subject;
	b=zLec5ElT1VJnwbv0nCabTBGShUEZNPW7eayCYozEmC/iNDON9rnDakdrtt8Jdf0PA
	 slUcDGYo6VjpiVtlUidj7heJbhxQxIPS03F9YPnvg30pJ5+OHB7CX9y7Z7izkQgzjz
	 Gd7XcASs8N9ZD8pMjevfOdh6gzT6UfYMN9zm0cpI=
Date: Mon, 24 Aug 2026 18:55:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-fix-outdated-radix-tree-in-page_migration.patch removed from -mm tree
Message-Id: <20260825015541.E87DB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm: fix outdated "radix tree" in page_migration
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-outdated-radix-tree-in-page_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


