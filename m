Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E3518C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628625; cv=none; b=lwee6gVh/4qzHUyLM+uLAUYRSg3BFmQ1XdVlJgGcaNgkHRE+Ckt93RZ2Iri7dJ6XlckERN5uaYtPTdlbHZP2YshS5ocjKTZBjP5GyCmiVfZLuI1iOrInphXMMyFDRFLjH2m5wKzyqCxtYJBbBrwaZaZF5LvLk7jdPt3+ZufSsoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628625; c=relaxed/simple;
	bh=ZQFCLRlr3qSvBm09bKionII/Bm1hD842KxRbivTsob8=;
	h=Date:To:From:Subject:Message-Id; b=fRD1SQ5WM9ZpQ7ZzB4nxJ3JtukuLXP/28/Qcuizl9UXFgzQqH2kwfksXeZ22UuWuyq0Z4poQMPF0cxkDJU/bXVLPawuXObqPYwqcLHFuFZzmdytsun5mYoEu700EMbdkpkn9iPiEMPES3C3HUV9cm9c7B7gpL5hz+l0NzetB4F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvfburjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvfburjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888E6C116B1;
	Sat, 29 Jun 2024 02:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628624;
	bh=ZQFCLRlr3qSvBm09bKionII/Bm1hD842KxRbivTsob8=;
	h=Date:To:From:Subject:From;
	b=WvfburjFpf6e5ffNrqJZnSONELN0/HyGiSXAekX6WVlHSIvpp1T6cesZ3k80T6am0
	 WZU9pLGLZeDRVXppDmvehyFg69UeMXRFtBk9xBcnRT7l/UU2Xz/J0WZ5JvWtVBnoxh
	 yCclmBcI+QVaRqyh4cuSvtUXS2jgEw8G1Pcv77JM=
Date: Fri, 28 Jun 2024 19:37:04 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-redefine-max_order-sanely.patch removed from -mm tree
Message-Id: <20240629023704.888E6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: redefine MAX_ORDER sanely
has been removed from the -mm tree.  Its filename was
     scripts-gdb-redefine-max_order-sanely.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: redefine MAX_ORDER sanely
Date: Wed, 19 Jun 2024 15:49:06 +0800

Patch series "Fix GDB command error".

This patchset fixes some GDB command errors.

1. Since memory layout of AARCH64 has been changed, we need to modify
   the layout in GDB scripts as well.

2. Fix pool_index naming of stackdepot.


This patch (of 6):

Change the definition of MAX_ORDER to be inclusive.

Link: https://lkml.kernel.org/r/20240619074911.100434-1-kuan-ying.lee@canonical.com
Link: https://lkml.kernel.org/r/20240619074911.100434-2-kuan-ying.lee@canonical.com
Fixes: 23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-redefine-max_order-sanely
+++ a/scripts/gdb/linux/mm.py
@@ -59,9 +59,9 @@ class aarch64_page_ops():
         if str(constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER).isdigit():
             self.MAX_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
         else:
-            self.MAX_ORDER = 11
+            self.MAX_ORDER = 10
 
-        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER - 1)
+        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER)
         self.PFN_SECTION_SHIFT = self.SECTION_SIZE_BITS - self.PAGE_SHIFT
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
         self.PAGES_PER_SECTION = 1 << self.PFN_SECTION_SHIFT
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are


