Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3DA3624B3
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298377; cv=none; b=OJKsE4DWM/dbHtu1G/ayPQy8octos7+6KKrRRf6bxJMAnkRq3VYG2QTCRX+1YDm+gfCZkl2lQjLwrZvL8WNQMal7doWjgcxTXqYzvrkYDsOV4PuQMJJ+EK8hfuO8Gc5qTZAtMnX7PhcMx7MRnbfw5C/k5MikD+/IFUWpk530VsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298377; c=relaxed/simple;
	bh=+debhxF7wv2AanXGC62/DDfsVuNl+HEJD3Lf+PzrTYs=;
	h=Date:To:From:Subject:Message-Id; b=jzr3r9OGbi6OpZ2Hi8jqjqRj7UrVNg9JCEhwtiUPO0d6XkwW0OJbm96R46VAIZXhREGnP/YGnSB8CwatW9eF6yBvXKewVMOVuoTw9e8E6jGnThv6cdAddvkHpqCB0Xn+iCFkJsyL0KNh8QA66sAls7Szuwrf8qXoE5KKB5U19f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YMihpyza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YMihpyza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DF21F00A3A;
	Wed, 29 Jul 2026 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298375;
	bh=qycokp2FV9K2zFgDERtSGQhSjOcBQWoHNyK+ByBnCKE=;
	h=Date:To:From:Subject;
	b=YMihpyzaeLAkJicYI/A1O79Wr+5ilA0ccwIKmNtk4moSYzYHV3THfpgccM1V2xpyH
	 ITiTB3tZ98SIWwVeeO59ww/m9Bv8mlFE9ZnbcF8soOU2GwXgd5ent/975Cz2MaGfPO
	 axMqPrL6LeiXaW+ayna5xs7U0crfmkU2HDT21JUs=
Date: Tue, 28 Jul 2026 21:12:55 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch removed from -mm tree
Message-Id: <20260729041255.B2DF21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: add thp_swap_allocator_test binary to .gitignore
has been removed from the -mm tree.  Its filename was
     tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: tools/mm: add thp_swap_allocator_test binary to .gitignore
Date: Wed, 24 Jun 2026 23:06:42 +0800

Tell git to ignore the generated binary for thp_swap_allocator_test.c.

Link: https://lore.kernel.org/20260624150642.19749-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/mm/.gitignore~tools-mm-add-thp_swap_allocator_test-binary-to-gitignore
+++ a/tools/mm/.gitignore
@@ -2,3 +2,4 @@
 slabinfo
 page-types
 page_owner_sort
+thp_swap_allocator_test
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

maintainers-add-abi-docs-and-selftests-to-zram-entry.patch
docs-mm-physical-memory-remove-deferred_split_queue.patch

