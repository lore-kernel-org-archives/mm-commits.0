Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C374B35957
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749332011; cv=none; b=Z+OaQg5ypSipddzB0kMP3f6iDj4zPbB+QB6FpGNtgBIppxQelUnRkSaZfpks2xd3Iwc1+UOHAgvXuzU+weySjDdhIz7yG8taQfQwUjXyZXMje71K+Sfi7MqTHNnXnw47Enlfh2fVmQ5TuQv5ICp/+yvBoD30YcuStYGYRBt9C6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749332011; c=relaxed/simple;
	bh=QsRUyl6lOEWl4x7Z2rNCni/ukMM9cTNwiyTVpffoC8o=;
	h=Date:To:From:Subject:Message-Id; b=tCcVyt5MKmrC7iYwu59u7YvXow0POz6O2b5fozYWLSAEkFUBWIBY++uJP8uWdVQWm6Y2tEUdYVGMCwEOpt/1f0gGYYJGHfkOqeSj6h1L5+SC1RQENG6msidt0k7MUgJ7vwWaIl3QDy1cmUgrdznemVZCvTeknrrnYhPhq9eRYx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FnMiX1Pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FnMiX1Pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FCCC4CEE4;
	Sat,  7 Jun 2025 21:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749332011;
	bh=QsRUyl6lOEWl4x7Z2rNCni/ukMM9cTNwiyTVpffoC8o=;
	h=Date:To:From:Subject:From;
	b=FnMiX1PgPORsjbXAvyVsHXnelq3es4+VOJAy4Jo6oijk+IbR9Yc+vHDSxCSWg2XQ8
	 3bG300LFY6vptrl8YsOOtr/K5PYKgQ2TK2Mn4Z3YJje7kZ4TIVwSqWxgXjcO/Ra6SY
	 +crkj7dC0cNhUqFiMLO+Rk0lELyeADz+36o+QX0g=
Date: Sat, 07 Jun 2025 14:33:30 -0700
To: mm-commits@vger.kernel.org,wangfushuai@baidu.com,osalvador@suse.de,liam.howlett@oracle.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,broonie@kernel.org,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250607213331.72FCCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

