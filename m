Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEBB1F1304
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 01:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791769605; cv=none; b=ct4A4qpSTd3hIY3QxvCRuCCyiyzMQjAIqwWyLkvFl9e1w3g51MQmq9IU34PIDlJVzB0DbwZiXP+rJ65GQDm+0IW7tbVMUZCbd2IZvAv6IXJsWU2PSmFRnwJPo3o3AE6IkSy2kgjluLc0UbLskPsENCXdfW/AEpRWaH7eHLhgIH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791769605; c=relaxed/simple;
	bh=/CoYBi9ljuGlWBN5lyoYYBtHgfo8+7iviQQ71qxRcho=;
	h=Date:To:From:Subject:Message-Id; b=Jw7HniAFQoib39i1eKlXmRT1FXYqyyb9uExipM9CFMWm9ct5XQaGVKxA330rgFylHsgeLnZhwWE6KMi2sbOX3YCxCpwp48hG8z/y2FPSb3bap33OWPBzBNep9HAcssAgziIuqYgWdyoGWr0rw224DToXfNp3Xun5kCh7NfKvOhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q0lQ8vtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q0lQ8vtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A370C1F0089B;
	Mon, 12 Oct 2026 01:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791769603;
	bh=FyCoWXm2N5iT7XFb46uUYtWNmKXuR5O4rQ16yRzGxf4=;
	h=Date:To:From:Subject;
	b=Q0lQ8vtt/b2BLoWQe7WUQIRG5WzqqH+6vKkT5CSn94AI4Qchm+jNlMWvwlC5zZfdU
	 FwAcvyGVZp1Xy/9mFIrqgEZytpcYGtfRIK0odsckooKSmplctMGRR3U9fMizQzRfjh
	 SQzLXK6RyscBw37JBJ+LlOrkUCUFACQhe/hFDP5s=
Date: Sun, 11 Oct 2026 18:46:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch removed from -mm tree
Message-Id: <20261012014643.A370C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-mm-describe-set_memory-and-set_direct_map-apis-fix
has been removed from the -mm tree.  Its filename was
     docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch

This patch was dropped because it was folded into docs-mm-describe-set_memory-and-set_direct_map-apis.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: docs-mm-describe-set_memory-and-set_direct_map-apis-fix
Date: Tue, 22 Sep 2026 12:42:55 +0300

fix phrasing, per Kevin

Link: https://lore.kernel.org/arJNn2QD_pY6e14R@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/kernel-page-tables.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/kernel-page-tables.rst~docs-mm-describe-set_memory-and-set_direct_map-apis-fix
+++ a/Documentation/mm/kernel-page-tables.rst
@@ -103,9 +103,9 @@ There are two families of functions for
 * `set_memory_*()` change permissions of an arbitrary kernel mapping. They
   take a kernel virtual address and the number of pages.
 
-* `set_direct_map_*()` change permissions of the direct mapping of the page
-  frame represented by a `struct page`. They take a `struct page` pointer and
-  the number of pages.
+* `set_direct_map_*()` change permissions of the direct mapping for the range
+  of page frames starting at the page represented by a `struct page`. They take
+  a `struct page` pointer and the number of pages.
 
 Architectures that implement `set_memory()` select `CONFIG_ARCH_HAS_SET_MEMORY`
 
_

Patches currently in -mm which might be from rppt@kernel.org are

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
arch-mm-promote-debug_wx-to-check_wx.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

