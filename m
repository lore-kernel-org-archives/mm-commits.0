Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7803815DB
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 12:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777035103; cv=none; b=oxVYPhxqU9hNsxouE2qHQddrKTjNL3pH8VXbt7FBt1C9zySHXFxfFIye4AZhnkAvj70eZkgdFMaONlSSbxfwslbrDhF8DP8Fw60wOLYE7882odZNV+cOTzcc8XcKC59w8oyWcZc2SbxInBhA8Y+aTbpb9zKuu13vhpdUNgCGsrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777035103; c=relaxed/simple;
	bh=tA1tV+C9+i+d/F6lsXNMWM3KeEldsyREU5fIdw7S8X4=;
	h=Date:To:From:Subject:Message-Id; b=oSAXk7pFHpXRskrcl6RNMs9/6J/8qzsSQf4QQJjktyGEiXGYIylLButVfDGcIQDm8ZoIRHYSYmN9zZms9IIL5GObtWpD/RuKMoASp9E2oJoSCiMI0Eexaya7zEUPYvQVBy2003Zw1qtzUFqXGyjuttJ+4eFcqvj0r8YiucexO2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L6XvwsHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L6XvwsHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAF4C2BCB5;
	Fri, 24 Apr 2026 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777035103;
	bh=tA1tV+C9+i+d/F6lsXNMWM3KeEldsyREU5fIdw7S8X4=;
	h=Date:To:From:Subject:From;
	b=L6XvwsHdC2AqB14t0e74oNEK0/ymZ6BU7qvpURYiSua9d2NDmYSGJPJgkrqoC8ahk
	 5xpBYqc0r8tcP1Y0R3YegM9YZsUT/6o2LDCeK6xdxCJ0+7W1rmNw77ErIfnA50dFIV
	 VuHqtpK1Bscg7/yLi3ZpXXP4/5Vp/YyI/v9l5LrA=
Date: Fri, 24 Apr 2026 05:51:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch added to mm-new branch
Message-Id: <20260424125143.1EAF4C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: report MF_MSG_KERNEL for reserved pages
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch

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

kho-fix-error-handling-in-kho_add_subtree.patch
mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

