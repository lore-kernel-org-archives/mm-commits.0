Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832466;
	b=HhjDchZopezOASdM2bMOOYbAZYtKizfzm4E/gX5U7Ah38NdJidzxB9iAWCydfhvSAcAu
	 0lv13h7bEKadwVL8p/XaqNkMIvKLHm1gSFjkt+UMA0xugMgcSAimxiWFoLfHcXgOMJSpr
	 Lfe5Ym7RVVxEzSwhQjfoylYC6Aaq2z4FcE8utn08uqJtOpOyf86w0g/sgR4dGy87ziPSa
	 cgBP/bSZ1Din1Z5y7JVV+IxguBDW6P0s11uiKiPBBC46PEASJV29OTxrKFPalfFwaPAc3
	 FYHVOmm1rtd8Ypv7gihHDBV2dgKwoo3AP1C/Q/oF9MyoigpcZ2/y7r3Sm1X0uLeQWaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832466;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=v8VWpmw1REewQrK4m7O20CtxeZUyMb11EvGkbxDzTn0=;
	b=IZx/2vm7UDfUdUbm8gw8YKQFQKmjiYbnR8eNN+aN91YQxxXJP1fObLcIrZgdiH9rwlhU
	 UJsmpwTu+7j5sPVPrsfXPmd/XPDpkfkbfHwTjViKovDgHXvs4OACnbUor4Za24x4I/Pjt
	 KHNnNw5PTD5cJl/nLbGJ8+8x8EWMHO6ySdW1RDxEhDphpdTctgl7EYke4VOVti/ZqtehQ
	 Z51GV9QOiUcisnRQLu58EO8iTjMrnJoAYoNCtrTFfHbifj7ndErwl5S7+IW4ttCo825zK
	 cNWfHxHlpGc41BQj49J8XgRMVpP9w5xd0SydFaMdjVQ7jfyFp/EBqrR5hxrGsnF1BAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Tstqx/O1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D9D606A31A;
	Sat, 24 Oct 2026 09:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Tstqx/O1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDAE1F01825;
	Sat, 24 Oct 2026 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832466;
	bh=v8VWpmw1REewQrK4m7O20CtxeZUyMb11EvGkbxDzTn0=;
	h=Date:To:From:Subject;
	b=Tstqx/O1GwwtV9PYhmwJhyjE0PhX/Vl2WxT/JPO+H4KqkQ+qdiWVFBB61jP5xhrzM
	 eh2DzlULzUPeInYTpnpvBloiGXFR54lAKQRLMzc9MxHU6BkyIS1/I3DkOINuLuORl4
	 ALGEkVJauH/U5JeCAQScqduU2BU26xdmlzYmKofM=
Date: Sat, 24 Oct 2026 02:01:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,gourry@gourry.net,david@kernel.org,albinwyang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range.patch removed from -mm tree
Message-Id: <20261024090106.5DDAE1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <albinwyang@tencent.com>
Subject: mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
Date: Sat, 10 Oct 2026 10:40:42 +0800

During stress testing with stress-ng on a 256-CPU system, a softlockup was
observed when madvise(MADV_COLD) was called on a 31GB memory region backed
by transparent hugepages.  The region contains 15935 THP PMD entries, and
the softlockup was triggered after 14485 of them had been processed.

The THP branch of madvise_cold_or_pageout_pte_range() has no scheduling
point.  walk_pmd_range() invokes it once per 2MB PMD entry with no
cond_resched() anywhere in the loop.  Each iteration calls
pmdp_invalidate() which issues a synchronous TLB shootdown (dsb ish)
waiting for all CPUs to acknowledge.  This operation can be time-consuming
under heavy system load, causing the accumulated time across all PMD
entries to exceed the softlockup threshold (20s) and panic when
softlockup_panic=1.  On a CONFIG_PREEMPT_NONE=y kernel, there is no other
opportunity to reschedule during this entire traversal.

The regular PTE path already has an unconditional cond_resched() at the
function tail (introduced by commit 9c276cc65a58 ("mm: introduce
MADV_COLD") and commit 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") when
MADV_COLD and MADV_PAGEOUT were first introduced) and a conditional one
inside the loop (commit b2f557a21bc8 ("mm/madvise: add cond_resched() in
madvise_cold_or_pageout_pte_range()")).  The THP branch never received
equivalent treatment.

Fix by adding cond_resched() at the huge_unlock exit path after
spin_unlock(ptl) and reclaim_pages(), which is the single exit point for
all goto paths in the THP branch.

Crash log:
  watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
  ...
  Call trace:
  pmdp_invalidate+0x48/0x68
  madvise_cold_or_pageout_pte_range+0x84c/0xb00
  walk_pmd_range.isra.0+0x1ac/0x3b0
  walk_pud_range+0x120/0x190
  walk_pgd_range+0x170/0x1b8
  __walk_page_range+0x184/0x198
  walk_page_range_vma+0x94/0x128
  madvise_cold+0xd8/0x198
  madvise_vma_behavior+0x234/0x638
  madvise_walk_vmas.constprop.0+0xdc/0x210
  madvise_do_behavior+0xa8/0x328
  do_madvise+0xd8/0x140
  __arm64_sys_madvise+0x2c/0xe0

Link: https://lore.kernel.org/20261010024042.4070048-1-albin_yang@163.com
Signed-off-by: Wei Yang <albinwyang@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range
+++ a/mm/madvise.c
@@ -454,6 +454,7 @@ huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
 			reclaim_pages(&folio_list);
+		cond_resched();
 		return 0;
 	}
 
_

Patches currently in -mm which might be from albinwyang@tencent.com are


