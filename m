Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DECA14A60F
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 00:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724529; cv=none; b=QFAMFK0s5pMBu/BRYcjGYaS0cjKC5VDJKk8S5wyiAUWlhSgkEjWeOYjFCCBt18jIw19mquNY/DkOFKLUvSE1ADYtUasUnjX/rIIh+Ww2/pfQz0pj98sKoxrnRd4EYQWKOhvZyjeoOJNQW1Cw3JUgZ4vx7rEQNh9nTkb67smmR2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724529; c=relaxed/simple;
	bh=z5qW5fI7WNuXRaNELkn96AsgMW85OG2J2XuqRY4+PG4=;
	h=Date:To:From:Subject:Message-Id; b=f9XL+LvPEJNnQmozTRdxUbpr8UJjfIB4ncKCOFYhEWu7q0JTMvBpZyQLGa18TFYT9titsePtYUE6F+9PiBfBRocaolM65YvFSWtS6EQK55DU2Doxj16sKFxeLnrDPoIvqDn7BYStudBSZRQJBrbKC4gvcIdg8BYyevbKRrPrgic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=owVJGUcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="owVJGUcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7DBC4CEF1;
	Sat, 13 Sep 2025 00:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757724528;
	bh=z5qW5fI7WNuXRaNELkn96AsgMW85OG2J2XuqRY4+PG4=;
	h=Date:To:From:Subject:From;
	b=owVJGUcjDJuThqN+gc364pHqfvNCLRi9TD+C4noob/56DjCkZgYjOl2FP6emhISXs
	 DjBrPRkPn6cc04SNtaMvv0ncIFsD/s1xyRBVFTdiRAt+bCM2XFv9ly3Hm5xzMhVu16
	 6gXccRiNhYyHTjl9p9guMhUf3JKuR0SD4Ean6n14=
Date: Fri, 12 Sep 2025 17:48:47 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64.patch added to mm-unstable branch
Message-Id: <20250913004848.3D7DBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix va_high_addr_switch.sh failure on x86_64
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: fix va_high_addr_switch.sh failure on x86_64
Date: Fri, 12 Sep 2025 09:37:11 +0800

The test will fail as below on x86_64 with cpu la57 support (will skip if
no la57 support).  Note, the test requries nr_hugepages to be set first.

  # running bash ./va_high_addr_switch.sh
  # -------------------------------------
  # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
  # mmap(addr_switch_hint - pagesize, (2 * pagesize)): 0x7f55b60f9000 - OK
  # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
  # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
  # mmap(NULL): 0x7f55b60f9000 - OK
  # mmap(low_addr): 0x40000000 - OK
  # mmap(high_addr): 0x1000000000000 - OK
  # mmap(high_addr) again: 0xffff55b6136000 - OK
  # mmap(high_addr, MAP_FIXED): 0x1000000000000 - OK
  # mmap(-1): 0xffff55b6134000 - OK
  # mmap(-1) again: 0xffff55b6132000 - OK
  # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
  # mmap(addr_switch_hint - pagesize, 2 * pagesize): 0x7f55b60f9000 - OK
  # mmap(addr_switch_hint - pagesize/2 , 2 * pagesize): 0x7f55b60f7000 - OK
  # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
  # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
  # mmap(NULL, MAP_HUGETLB): 0x7f55b5c00000 - OK
  # mmap(low_addr, MAP_HUGETLB): 0x40000000 - OK
  # mmap(high_addr, MAP_HUGETLB): 0x1000000000000 - OK
  # mmap(high_addr, MAP_HUGETLB) again: 0xffff55b5e00000 - OK
  # mmap(high_addr, MAP_FIXED | MAP_HUGETLB): 0x1000000000000 - OK
  # mmap(-1, MAP_HUGETLB): 0x7f55b5c00000 - OK
  # mmap(-1, MAP_HUGETLB) again: 0x7f55b5a00000 - OK
  # mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB): 0x800000000000 - FAILED
  # mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0x800000000000 - OK
  # [FAIL]

addr_switch_hint is defined as DFEFAULT_MAP_WINDOW in the failed test (for
x86_64, DFEFAULT_MAP_WINDOW is defined as (1UL<<47) - pagesize) in 64 bit.

Before commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
functions"), for x86_64 hugetlb_get_unmapped_area() is handled in arch
code arch/x86/mm/hugetlbpage.c and addr is checked with
map_address_hint_valid() after align with 'addr &= huge_page_mask(h)'
which is a round down way, and it will fail the check because the addr is
within the DEFAULT_MAP_WINDOW but (addr + len) is above the
DFEFAULT_MAP_WINDOW.  So it wil go through the
hugetlb_get_unmmaped_area_top_down() to find an area within the
DFEFAULT_MAP_WINDOW.

After commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
functions").  The addr hint for hugetlb_get_unmmaped_area() will be
rounded up and aligned to hugepage size with ALIGN() for all arches.  And
after the align, the addr will be above the default MAP_DEFAULT_WINDOW,
and the map_addresshint_valid() check will pass because both aligned addr
(addr0) and (addr + len) are above the DEFAULT_MAP_WINDOW, and the aligned
hint address (0x800000000000) is returned as an suitable gap is found
there, in arch_get_unmapped_area_topdown().

To still cover the case that addr is within the DEFAULT_MAP_WINDOW, and
addr + len is above the DFEFAULT_MAP_WINDOW, change to choose the last
hugepage aligned address within the DEFAULT_MAP_WINDOW as the hint addr,
and the addr + len (2 hugepages) will be one hugepage above the
DEFAULT_MAP_WINDOW.  An aligned address won't be affected by the page
round up or round down from kernel, so it's determistic.

Link: https://lkml.kernel.org/r/20250912013711.3002969-4-chuhu@redhat.com
Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -230,10 +230,10 @@ void testcases_init(void)
 			.msg = "mmap(-1, MAP_HUGETLB) again",
 		},
 		{
-			.addr = (void *)(addr_switch_hint - pagesize),
+			.addr = (void *)(addr_switch_hint - hugepagesize),
 			.size = 2 * hugepagesize,
 			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-			.msg = "mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB)",
+			.msg = "mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB)",
 			.low_addr_required = 1,
 			.keep_mapped = 1,
 		},
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-hugepages-cleanup-too-early.patch
selftests-mm-alloc-hugepages-in-va_high_addr_switch-test.patch
selftests-mm-fix-va_high_addr_switchsh-failure-on-x86_64.patch

