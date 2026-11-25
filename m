Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795572515;
	b=r3oal3rbnJ8+mGf7D+LjCQEA+uCgusbtbfhaCVjjisdRVb4bI9hHprzeH1PVGKOJ2e9N
	 ix8lOA6tw+dXinh9KAL9HLu5zf3DEH+eN9TBgxFcZQN87psGO/GWspZRbvMrLt6NZyR9L
	 rcieZLNupeb+RWT2w9lOa00c7tSa4Tje6qtgcfbtcFsbN7nvnRWgtAGeK1+H+IQ0CADTe
	 cxJcDalfXybHXAC7B1lJss0hpj+9cexMeTgSa2V465FIMI0v31opWYtLZz6HJ0snRmtWj
	 Qi1U0XakkqyQV2vNcwiq0MQnp4WPMWr7U85vIBvi1MTJLeHSsK+p3J+dN7mK8Ke1zAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795572515;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=clGi9PECA0RWLMu72USQq8GH3np4DpJBdzSWo6nl+dQ=;
	b=cqgkYxsYkhf7sh+3v4Kg6H9uUHOyWnIfd7Z8IBdy5WQLq41/yh9DJ+0E4uqAekWxtt4E
	 +nIdErGehgLjwHj7r/o6y8G7pqkcZo97dRJLedWFtqW/tBY/b4UIB84GP79IeiejvqTZP
	 tZQZF3uqy0hhSkw9TQAegy2AKNWzxyCKz4y2uZEKvWwC4ZydRjDLxAqVVywLKQYBP0AsV
	 vW2LtKXLshCiW2RT/gBZxTQj1MTK0mvPLzx5SFxAOTdK9A5h8JdXbEWYh/8D1qVCNir7i
	 QwMbVCDWtl44v4yCH+5PcWVVMuUv3dXnKmqQbGlFJFYWfMq2cZP/X0h2dzVLplx3J6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SJQQXZIf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3889606A321
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 02:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SJQQXZIf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934441F000CF;
	Wed, 25 Nov 2026 02:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795572514;
	bh=clGi9PECA0RWLMu72USQq8GH3np4DpJBdzSWo6nl+dQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=SJQQXZIfezpeVwwBhumoTRJbvzq+dZ6EKMGH3tMhYdJtTGYZHJ5hV+c1S2+ShmDe3
	 aDEwgcXEkIL1zmK/q31mE4vR1Pk3mfh6IF+hRme1vCN2SQ+Mfjn2FITZF6VcZgKMBu
	 m6LLqNovhG58/WA+LdJFn+CJwkgP4PpZCbEd3JWE=
Date: Tue, 24 Nov 2026 18:08:34 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tz2294@columbia.edu,
	surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,
	rdunlap@infradead.org,peterx@redhat.com,mhocko@suse.com,liam@infradead.org,
	kas@kernel.org,david@kernel.org,corbet@lwn.net,azpijr@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117210423.11598-1-azpijr@gmail.com>
References: <20261117210423.11598-1-azpijr@gmail.com>
Subject: + documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped.patch added to mm-new branch
Message-Id: <20261125020834.934441F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Documentation/userfaultfd: document RWP behavior when the PTE is dropped
has been added to the -mm mm-new branch.  Its filename is
     documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped.patch

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
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Documentation/userfaultfd: document RWP behavior when the PTE is dropped
Date: Tue, 17 Nov 2026 22:04:10 +0100

"Scope of protection" lists only the PTE drops requested by the user and
says the range has to be re-armed afterwards.  On shmem the kernel can
drop the PTE at any time (page reclaim and collapse are examples), and RWP
has no marker by design: the next access is a minor or a missing fault,
and the user is expected to register for those.  Document this, together
with the modes that sync and async tracking need.

The VMM example registers guest_mem with RWP and MISSING only, so a vCPU
write to an offset that is not mapped there can be lost during eviction. 
Add MINOR to the registration, describe how the handler treats faults on
offsets that are being evicted, and fix the step 1 comment, since minor
faults block even in async mode.

