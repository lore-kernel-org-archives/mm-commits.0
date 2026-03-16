Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C7E315D46
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677238; cv=none; b=StxCTOr9RtBO9SlGrlA25obt/+GTxeymlnDx9Iobog1zVsQzxlFz1xAIF1+By0sc2PcUFYK2ocCyrMm8PbG5xqebFkF1Qt8xN7q5k3pV+ykz4oNQR9jdql7On/zxHO8aX7Sjr6pbgmccB3SsKl3gS4z/v7U+hrMxyVmpJrrXhIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677238; c=relaxed/simple;
	bh=WTf6Qh9y3V64E3epKkvK6XCDO6hXo2ZtYS2nSFqnx2U=;
	h=Date:To:From:Subject:Message-Id; b=oqE5PkqCUm9NXHdU6a4inXojZnJqGUR7k2Gz1VycI54JjREhcF7KpIdMqgF+/KYycSHudNUVC+Cv7Ol3iQ70FpxtWgYHtfTqs0sOnmM08PujjrgF9C1n8VRwlkuu0Jazj1K1/Uv7RfcYcbrHztZTlhxWfBHb45gQ3eVzEFOMm3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XcEaSQVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XcEaSQVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F4CC19421;
	Mon, 16 Mar 2026 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773677238;
	bh=WTf6Qh9y3V64E3epKkvK6XCDO6hXo2ZtYS2nSFqnx2U=;
	h=Date:To:From:Subject:From;
	b=XcEaSQVJLITjfYmvQtwVlQoAznDfXHCJcL2LhXl2gVcAlmWog2+QfLBeysD1Jwrk6
	 YJusOEnwGFTf0aFhzGzX42D1LU7t3SVgBnYIsGvTpdo3Tb4FJETp2h3vLQvbP0g4W8
	 wqsO6LahcVZ2h70v/JocuGDH1KKqvEUfc8irUvKc=
Date: Mon, 16 Mar 2026 09:07:17 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-missing-kunmap_local.patch added to mm-hotfixes-unstable branch
Message-Id: <20260316160718.24F4CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: add missing kunmap_local()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-add-missing-kunmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-missing-kunmap_local.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/zswap: add missing kunmap_local()
Date: Mon, 16 Mar 2026 14:01:22 +0000

Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
data for uncompressed pages.

In doing so, it mapped kernel memory locally for 32-bit kernels using
kmap_local_folio(), however it never unmapped this memory.

This resulted in the linked syzbot report where a BUG_ON() is triggered
due to leaking the kmap slot.

This patch fixes the issue by explicitly unmapping the established kmap.

Link: https://lkml.kernel.org/r/20260316140122.339697-1-ljs@kernel.org
Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-add-missing-kunmap_local
+++ a/mm/zswap.c
@@ -942,9 +942,14 @@ static bool zswap_decompress(struct zswa
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
+		void *dst;
+
 		WARN_ON_ONCE(input->length != PAGE_SIZE);
-		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
+
+		dst = kmap_local_folio(folio, 0);
+		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
+		kunmap_local(dst);
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-zswap-add-missing-kunmap_local.patch
mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-correctly-drop-reference-count-on-mapping-failure.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch

