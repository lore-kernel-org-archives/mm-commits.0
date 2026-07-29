Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AEB38E12B
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298399; cv=none; b=TLd1EULTt9jK1yrtnDoHzlSD5SCztNX0N9OOz5yxudh9jQQhwG7wVbBafI/ZAKz6IwJOHT7mx5hMhe7lAcbNFKtGqGv+lR7huH6KT+cRZl4xBuMh+OEDAao8TRbGnDi+FaBvkH8N24zAw1s0O2jIfNUFIS7bd0O4qlFespcry/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298399; c=relaxed/simple;
	bh=NYLAptL0mrX40YG25EYfMpsJ2XoIiSIJI+GHFTrRVcE=;
	h=Date:To:From:Subject:Message-Id; b=OnPFUDKI+HH6l6pJMoHIUOzcfrwaHgXUR7XtuLayVhtabynA1YOnCDqjScc5il6Hpb/FUN1H2+VSh093WQWvLzAcEFB3xs3RRS0FJkiAmihz/jrDd5GkXdU3nKVdsUNJqmVuSRvsN0SnoOH9ZkoOw3FW1qiSjIf7yqRa1H0azts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCvoxibr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCvoxibr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A381F00A3A;
	Wed, 29 Jul 2026 04:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298398;
	bh=k1DV11LGwcxqto8qVvgonS+W86WcdO5z09bgMHKNi4Y=;
	h=Date:To:From:Subject;
	b=yCvoxibraFSuf1HUHpivkiI+NkPsMcxeMHbdlTGOEy6B+VfVE58LTe0wZvaF1TzgD
	 erNRA37AUq4b+B/hI9ogZFGAA4BZp2hsV/oHlt60mXOTw7+doBegeVnKt4ZKJQpdw/
	 eQEoumwQyyeJoppG1SiD70KjBkYVZKwgzzNLGkXE=
Date: Tue, 28 Jul 2026 21:13:17 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,lkp@intel.com,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,guoren@kernel.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-implement-flush_cache_vmap-in-c.patch removed from -mm tree
Message-Id: <20260729041318.54A381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: csky: implement flush_cache_vmap() in C
has been removed from the -mm tree.  Its filename was
     csky-implement-flush_cache_vmap-in-c.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: csky: implement flush_cache_vmap() in C
Date: Mon Jun 29 05:07:51 PM PDT 2026

To avoid getting an unused-var warning from

	unsigned long start = something;
	...
	flush_cache_vmap(start, ...);

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com/
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv1/inc/abi/cacheflush.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/csky/abiv1/inc/abi/cacheflush.h~csky-implement-flush_cache_vmap-in-c
+++ a/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -42,7 +42,12 @@ static inline void flush_anon_page(struc
  * Use cache_wbinv_all() here and need to be improved in future.
  */
 extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
-#define flush_cache_vmap(start, end)		cache_wbinv_all()
+
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+	cache_wbinv_all();
+}
+
 #define flush_cache_vmap_early(start, end)	do { } while (0)
 #define flush_cache_vunmap(start, end)		cache_wbinv_all()
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

