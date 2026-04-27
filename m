Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363AE31065B
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305606; cv=none; b=bKqmFgvMFgPlSA2I6TMaoIgnB3gVMPOs/vpOMiGtso5CVO0lfLujhOKOGXBxYf0/UFB/j/LOyVTAGtbx/2Am9sz7HQXHROLbnmYLZFRuOtY7sn7m9dE2hwMgdNGKCeq24L8ViF8SttPrrLbT22wRV2NbSaFMS/4PI54gJKuBiuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305606; c=relaxed/simple;
	bh=Y0ASp26XyQl0xL69gj1zRa455KahDFIWUAYcTI0OmFA=;
	h=Date:To:From:Subject:Message-Id; b=uoS3lKa2620eqKpkyMqlOsiIjTQYiAANdC2jqXftqSENy/kTQsTNdXSDseWrqcz1T7bzKH1mldkpd1Kp+55eyK8un53EAYiZbyokcWNVv8MSCys7D2RibjEZrCbbPWbWJBZMJb2G5gIbSMwD63sPgwysT77AeP7eYOcSa6Dvns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3y3qBn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3y3qBn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1185C19425;
	Mon, 27 Apr 2026 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777305605;
	bh=Y0ASp26XyQl0xL69gj1zRa455KahDFIWUAYcTI0OmFA=;
	h=Date:To:From:Subject:From;
	b=t3y3qBn1Ek6zvkJOtgC9NdBpNnrF68fHvncPzQRxwuip3Rn12ovhycCKR/yfMZQFU
	 Mxs0/15q0Zt+/kRACJDPeE0fGDRz5c5B96B9snZMSWWLaW6EavQDD20/RTXcoXrX7t
	 PgzYyBo5eXulHJoK18gGKXwq63wKX4k+N6jhaCn0=
Date: Mon, 27 Apr 2026 09:00:05 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch removed from -mm tree
Message-Id: <20260427160005.A1185C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: report MF_MSG_KERNEL for reserved pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: report MF_MSG_KERNEL for reserved pages
Date: Fri, 24 Apr 2026 05:23:59 -0700

Patch series "mm/memory-failure: add panic option for unrecoverable
pages", v5.

When the memory failure handler encounters an in-use kernel page that it
cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
currently logs the error as "Ignored" and continues operation.

This leaves corrupted data accessible to the kernel, which will inevitably
cause either silent data corruption or a delayed crash when the poisoned
memory is next accessed.

This is a common problem on large fleets.  We frequently observe multi-bit
ECC errors hitting kernel slab pages, where memory_failure() fails to
recover them and the system crashes later at an unrelated code path,
making root cause analysis unnecessarily difficult.

Here is one specific example from production on an arm64 server: a
multi-bit ECC error hit a dentry cache slab page, memory_failure() failed
to recover it (slab pages are not supported by the hwpoison recovery
mechanism), and 67 seconds later d_lookup() accessed the poisoned cache
line causing a synchronous external abort:

    [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
    [88690.498473] Memory failure: 0x40272d: unhandlable page.
    [88690.498619] Memory failure: 0x40272d: recovery action for
                   get hwpoison page: Ignored
    ...
    [88757.847126] Internal error: synchronous external abort:
                   0000000096000410 [#1] SMP
    [88758.061075] pc : d_lookup+0x5c/0x220

This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
(default 0) that, when enabled, panics immediately on unrecoverable memory
failures.  This provides a clean crash dump at the time of the error,
which is far more useful for diagnosis than a random crash later at an
unrelated code path.

This also categorizes reserved pages as MF_MSG_KERNEL, and panics on
unknown page types (MF_MSG_UNKNOWN).

Note that dynamically allocated kernel memory (SLAB/SLUB, vmalloc, kernel
stacks, page tables) shares the MF_MSG_GET_HWPOISON return path with
transient refcount races, so it is intentionally excluded from the panic
conditions to avoid false positives.


This patch (of 4):

When get_hwpoison_page() returns a negative value, distinguish reserved
pages from other failure cases by reporting MF_MSG_KERNEL instead of
MF_MSG_GET_HWPOISON.  Reserved pages belong to the kernel and should be
classified accordingly for proper handling.

Link: https://lore.kernel.org/20260424-ecc_panic-v5-0-a35f4b50425c@debian.org
Link: https://lore.kernel.org/20260424-ecc_panic-v5-1-a35f4b50425c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-report-mf_msg_kernel-for-reserved-pages
+++ a/mm/memory-failure.c
@@ -2432,7 +2432,16 @@ try_again:
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		/*
+		 * PageReserved is stable here: reserved pages have
+		 * PG_reserved set at boot or by drivers and are never
+		 * freed through the page allocator.
+		 */
+		if (PageReserved(p))
+			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		else
+			res = action_result(pfn, MF_MSG_GET_HWPOISON,
+					    MF_IGNORED);
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

