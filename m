Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FE22D4816;
	Mon, 10 Nov 2025 05:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752015; cv=none; b=jBQ1jycEr87AvVloFmIyRZyQCMBY6bcTxeiksUHGR+AbANsGfk6qA633RCIiua9hMR5Q3iOz+xlAc678tZl8SGjRFArbaAUwTKVWqDVj2TQrKZNbFOwJz0U8lKGeUb1ejnbNdCTiriPNnIrkRNyC0iCIAsR+GcD0DGQMQu84cLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752015; c=relaxed/simple;
	bh=a5kSMJk3zU3v7F9DGhSRSE+4JfsFCh7P8r0RxyPcP6w=;
	h=Date:To:From:Subject:Message-Id; b=B7gxLGGS+AHc86Ynfd70QsfgEsBBQ/F8rr5/ccFegSspB3TBbTWwAWAttP6wMJS97jXr1aoyj6YeRSMQoZvKFUEqdGDzNVypUVhVmnf3EUNM8M79ccD8Zp9K7qfx5BKwphrEQvomcxUlnThvpDPGtsLYo00FyGpk9vHLCVcHa/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w6pV8Lf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w6pV8Lf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00489C4CEF5;
	Mon, 10 Nov 2025 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752015;
	bh=a5kSMJk3zU3v7F9DGhSRSE+4JfsFCh7P8r0RxyPcP6w=;
	h=Date:To:From:Subject:From;
	b=w6pV8Lf7WpSuNh743TKUwBQO6uOT1eqtwZD8ZIJxMvVnLGTylZ+yM8LTwEHD+B9dc
	 ooNZHMbw+OP3YlH4G0RDwrwmihf8KzpJqgBZf/lqDuD1vsSsDxC+qXjweqCbne2/kA
	 Q7NAk8+TY5HOI6qos8W2NPTx6dvfK2IGfZBtmP7U=
Date: Sun, 09 Nov 2025 21:20:14 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,graf@amazon.com,dmatlack@google.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch removed from -mm tree
Message-Id: <20251110052015.00489C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: allocate metadata directly from the buddy allocator
has been removed from the -mm tree.  Its filename was
     liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: allocate metadata directly from the buddy allocator
Date: Mon, 20 Oct 2025 20:08:52 -0400

KHO allocates metadata for its preserved memory map using the slab
allocator via kzalloc().  This metadata is temporary and is used by the
next kernel during early boot to find preserved memory.

A problem arises when KFENCE is enabled.  kzalloc() calls can be randomly
intercepted by kfence_alloc(), which services the allocation from a
dedicated KFENCE memory pool.  This pool is allocated early in boot via
memblock.

When booting via KHO, the memblock allocator is restricted to a "scratch
area", forcing the KFENCE pool to be allocated within it.  This creates a
conflict, as the scratch area is expected to be ephemeral and
overwriteable by a subsequent kexec.  If KHO metadata is placed in this
KFENCE pool, it leads to memory corruption when the next kernel is loaded.

To fix this, modify KHO to allocate its metadata directly from the buddy
allocator instead of slab.

Link: https://lkml.kernel.org/r/20251021000852.2924827-4-pasha.tatashin@soleen.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Matlack <dmatlack@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |    3 +++
 kernel/kexec_handover.c |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/gfp.h~liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator
+++ a/include/linux/gfp.h
@@ -7,6 +7,7 @@
 #include <linux/mmzone.h>
 #include <linux/topology.h>
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 
 struct vm_area_struct;
@@ -463,4 +464,6 @@ static inline struct folio *folio_alloc_
 /* This should be paired with folio_put() rather than free_contig_range(). */
 #define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
 
+DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
+
 #endif /* __LINUX_GFP_H */
--- a/kernel/kexec_handover.c~liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator
+++ a/kernel/kexec_handover.c
@@ -142,7 +142,7 @@ static void *xa_load_or_alloc(struct xar
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	void *elm __free(free_page) = (void *)get_zeroed_page(GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
@@ -348,9 +348,9 @@ static_assert(sizeof(struct khoser_mem_c
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
+	struct khoser_mem_chunk *chunk __free(free_page) = NULL;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	chunk = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-kconfig-make-debugfs-optional.patch
liveupdate-kho-when-live-update-add-kho-image-during-kexec-load.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

