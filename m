Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956213B42FE
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068129; cv=none; b=SfAgrYywXv3phJrt1ZDxb11K+/v5GdvMAaeuMyJNDXuc384yDFu1XZk+sJx0uU78g5iPOvNPYuwJNPFFCwwDce6JI9XHAhnL018pv9rblHjGaQJv9OXPaxzvaMdMFJmobAyUybw8iOt4DK+qreY/Oxr8v1kbKcPL+6/2P4bgILA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068129; c=relaxed/simple;
	bh=mfsgzdujhGSpWWkF3rteM4EXEdLD4TJumFVZxyl9R6s=;
	h=Date:To:From:Subject:Message-Id; b=Ab+iT+kR+3qxaHV5Apfaghl9TV+O29SNuLuTSYoXmo6dtC7cl9hX2Tj7xY/ofmWA1goikSblLtzFk71QjeughemQlOvQf4wDq1NqH/cc5K9bK9pU0bVnLFz04q5pt80XSzIUJOKNlUjXWA6/JwRmsQGJGH6RdY7j4prF+l++qWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U5fgqN3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U5fgqN3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4A31F00A3A;
	Fri,  7 Aug 2026 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068128;
	bh=g7HVsXLArNn60N8ilauIyKv516vN8FhTjyRI3wCGun8=;
	h=Date:To:From:Subject;
	b=U5fgqN3IgEP9sKA7v8yDBXHobjCwkAm8ZCXrroo/GZhlZSI8dVcY3ZgawbVPb8tON
	 5ifk6ADdzPakmWNnRi+N9wIfiAUXa/D4Srp/ZnY8ojpeU0x/qGVcWbdgD7qE5hjdMS
	 bg2JSbGKiL4yQu9XFuZN2s6OFeDBK/+NcZT2mN0k=
Date: Thu, 06 Aug 2026 19:02:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ljs@kernel.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-physical-memory-remove-deferred_split_queue.patch removed from -mm tree
Message-Id: <20260807020208.6C4A31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: Physical Memory: remove deferred_split_queue
has been removed from the -mm tree.  Its filename was
     docs-mm-physical-memory-remove-deferred_split_queue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: docs/mm: Physical Memory: remove deferred_split_queue
Date: Tue, 21 Jul 2026 19:19:19 +0800

deferred_split_queue was removed from struct pglist_data {} in commit
fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru").  Remove
its description in doc as well.

Link: https://lore.kernel.org/20260721111919.22923-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    3 ---
 1 file changed, 3 deletions(-)

--- a/Documentation/mm/physical_memory.rst~docs-mm-physical-memory-remove-deferred_split_queue
+++ a/Documentation/mm/physical_memory.rst
@@ -262,9 +262,6 @@ General
   PFN that needs to be initialized. Defined only when
   ``CONFIG_DEFERRED_STRUCT_PAGE_INIT`` is enabled
 
-``deferred_split_queue``
-  Per-node queue of huge pages that their split was deferred. Defined only when ``CONFIG_TRANSPARENT_HUGEPAGE`` is enabled.
-
 ``__lruvec``
   Per-node lruvec holding LRU lists and related parameters. Used only when
   memory cgroups are disabled. It should not be accessed directly, use
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are


