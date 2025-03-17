Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947E216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188371; cv=none; b=KNPW0kaHjz2GncMbbHQdULiVgzdglo4weZcZZcwQER7VFPF/6ppzCtXwFXMHvZS4+Kvv1BlDvWDyQ/ChgIsD1sd+xpAJN39Kvb1eUVebKwxlqLVwmZM1t2GozIP3UuMyLgnLOGwVGYSRUsGpwAzXwEDi08XHU++4rZyvJmH32Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188371; c=relaxed/simple;
	bh=s3uP6aFilsFgjN7LubqfQ53d+yBVzsIc9+jVt6xyvOg=;
	h=Date:To:From:Subject:Message-Id; b=RsSgltV031ofdMEPfGV6yEa1rZiGu+vJ6AglklGVD87p31+WC/oxVfJGYCuNdM/7K3g4MFVRXpgzUgnxuEeWEIhrYMPpyUWaTfNNSI+TVux/DnsYvZjFi7TLetMp0FmR8azJijFBDN8XpqJuSlmGcOgpMrBVYU5kCgVhg87K+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eCygUa6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eCygUa6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04FFC4CEEC;
	Mon, 17 Mar 2025 05:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188371;
	bh=s3uP6aFilsFgjN7LubqfQ53d+yBVzsIc9+jVt6xyvOg=;
	h=Date:To:From:Subject:From;
	b=eCygUa6BA+DVm60rldud36ymWiD0hvMWU0DM3oNRXFFQ/cSyHweiYHw/6NtLKlqbk
	 NgiSRwu4UX78KjEEr7IKx7h5URVkv4uZ712AtUVqZySc+zOrfWL+hkpOwB0MK3BRJv
	 ShvJc8dI0AInxlgwcQV9hJq/0owW302zQTHfggvc=
Date: Sun, 16 Mar 2025 22:12:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-export-register_page_bootmem_memmap.patch removed from -mm tree
Message-Id: <20250317051250.E04FFC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: export register_page_bootmem_memmap
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-export-register_page_bootmem_memmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/bootmem_info: export register_page_bootmem_memmap
Date: Fri, 28 Feb 2025 18:29:10 +0000

If other mm code wants to use this function for early memmap inialization
(on the platforms that have it), it should be made available properly, not
just unconditionally in mm.h

Make this function available for such cases.

Link: https://lkml.kernel.org/r/20250228182928.2645936-10-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c    |    4 ++++
 include/linux/bootmem_info.h |    7 +++++++
 include/linux/mm.h           |    3 ---
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/init_64.c~mm-bootmem_info-export-register_page_bootmem_memmap
+++ a/arch/powerpc/mm/init_64.c
@@ -41,6 +41,7 @@
 #include <linux/libfdt.h>
 #include <linux/memremap.h>
 #include <linux/memory.h>
+#include <linux/bootmem_info.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -386,10 +387,13 @@ void __ref vmemmap_free(unsigned long st
 }
 
 #endif
+
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
 }
+#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
--- a/include/linux/bootmem_info.h~mm-bootmem_info-export-register_page_bootmem_memmap
+++ a/include/linux/bootmem_info.h
@@ -18,6 +18,8 @@ enum bootmem_type {
 
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
+void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
+				  unsigned long nr_pages);
 
 void get_page_bootmem(unsigned long info, struct page *page,
 		enum bootmem_type type);
@@ -58,6 +60,11 @@ static inline void register_page_bootmem
 {
 }
 
+static inline void register_page_bootmem_memmap(unsigned long section_nr,
+		struct page *map, unsigned long nr_pages)
+{
+}
+
 static inline void put_page_bootmem(struct page *page)
 {
 }
--- a/include/linux/mm.h~mm-bootmem_info-export-register_page_bootmem_memmap
+++ a/include/linux/mm.h
@@ -4018,9 +4018,6 @@ static inline bool vmemmap_can_optimize(
 }
 #endif
 
-void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
-				  unsigned long nr_pages);
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
_

Patches currently in -mm which might be from fvdl@google.com are