Link: https://patch.msgid.link/20261117210423.11598-1-azpijr@gmail.com
Link: https://lore.kernel.org/linux-mm/856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org/
Link: https://lore.kernel.org/linux-mm/avWnaR7VVEGa7yNp@thinkstation/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>

 Documentation/admin-guide/mm/userfaultfd.rst |   89 +++++++++++++----
 1 file changed, 71 insertions(+), 18 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -384,17 +384,54 @@ normal missing path (``do_anonymous_page
 the population itself, co-register the range with
 ``UFFDIO_REGISTER_MODE_MISSING``.
 
-Protection is preserved across page reclaim: a page swapped out while
-RWP-protected carries the marker on its swap entry, and swap-in restores
-the PROT_NONE state so the first access after swap-in still faults. The
-same applies to pages temporarily replaced by migration entries.
-
-Operations that drop the PTE entirely — ``MADV_DONTNEED`` on anonymous
-memory, hole-punch on shmem, truncation of a file mapping — also drop the
-RWP marker: the next access re-populates the range without protection.
+Protection is preserved while a page is temporarily replaced by a
+migration entry: the migration entry keeps the uffd bit, and the PROT_NONE
+state is restored when migration completes. This holds for anonymous,
+shmem and hugetlbfs memory alike.
+
+Protection of anonymous memory is also preserved across page reclaim: a
+page swapped out while RWP-protected keeps the uffd bit on its swap entry,
+and swap-in restores the PROT_NONE state so the first access after swap-in
+still faults.
+
+Any operation that drops the PTE also drops the RWP protection. On shmem
+the kernel can drop the PTE at any time while the page stays in the page
+cache or in swap; page reclaim and collapse into a huge page are examples.
 Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
-persistent RWP marker today. The user needs to re-arm the range with
-``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
+persistent RWP marker, and this is intentional: once the PTE is gone, the
+next access takes a page fault that userfaultfd can deliver, and that fault
+is the notification. Which fault it is depends on what happened to the
+page:
+
+- The page is still in the page cache or in swap: the access is a minor
+  fault, delivered if the range is co-registered with
+  ``UFFDIO_REGISTER_MODE_MINOR``.
+
+- The page is gone: the access is a missing fault, delivered if the range
+  is co-registered with ``UFFDIO_REGISTER_MODE_MISSING``.
+
+WP cannot use the same scheme — a minor fault would trap reads as well as
+writes — which is why it needs a marker.
+
+Without the matching mode the page is mapped back silently and without
+protection, so what to co-register depends on the tracking mode:
+
+- Sync mode: the access would be lost. Co-register shmem and hugetlbfs
+  ranges with ``UFFDIO_REGISTER_MODE_MINOR`` (and
+  ``UFFDIO_REGISTER_MODE_MISSING`` if the file can have holes), and
+  anonymous ranges, where minor faults are not available, with
+  ``UFFDIO_REGISTER_MODE_MISSING``.
+
+- Async mode: neither is needed. A page faulted back in is mapped without
+  the uffd bit, so ``PAGEMAP_SCAN`` reports it as accessed.
+
+The registration does not follow the tracking mode: a context that
+switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below
+does, needs ``UFFDIO_REGISTER_MODE_MINOR`` while it is in sync mode.
+Minor faults are always synchronous, so keeping it registered makes
+them block in async mode as well. Re-registering the range to add
+``UFFDIO_REGISTER_MODE_MINOR`` before switching to sync, and to drop
+it after switching back, avoids that.
 
 **Fault Handling:**
 
@@ -484,17 +521,24 @@ never traps on its own ::
         .features = UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
     };
     ioctl(uffd, UFFDIO_API, &api);
-    if (!(api.features & UFFD_FEATURE_RWP))
+    if (!(api.features & UFFD_FEATURE_RWP)) {
         /* RWP unavailable on this kernel/arch -- fall back. */
+    }
+    /*
+     * MINOR: an offset in the page cache but not mapped in guest_mem
+     * would be mapped back without a fault, and a vCPU write between
+     * the pwrite() and the hole punch in step 4 would be lost.
+     */
     ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
         .range = { guest_mem, guest_size },
         .mode = UFFDIO_REGISTER_MODE_RWP |
-                UFFDIO_REGISTER_MODE_MISSING,
+                UFFDIO_REGISTER_MODE_MISSING |
+                UFFDIO_REGISTER_MODE_MINOR,
     });
 
     /* Tracking loop */
     while (vm_running) {
-        /* 1. Detection phase (async -- no vCPU stalls) */
+        /* 1. Detection phase (RWP faults async, minor faults still block) */
         ioctl(uffd, UFFDIO_RWPROTECT, &(struct uffdio_rwprotect){
             .range = full_range,
             .mode = UFFDIO_RWPROTECT_MODE_RWP });
@@ -544,11 +588,20 @@ never traps on its own ::
                   .enable = UFFD_FEATURE_RWP_ASYNC });
     }
 
-During step 4, a vCPU that accesses a ``guest_mem`` offset being evicted
-blocks with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault while the eviction is in
-progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
-fires, the vCPU retries the access, faults as ``MISSING``, and the
-handler resolves it with ``UFFDIO_COPY`` from storage.
+During step 4, a vCPU that accesses an offset this pass will evict blocks
+with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault, or with a
+``UFFD_PAGEFAULT_FLAG_MINOR`` fault if the offset is not mapped in
+``guest_mem``. The handler leaves the fault pending until that offset has
+been punched out, even if step 4 has not reached it yet: resolving it
+earlier would let a vCPU write land between the ``pwrite()`` and the hole
+punch, and the write would be lost. After ``fallocate()`` punches the page
+out and ``UFFDIO_WAKE`` fires, the vCPU retries the access, faults as
+``MISSING``, and the handler resolves it with ``UFFDIO_COPY`` from storage.
+
+Faults on any other offset are resolved right away: RWP faults with
+``UFFDIO_RWPROTECT``, minor faults with ``UFFDIO_CONTINUE``. A page mapped
+by ``UFFDIO_CONTINUE`` does not carry the uffd bit, so the next scan reports
+it as accessed.
 
 This workflow targets shmem and hugetlbfs (both support a private
 ``io_mem`` mapping over the same fd). Anonymous-memory backings need a
_

Patches currently in -mm which might be from azpijr@gmail.com are

mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch
selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch
documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped.patch

