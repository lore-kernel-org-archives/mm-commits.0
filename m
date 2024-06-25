Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472774C61B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291714; cv=none; b=sCxB+6y6TF7eoBeMykj94Z6LZ7FN3wK4+r7BnwtOpgAyu/Tvy34CgslkmVbhYERF3zAzl/3fgKAC93N8FN6lIYYwNAt/H6pz971EZ/mv8hlg7pzb2KAt4X7/RUesU4pj4PQ0gLrBtKC0+zeeDaS2KhDjHnPR0GF0z9JYRQfNAco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291714; c=relaxed/simple;
	bh=FU5R1LRipUX+fNnI5GQUI75Z+WilH56BlNIJ/5mOkDQ=;
	h=Date:To:From:Subject:Message-Id; b=dkO6B0fn5jAXDLJpiBzA8ePQotbyj2SM8djgJFbQI6HcEkJQnSqQBZacmMXsNrxeGkr1p2XOEhEoUJ6USTECSFgdia28zbAfN4y4T300zlDSAO7vXd6exK4FCnZsrECUy17QQWdJtuDK2Xaoidph6RHeeSmtov/q9Id5rWqd/d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z1xCJEjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z1xCJEjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1852AC32789;
	Tue, 25 Jun 2024 05:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291714;
	bh=FU5R1LRipUX+fNnI5GQUI75Z+WilH56BlNIJ/5mOkDQ=;
	h=Date:To:From:Subject:From;
	b=z1xCJEjYHFZcZegn1Xyspnwb3j6zTGgWUV9L+4h/rlOiWCSWvZSvco0GzOHTHulpz
	 39HATNoplk6uchfNs/w6iuMe79IZCU0bVrYfXO/bL2VQYaCxnTD833DEUW9i+dE2+5
	 Eux4qrrrIRpaZAJaEjWjFZ1e2EaOUrXhPG46GSEo=
Date: Mon, 24 Jun 2024 22:01:53 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch removed from -mm tree
Message-Id: <20240625050154.1852AC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove obsolete comment in unpoison_memory()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove obsolete comment in unpoison_memory()
Date: Wed, 12 Jun 2024 15:18:31 +0800

Since commit 130d4df57390 ("mm/sl[au]b: rearrange struct slab fields to
allow larger rcu_head"), folio->_mapcount is not overloaded with SLAB. 
Update corresponding comment.

Link: https://lkml.kernel.org/r/20240612071835.157004-10-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-obsolete-comment-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2584,10 +2584,6 @@ int unpoison_memory(unsigned long pfn)
 	    folio_test_reserved(folio) || folio_test_offline(folio))
 		goto unlock_mutex;
 
-	/*
-	 * Note that folio->_mapcount is overloaded in SLAB, so the simple test
-	 * in folio_mapped() has to be done after folio_test_slab() is checked.
-	 */
 	if (folio_mapped(folio)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


