Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB2D13C8FF
	for <mm-commits@vger.kernel.org>; Sun,  8 Jun 2025 22:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421906; cv=none; b=YtZJNvsmrTVDO4sVd2fxowT158juH3jU0mWhpZoHqe4Zg25k//q9cF7qyW6k90zphADbSsrcelIe8RNM71N8kwzvTShdO7Da+o2IYrirtqFjD/TkILi3PSt19k06H5WOnkNmfw8etTTM2b/SioXgHHct1o4rXJmRgA85xSZbsHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421906; c=relaxed/simple;
	bh=piyXXw85EWwUJSvdpweu8/KxEeNR1UNJ7rq6x2nDAmo=;
	h=Date:To:From:Subject:Message-Id; b=a8MHnnYtKNg4LhiUsQbv74aqlEKPfHrZHCIYe/SBXBIslGN4vHdNcaRKgyIWA1EvBncW3yjpn9gJ6may+SYHxS5WdSL0K+vGzkSJBC9kjYsyTBmPYp/0yRjse5/lhJYBKLuwktPxlJcoh08ad7MiOn7Pnab7xvKTijGK+uVx9is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wILmiLSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wILmiLSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336ABC4CEEE;
	Sun,  8 Jun 2025 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749421906;
	bh=piyXXw85EWwUJSvdpweu8/KxEeNR1UNJ7rq6x2nDAmo=;
	h=Date:To:From:Subject:From;
	b=wILmiLSRe0pKBex+rUo8z+pE9iQOnhzSboUC6IhV7V2zsyqqH4ZgcDlEzZ/2yYt6l
	 9BS6N36gginhxuI9NmaFaLivmXq7RzGBjKWLiQLgkLkHExbPeUwDscIilCjVMmpeMK
	 QjY4xJ13uVaV+zBtJScYD+F1Zh5WVA2O20gZ8cig=
Date: Sun, 08 Jun 2025 15:31:45 -0700
To: mm-commits@vger.kernel.org,wangfushuai@baidu.com,osalvador@suse.de,liam.howlett@oracle.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,broonie@kernel.org,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch removed from -mm tree
Message-Id: <20250608223146.336ABC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch

This patch was dropped because it was folded into fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix
Date: Sat Jun  7 02:32:35 PM PDT 2025

simplify ifdeffery

Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: wangfushuai <wangfushuai@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix
+++ a/fs/proc/task_mmu.c
@@ -991,10 +991,7 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		[ilog2(VM_UFFD_MINOR)]	= "ui",
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
-#ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
-		[ilog2(VM_SHADOW_STACK)] = "ss",
-#endif
-#if defined(CONFIG_ARM64_GCS)
+#if defined(CONFIG_ARCH_HAS_USER_SHADOW_STACK) || defined (CONFIG_ARM64_GCS)
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

