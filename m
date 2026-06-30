Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27E540D56E
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 00:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778768; cv=none; b=sRffGYq274NhWlET0QFSu44jC9avY+hDXag0WPVpTnsashS6ZPKte9sp0fQdALC6QgAu0J6uxPNi5BoaYvdRCvCr/zlm97JMcJrsBLwgyctJRyVeF1nO5Pbq9Yc9v8Hud88sP912VaMYGn14yHmc8DaEVMZ5QRlwiyTSydBxvI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778768; c=relaxed/simple;
	bh=2y4VPERd66C+5VM9MjaUo90cY2qySc0U4rE5k1HVqTw=;
	h=Date:To:From:Subject:Message-Id; b=DLrDFAKvVwFACew3dcLokpMEljFOABZ8KwmQAMcbLoiMYh4t85yofdkYGrAK2gCbU9wxuCav0918H8Tm+4AbFKq5+FhpXSl7aSwORN6lEknYOG5w1DpbODBS+gVKDa6F9xaVOqBd4OJ0aB4dKXYBK1OegxX5kDOMhH+U6wLIJ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BsDEAbCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BsDEAbCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEB91F000E9;
	Tue, 30 Jun 2026 00:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782778767;
	bh=UFI4xCf9BuUsCOlN6/fUSeSc3E5rCHxfZCrrs6I7lZY=;
	h=Date:To:From:Subject;
	b=BsDEAbCJS7hCsv7UgiyT+W4qX+rYL52zgQD0M7a5XeDxSN2fjv/1Nvpt+lCNcFLd+
	 74hS93dIScgbmfdYRIxh0F1qS2u7UHHDj8XzztEHmW88KjYfNmv+Hw19y2flwT4rYW
	 pc16UbHmLbkPhZ7w2E7eqlUOFhnFREzQY+ed4HKQ=
Date: Mon, 29 Jun 2026 17:19:26 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,lkp@intel.com,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,guoren@kernel.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + csky-implement-flush_cache_vmap-in-c.patch added to mm-unstable branch
Message-Id: <20260630001927.4DEB91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: csky: implement flush_cache_vmap() in C
has been added to the -mm mm-unstable branch.  Its filename is
     csky-implement-flush_cache_vmap-in-c.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/csky-implement-flush_cache_vmap-in-c.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: csky: implement flush_cache_vmap() in C
Date: Mon Jun 29 05:07:51 PM PDT 2026

To avoid getting an unused-var warning from

	unsigned long start = something;
	...
	flush_cache_vmap(start, ...);

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com/
Cc: Guo Ren <guoren@kernel.org>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
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

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

