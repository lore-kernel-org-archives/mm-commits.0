Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373D479CF
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746685913; cv=none; b=kMuMpTbNwQOiSndV6oFjeDYTv9z+pVWFUQnlzXzCQ+SQ3nkMXJcgMzOWPRfShuA6OF20OHXN9t4x9IsTqDnmj0Bfy7x6kI4XR2WCqc9GstQEwfAtQIdyasGdxWQraZLBgvmtqwlNQdl8jLeHv1UTF1BF6WV/y3uhBaTSwaUgtvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746685913; c=relaxed/simple;
	bh=owdnzSnQuKRqeZsQkGVA9K42aIFJ5YbG3zWiKLQbMIQ=;
	h=Date:To:From:Subject:Message-Id; b=TYBMBL3drYZSFh9zzCtyBZ/4wBbRgxvPI1Oa8RuWTGbybecx1hhj4ZqF6vmEp4EixEDCerAp5eXdqcmk3RSVfQ7l8hsX0+YKzN0YZPq4uuOTssWMhv7hDo6TcDZbzfMNF/3KVIJ5sDwTAwbzO/9ZjAi5VMnul2+tPXi+qML8xa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dXMQmHuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dXMQmHuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C75C4CEEB;
	Thu,  8 May 2025 06:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746685912;
	bh=owdnzSnQuKRqeZsQkGVA9K42aIFJ5YbG3zWiKLQbMIQ=;
	h=Date:To:From:Subject:From;
	b=dXMQmHuw6FVzoyBK7pGNbLTTcJdfiqT22Btyu9tYNRQ6Dm26Vwd+G1KIP+sfGG+EZ
	 NGGcaqOoMCNpXFtlK82OBb9t5wOWJi6gThy6XAOBXkFVAGQrMnSb0kDK7OC7EoaAY1
	 IulIe+oKCM3tEKE7vdc/CWg4QfOyN2hsAOr2iXS0=
Date: Wed, 07 May 2025 23:31:52 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,vincenzo.frascino@arm.com,torvalds@linux-foundation.org,tglx@linutronix.de,ryabinin.a.a@gmail.com,mingo@redhat.com,linux@roeck-us.net,hpa@zytor.com,glider@google.com,dvyukov@google.com,bp@alien8.de,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-disable-image-size-check-for-test-builds-fix.patch removed from -mm tree
Message-Id: <20250508063152.96C75C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86-disable-image-size-check-for-test-builds-fix
has been removed from the -mm tree.  Its filename was
     x86-disable-image-size-check-for-test-builds-fix.patch

This patch was dropped because it was folded into x86-disable-image-size-check-for-test-builds.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-disable-image-size-check-for-test-builds-fix
Date: Wed Apr 16 06:11:50 PM PDT 2025

add comment, fix nearby typo (sink->sync)

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds-fix
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -466,9 +466,16 @@ SECTIONS
 }
 
 /*
- * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+ * COMPILE_TEST kernels can be large - CONFIG_KASAN, for example, can cause
+ * this.  Let's assume that nobody will be running a COMPILE_TEST kernel and
+ * let's assert that fuller build coverage is more valuable than being able to
+ * run a COMPILE_TEST kernel.
  */
 #ifndef CONFIG_COMPILE_TEST
+/*
+/*
+ * The ASSERT() sync to . is intentional, for binutils 2.14 compatibility:
+ */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-config_page_block_order-to-select-page-block-order-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

