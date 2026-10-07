Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20FD1D5146
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334125; cv=none; b=LSYM6ld9HAOTXrgAh+wY9bUXUwG3E//OvjF4q3Rj7KWQUmx29SegwBmmDwDnSjBWNJGkafSHhNzXTID45Ud86lUo8Y6HAtHQrP3v6OnWEjYUo3Hzy5cOgYngNe81QXRM/fGQMXvA7AngLl6J4ZtYQvfPVtcA6UU4MmXxXNwhtps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334125; c=relaxed/simple;
	bh=DFdjL+GyXn8uPwY2/Q+0z+mwC26Cq23DchYhKAHze6k=;
	h=Date:To:From:Subject:Message-Id; b=A8qoz4rTJieYfdnNveceBg2Z7v04Mcc0KtGyBHO1DgHkgBocWwm9mbknQUBd+Bdg9402SOWpOilt1QscOCox1++WaGSacSX1ZFRZpZqpnZmo2CJRV9c+Q8aJ8DGGT2zkPDldrXw+ag/+ol2Gbf7uV5JR5j1E2/0GvTIY21xKmeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lMt2Pput; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lMt2Pput"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961FF1F0089C;
	Wed,  7 Oct 2026 00:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334123;
	bh=WnNEXWJ9MR38ZhEPFA38u6Hn5D7EJTFXcoTwM/qGDQg=;
	h=Date:To:From:Subject;
	b=lMt2PputTuzLXQQcAyyb+n85PmTGRrJxA8NsJh8hAyQg8urBDuqLob+AEnV6OkWjY
	 R0kP2GL2vs/kyDaeCtlrbvrhkL4Qey4o6BpTdpZKuGLV/Siomi+p6xQOftCf4IbS2j
	 VDnDcn0SzzeJh8fSa5xY09j/zIi5TSAGlCnpAmdc=
Date: Tue, 06 Oct 2026 17:48:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,mhocko@suse.com,longli@microsoft.com,kotaranov@microsoft.com,kbingham@kernel.org,jan.kiszka@siemens.com,hannes@cmpxchg.org,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-stale-max_order-references.patch removed from -mm tree
Message-Id: <20261007004843.961FF1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop stale MAX_ORDER references
has been removed from the -mm tree.  Its filename was
     mm-drop-stale-max_order-references.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Xi <xiqi2@huawei.com>
Subject: mm: drop stale MAX_ORDER references
Date: Wed, 19 Aug 2026 16:20:52 +0800

The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old name:

  - two comments in include/net/mana/mana.h and mm/page_alloc.c;
  - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
    a local mirror of the kernel's MAX_ORDER define.

Rename the leftover instances to MAX_PAGE_ORDER so the tree is consistent.

No functional changes.

Link: https://lore.kernel.org/20260819082052.3338603-1-xiqi2@huawei.com
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Konstantin Taranov <kotaranov@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/net/mana/mana.h |    4 ++--
 mm/page_alloc.c         |    2 +-
 scripts/gdb/linux/mm.py |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/net/mana/mana.h~mm-drop-stale-max_order-references
+++ a/include/net/mana/mana.h
@@ -47,8 +47,8 @@ enum mana_priv_flag_bits {
 #define COMP_ENTRY_SIZE 64
 
 /* This Max value for RX buffers is derived from __alloc_page()'s max page
- * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
- * size beyond this value gets rejected by __alloc_page() call.
+ * allocation calculation. It allows maximum 2^MAX_PAGE_ORDER pages. RX
+ * buffer size beyond this value gets rejected by __alloc_page() call.
  */
 #define MAX_RX_BUFFERS_PER_QUEUE 8192
 #define DEF_RX_BUFFERS_PER_QUEUE 1024
--- a/mm/page_alloc.c~mm-drop-stale-max_order-references
+++ a/mm/page_alloc.c
@@ -7978,7 +7978,7 @@ static bool cond_accept_memory(struct zo
 	/*
 	 * Watermarks have not been initialized yet.
 	 *
-	 * Accepting one MAX_ORDER page to ensure progress.
+	 * Accepting one MAX_PAGE_ORDER page to ensure progress.
 	 */
 	if (!wmark)
 		return try_to_accept_memory_one(zone);
--- a/scripts/gdb/linux/mm.py~mm-drop-stale-max_order-references
+++ a/scripts/gdb/linux/mm.py
@@ -56,7 +56,7 @@ class x86_page_ops():
 
         self.MAX_PHYSMEM_BITS = 46
         self.SECTION_SIZE_BITS = 27
-        self.MAX_ORDER = 10
+        self.MAX_PAGE_ORDER = 10
 
         self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
@@ -233,11 +233,11 @@ class aarch64_page_ops():
         self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
 
         if str(constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER).isdigit():
-            self.MAX_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
+            self.MAX_PAGE_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
         else:
-            self.MAX_ORDER = 10
+            self.MAX_PAGE_ORDER = 10
 
-        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER)
+        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_PAGE_ORDER)
         self.PFN_SECTION_SHIFT = self.SECTION_SIZE_BITS - self.PAGE_SHIFT
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
         self.PAGES_PER_SECTION = 1 << self.PFN_SECTION_SHIFT
_

Patches currently in -mm which might be from xiqi2@huawei.com are


