Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523AA1E1041
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 18:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745259953; cv=none; b=Q3xB0UlEKqEs3pD/J4XnaWJLekZt8OuaTt0HQB223VWNF+yZZM/psTQvxB8KupBQhfe+yox1Zl7hRlhHhJ5hwtmBvZ61fV20ywdZvyISh7QyRS4JQx5OOVKN8ydMkW/rioC73umE4aD77m0ammI8+NeBv8BZ856RQ77vOPATR1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745259953; c=relaxed/simple;
	bh=MWi/xlvRYb8SR1Kgyjl2kxYfITWofMELu2S0VmPO0gw=;
	h=Date:To:From:Subject:Message-Id; b=uVYWLIRCd4r+grnIrSrHEFGi5NY40cGBjw0yFRxoiaDkrorWfXfb7mQjAXMbCJ/kSsVUHWmnjjbqqqaustHBJ4O3ujrmE1HUcsDrIILmx+y/NYhunOnwM9wvDgMAJ9k5VUt4VoRIixbV1UaEko6ZX0Kj7t5PebWo1duf76De1mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Evv/MuK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Evv/MuK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE12C4CEE4;
	Mon, 21 Apr 2025 18:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745259952;
	bh=MWi/xlvRYb8SR1Kgyjl2kxYfITWofMELu2S0VmPO0gw=;
	h=Date:To:From:Subject:From;
	b=Evv/MuK7zkd1heCN0eI/cTexJxlOTftJXbdm1bMfCdbG9GxbI0eu5nRGrouwSl4UM
	 lAROCxmHTnhXwltiTcSdP6diki8qC7g6RyLU6UNiJKNxSHZcraILyaRlTfTzKlLztJ
	 V7DoxLEO3KJlmULuCssMOA5CI5iDnbO8WmHRqsVg=
Date: Mon, 21 Apr 2025 11:25:51 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,lrh2000@pku.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mm_init-dont-iterate-pages-below-arch_pfn_offset.patch removed from -mm tree
Message-Id: <20250421182552.AEE12C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: don't iterate pages below ARCH_PFN_OFFSET
has been removed from the -mm tree.  Its filename was
     mm-mm_init-dont-iterate-pages-below-arch_pfn_offset.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ruihan Li <lrh2000@pku.edu.cn>
Subject: mm/mm_init: don't iterate pages below ARCH_PFN_OFFSET
Date: Sat, 19 Apr 2025 20:28:01 +0800

Currently, memmap_init initializes pfn_hole with 0 instead of
ARCH_PFN_OFFSET. Then init_unavailable_range will start iterating each
page from the page at address zero to the first available page, but it
won't do anything for pages below ARCH_PFN_OFFSET because pfn_valid
won't pass.

If ARCH_PFN_OFFSET is very large (e.g., something like 2^64-2GiB if the
kernel is used as a library and loaded at a very high address), the
pointless iteration for pages below ARCH_PFN_OFFSET will take a very
long time, and the kernel will look stuck at boot time.

This commit sets the initial value of pfn_hole to ARCH_PFN_OFFSET, which
avoids the problematic and useless iteration mentioned above.

This problem has existed since commit 907ec5fca3dc ("mm: zero remaining
unavailable struct pages").

Link: https://lkml.kernel.org/r/20250419122801.1752234-1-lrh2000@pku.edu.cn
Fixes: 907ec5fca3dc ("mm: zero remaining unavailable struct pages")
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-dont-iterate-pages-below-arch_pfn_offset
+++ a/mm/mm_init.c
@@ -975,6 +975,15 @@ static void __init memmap_init(void)
 	unsigned long hole_pfn = 0;
 	int i, j, zone_id = 0, nid;
 
+#ifdef CONFIG_FLATMEM
+	/*
+	 * Pages below ARCH_PFN_OFFSET are invalid as far as pfn_valid is
+	 * concerned, so don't waste time iterating on them when looking
+	 * for holes.
+	 */
+	hole_pfn = ARCH_PFN_OFFSET;
+#endif
+
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
 
_

Patches currently in -mm which might be from lrh2000@pku.edu.cn are


