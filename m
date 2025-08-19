Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCC226D4CF
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646608; cv=none; b=ON+PsnyA5UrcPy0ktDzb/MNGi8A3+EsooBRlTUdKokBEk1EO0R/MVMOO3sY/xaHtHYfydI55F8x7WM+dSe6hgP+NDKjfYEHoGsrZx6r91ygnV4bPxYWh9do/U93RbDtINRFLPy8WaqER27XEPE/AZ6uFaI4+pXxDBDFAFx8GioI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646608; c=relaxed/simple;
	bh=CEyy1b+b8ur4wvZWy6/bt9eugnMzOlz6Hs2dz5tE7RI=;
	h=Date:To:From:Subject:Message-Id; b=pU8NRHk53EZxxyD6k81rRZz1GMRCnaMi9l1Kx/ma2XgnXcTwWpz/MUfaW1IycbocAXZSZl50qXabt5ARE0zwQW0giWVkbqctt7qoOK9bfMF5s6cdhCvKel8LjLG9F0PD7/cG3yiWPSN6c3gECu1DeU+4UBKBdx3Vq00piDUaTJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1y9X7XyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1y9X7XyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A64AC4CEF1;
	Tue, 19 Aug 2025 23:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646608;
	bh=CEyy1b+b8ur4wvZWy6/bt9eugnMzOlz6Hs2dz5tE7RI=;
	h=Date:To:From:Subject:From;
	b=1y9X7XyATqhGG94HcdHQtnF3b2TGUR7i24d73i2UA/XWQWOBJ24ms1KXNfQkMvjqD
	 YUrYGwvIFDX21/EueY73zJKeyR5Yr8fNfq33KOH32+MnUeL7+Y4/uMyw7lzvzVXkLF
	 Y54a+B/HXb18/dN6sKsPH6nKxv9Acr1Xe4+ZMcm8=
Date: Tue, 19 Aug 2025 16:36:48 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,axelrasmussen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mark-mglru-as-maintained.patch removed from -mm tree
Message-Id: <20250819233648.8A64AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mark MGLRU as maintained
has been removed from the -mm tree.  Its filename was
     maintainers-mark-mglru-as-maintained.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: MAINTAINERS: mark MGLRU as maintained
Date: Fri, 15 Aug 2025 14:59:14 -0700

The three folks being added here are actively working on MGLRU within
Google, so we can review patches for this feature and plan to contribute
some improvements / extensions to it on an ongoing basis.

With three of us we may have some hope filling Yu Zhao's shoes, since he
has moved on to other projects these days.

Link: https://lkml.kernel.org/r/20250815215914.3671925-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/MAINTAINERS~maintainers-mark-mglru-as-maintained
+++ a/MAINTAINERS
@@ -16058,6 +16058,23 @@ F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
+MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Axel Rasmussen <axelrasmussen@google.com>
+M:	Yuanchu Xie <yuanchu@google.com>
+R:	Wei Xu <weixugc@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/multigen_lru.rst
+F:	Documentation/mm/multigen_lru.rst
+F:	include/linux/mm_inline.h
+F:	include/linux/mmzone.h
+F:	mm/swap.c
+F:	mm/vmscan.c
+F:	mm/workingset.c
+
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from axelrasmussen@google.com are


