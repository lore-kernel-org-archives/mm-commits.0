Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3841F313546
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787269289; cv=none; b=Q9IxBi+wL6j5V30G9oicI0b1Pusn24ELLPlD0VXRmmvCuQSCeOhvx1/osSjQV4d4luiac/TBs8z5/kwJPPv4xzLHNSfPm/FI9cmiKc0GAccDmtP9jG5vberCsnRzQxFasW0PbQnliPTJpPM0VzcYB4BOxwFgde5LSKjXq1cYGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787269289; c=relaxed/simple;
	bh=aer4yqPKsDeeOSt/sMx3InYwL79zyVe5/lleTneXeuA=;
	h=Date:To:From:Subject:Message-Id; b=cjz3qHK9InJDfTnnH+NPMmLF1WGO62+5C3lvcK8aOhrUmZ6ui4nDe1zzjOUlxkL4Q1J1vT/5DK0jC2CD8Lqp5tF73X0/YJOqzIjRQAppZm+y5uwdUMc7IUYBDE9hPEvgaQwU/JU+wuplV6QZdHgkZgC4Ka1VvW7vHrgQTgK9boI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0JiWzml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0JiWzml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD151F000E9;
	Thu, 20 Aug 2026 23:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787269287;
	bh=qkQlHG3GgrOgfxO4ncIpKLg7omgoUd88PPGmHEbCp7E=;
	h=Date:To:From:Subject;
	b=I0JiWzmlC93YE5J+14+bEjNyMkskoW1xBkt9Mb0uJ5DcqYHVdWv5qJObPe/gjiUwW
	 EEANuJmvtNZNjuUtG7zNAHTQtGRPCr9WSx8L9CGxmoDuRmi8+m84btMQD0+imaovvs
	 Gpnm0flpfgSi1OJCe1eUnK0xPimJdx8OotDkuz2Q=
Date: Thu, 20 Aug 2026 16:41:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,mhocko@suse.com,longli@microsoft.com,kotaranov@microsoft.com,kbingham@kernel.org,jan.kiszka@siemens.com,hannes@cmpxchg.org,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-stale-max_order-references.patch added to mm-new branch
Message-Id: <20260820234127.9CD151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop stale MAX_ORDER references
has been added to the -mm mm-new branch.  Its filename is
     mm-drop-stale-max_order-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-stale-max_order-references.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/mana/mana.h |    4 ++--
 mm/page_alloc.c         |    2 +-
 scripts/gdb/linux/mm.py |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/net/mana/mana.h~mm-drop-stale-max_order-references
+++ a/include/net/mana/mana.h
@@ -40,8 +40,8 @@ enum TRI_STATE {
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

mm-drop-stale-max_order-references.patch

