Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607150;
	b=csSVCrPsf/5kMrDTtJ9FoyT2bR6gd9xQ+391hHTtyZO8cldjg1bLsIw0xAOfanJfdIXC
	 cszKQHmmupOvZtxmnxCvIjyaIKkMd8nTgQe5zsjUaDmHeIAyPDOAXch8q84VGI2pgLSxg
	 ZBAiYGVU6+/aVfuIPhnUEkRbXYq+Seit29gb8wr29z6iA9YINz3yp6eEGWwNzm64yiXBI
	 TNoS2WbokqrKVsI9cGeJ1VzjBM9Ugry5DWIFwe5CSVy9RUdcpWeKZ1PvGI49HEGDbc7x4
	 DW28rNWe17bdeRF50w7XtiAGJai6TJu1fzDqByfgtaTuD9+ONAWjV3VkaF/RWSkJkUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607150;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AzFeFh7wYogs7Cm8iIjFMUYYFhyWs5Pv0D3GE5BCijQ=;
	b=vvUIWPKVwZ65TIJFwSU4pDvH4TWEvSm9qBqa9rN2xU2SyJWJGDtagNQ5r2lb4YvzMpiW
	 pegTcVYWeOvdMeci3bBY91053F3axV2dLmpe3UVBd2BAWjrp3Upspd4wS0S9v2X5LA5jT
	 Xab3XZTXqnTcwr0v1MdmK9iRoMobY30Nk5JgmDesSNGxZXe+rb68C/VOplljtq+jfVChs
	 BIY7CGJxzlajLu5mNS+3kanXMVrEUAdv2Wc3G6rL0WQwaQFkU03PvGcfiWPew1JD0qBKL
	 cJIt1fETy6WGEEqc8cvDKvIU1ipJGSWGjAVxdTQRYiZDP3cvqN3T1azW1hTTe9yRLcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d1EYuVrO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A08606A334;
	Fri, 13 Nov 2026 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d1EYuVrO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484791F000C4;
	Fri, 13 Nov 2026 21:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794607149;
	bh=AzFeFh7wYogs7Cm8iIjFMUYYFhyWs5Pv0D3GE5BCijQ=;
	h=Date:To:From:Subject;
	b=d1EYuVrORA7qLXL0Bz/npH0GPMjcdaRgso7ixrXaBLWteXTvQ+efXY5SzzlevlaoV
	 b1+S1kMYyjbXqH5XnMK4m6MV9jlIm8n8b8F1gXa5WeSixf3MMIFxHksBsNgf5rO88y
	 17U8p27bxTxeWs7bpZgJyZCtlgz15DivsEj8u0Uc=
Date: Fri, 13 Nov 2026 13:59:08 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tz2294@columbia.edu,
	surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,
	mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-zap-markers-from-guard-regions.patch added to mm-new branch
Message-Id: <20261113215909.484791F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/madvise: zap markers from guard regions
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-zap-markers-from-guard-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-zap-markers-from-guard-regions.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: zap markers from guard regions
Date: Fri, 13 Nov 2026 21:04:45 +0000

In order to establish guard regions, guard markers are installed in the
page tables of a mapped VMA.

However, problems arise when one tries to combine this with registering a
VMA for userfaultfd, as such operations may themselves need to install page
table markers such as uffd-wp.

When the installation is attempted the guard marker prevents these markers
being applied, which can lead to unexpected results (especially if the
guard regions are later removed.)

This is especially problematic because guard region installation causes the
regions to be zapped first, meaning that the removal of userfaultfd-tracked
ranges will not be logged in this case.

Additionally, the uffd-wp page table marker will be propagated regardless
for file-backed mappings as the zap being performed does not clear these
markers.

This is problematic, as it can cause repeated failure to install guard
markers resulting in an infinite loop.

Therefore, update guard region installation to invoke the zap with the
ZAP_FLAG_DROP_MARKER flag applied.

Both before and after this change, uffd remove events will not trigger on
guard region installation, nor will write protect state be propagated after
guard region removal.

This makes sense as conceptually, guard regions mark a part of a VMA as
effectively unmapped at the page table level, and removing the markers is
like mapping the VMA again, over which operation uffd markers would in any
case be lost.

A survey of open source users indicates nobody is relying on installing
guard regions in uffd-armed VMAs. Software including glibc, android,
tcmalloc and CRIU were checked.

This change means that any already established guard regions are removed on
zap. These will be overwritten with the newly installed guard markers on
success.

However, if this fails for some reason (fatal signal likely the only
reasonable cause), guard regions may remain removed, and concurrent faults
may succeed in the interim in the range.

Since the installation failing guarantees nothing about the range being
installed into, and since success overwrites with guard markers, this isn't
an issue.

Since MADV_DONTNEED does something similar, abstract the zapping to
zap_range() and call it from both places.

Link: https://lore.kernel.org/20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org
Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Tal Zussman <tz2294@columbia.edu>
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/mm/madvise.c~mm-madvise-zap-markers-from-guard-regions
+++ a/mm/madvise.c
@@ -850,6 +850,19 @@ static int madvise_free_single_vma(struc
 	return 0;
 }
 
+static void zap_range(struct madvise_behavior *madv_behavior,
+		      zap_flags_t flags)
+{
+	const struct madvise_behavior_range *range = &madv_behavior->range;
+	struct zap_details details = {
+		.reclaim_pt = true,
+		.zap_flags = flags,
+	};
+
+	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
+			      range->start, range->end - range->start, &details);
+}
+
 /*
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
@@ -872,13 +885,7 @@ static int madvise_free_single_vma(struc
 static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
 
 {
-	struct madvise_behavior_range *range = &madv_behavior->range;
-	struct zap_details details = {
-		.reclaim_pt = true,
-	};
-
-	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
-			      range->start, range->end - range->start, &details);
+	zap_range(madv_behavior, 0);
 	return 0;
 }
 
@@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct
 
 		/*
 		 * OK some of the range have non-guard pages mapped, zap
-		 * them. This leaves existing guard pages in place.
+		 * them. This also drops any PTE markers in the range,
+		 * including existing guard markers, which we reinstall on
+		 * the next attempt.
 		 */
-		zap_vma_range(vma, range->start, range->end - range->start);
+		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
 	}
 
 	/*
@@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
+	case MADV_GUARD_INSTALL:
 		return true;
 	default:
 		return false;
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-from-mm-core-reviewership.patch
maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch
maintainers-remove-myself-from-mm-rust-reviewerships.patch
credits-add-entry-for-thp-maintenance.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

