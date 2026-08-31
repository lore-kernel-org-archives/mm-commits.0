Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3773DF008
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219976; cv=none; b=iFgpvR+UR/gJQ7wXpsMP9hmONwpZjfM5ZQKrcqkSYVl5JtU1f/rXfLjGla+lsBQZ8CJzS2J5TmwbFi0t8znQjn7NIojVWJ3dCvWsfdx+Kvn6Q3MYCTXbuJVbU93UbzkQ5AGF0qItFeLmhDwJRNuPOZ9uWML6NvN/XSF/2k+8z4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219976; c=relaxed/simple;
	bh=6dFiv0ghd9jBFsTu6vgEl6mH3pbez4a9wuLQRTIKLy8=;
	h=Date:To:From:Subject:Message-Id; b=oGg12sjM/KjPyDhN/SQzUYFvcIj9ASUHh/hlzYHwjjLB3r8/BdXvaN3lFizRveCUmEqIXYZ0cN4uNRUbfejwR6XyGJVBWcOz2n3YNwaRc7qtAeuush5WGVIBKdMqQ5SglcwDJP5WUDG775Iaclkmsl/3RBjyeRZGoN6YPxGZy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lzJTL5F1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lzJTL5F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D557B1F000E9;
	Mon, 31 Aug 2026 23:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219973;
	bh=/o0u8Eh28cSY9TQhXq77evHSLDhO0lw2yWyAAkmDSMI=;
	h=Date:To:From:Subject;
	b=lzJTL5F1Y3MYSS0C69UxL8avjxuRFwNUcNEO3yJH8PwlhpIY+6CV/6J1xUmwyNDBj
	 zjWyfau3upPLUYXzQoaTuHh3HBXTzBGnaNU4ntomo6yVcKGFOwbFt+ZTkE0Ws7fmVh
	 vjU9y5pxVabk8W+6WYs27c0gsWeTs+yOibAaR8fU=
Date: Mon, 31 Aug 2026 16:46:13 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch added to mm-new branch
Message-Id: <20260831234613.D557B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use memcpy_nontemporal() in zone-device template copies
has been added to the -mm mm-new branch.  Its filename is
     mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch

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
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: use memcpy_nontemporal() in zone-device template copies
Date: Mon, 31 Aug 2026 19:16:37 +0800

The template fast path currently uses memcpy() for the actual struct page
copy.  Switch zone_device_page_init_from_template() to
memcpy_nontemporal().

ZONE_DEVICE memmap initialization is largely write-once: each struct page
is populated once, and most destination cachelines are not expected to be
reused immediately afterwards.  On x86, a regular cached memcpy() can
therefore incur write-allocate traffic by pulling destination cachelines
into the cache before writeback, and can populate the cache with data that
has little near-term reuse.  Using memcpy_nontemporal() lets this path
request nontemporal stores for that copy pattern, which can reduce cache
pollution and avoid part of the associated write-allocate overhead, while
architectures without a specialized backend still fall back to memcpy().

Do not add a KASAN/KMSAN-specific fallback around this call site.  As
Muchun pointed out, special KASAN handling for memcpy_flushcache() or
memcpy_nontemporal(), if needed, belongs in the low-level helper rather
than in this ZONE_DEVICE caller.

No separate drain is added here.  memcpy_nontemporal() is used only as the
copy primitive while memmap_init_zone_device() is still initializing the
struct page array.  The ordinary stores that follow in this path, such as
compound-page setup, are part of the same CPU's initialization sequence;
they are not used as a publication store that tells another CPU or device
to consume data written by the non-temporal copy.

Therefore this call site does not need a helper-level drain for
correctness.  Callers that use memcpy_nontemporal() as part of a
producer-consumer or device-visible handoff must add the required ordering
themselves.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.3-rc1):
  Average of rebinds for nd_pmem driver: 221.07 ms
  Average of rebinds for dax_pmem driver: 191.20 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 150.40 ms
  Average of rebinds for dax_pmem driver: 161.83 ms

This reduces the average memmap initialization time measured during rebind
by about 32.0% for nd_pmem and 15.4% for dax_pmem.

Link: https://lore.kernel.org/20260831111638.76012-7-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-use-memcpy_nontemporal-in-zone-device-template-copies
+++ a/mm/mm_init.c
@@ -1037,7 +1037,7 @@ static void zone_device_page_init_from_t
 	if (!is_highmem_idx(ZONE_DEVICE))
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
-	memcpy(page, template, sizeof(*page));
+	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
 /*
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

