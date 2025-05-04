Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE1817A2F8
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746341170; cv=none; b=tBliHukSz4Y5jRLuid9p03eKrHscS8+TYsBf7GVSkUHvhEyTgrkvoO7kl4SLpjBkxKo2mZ3rahFtw7oW2BRgHRJ+ifKhA/8xtfU7n7XUuOJLqxUMmeYQYdLwvpaxGJR8eZaI+u+8yL1KchX/yqnFQL8qaBNg7gOgAUkixoVL8Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746341170; c=relaxed/simple;
	bh=qM3cg0CFaVy1CTNvbu/r2w4qmVJLdLgAkEkKr3Xspdk=;
	h=Date:To:From:Subject:Message-Id; b=CLwbS3BSPuVAkuhZYLEaYBZlJ/hFegpO39yNXkg9czkc+T20MrmxfA3Xg/leL7T2nQPfN7HcEcRzhpk7Iiq6X1yL0ZJhPnz7oKCJYfUrXurbTUtAgvJU001+D+Kg+3jbzzWqLcB2wioU4wOf8RyyIQx9iR0nGD0DAfiau2xGfPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHmDEPuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHmDEPuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945FCC4CEE7;
	Sun,  4 May 2025 06:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746341169;
	bh=qM3cg0CFaVy1CTNvbu/r2w4qmVJLdLgAkEkKr3Xspdk=;
	h=Date:To:From:Subject:From;
	b=ZHmDEPuo0Geu2mRlmG8B0Pt9j7slD78cRy7ZEhMpxbSIIqjutpy120qR9GbMYCV8p
	 542DkbSb9yzEVaaJdXvpK9eaHPPHcH36dVjmK3U1ppAQB1Q1Is7eUnW5m1RLKusokF
	 S9B4sfHbSHlbjEY5kvHYORpP4usrGlUuEp1nbPPg=
Date: Sat, 03 May 2025 23:46:09 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,coxu@redhat.com,bhe@redhat.com,berrange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-x86-mm-remove-unused-__set_memory_prot-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250504064609.945FCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: revert-x86-mm-remove-unused-__set_memory_prot-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: revert-x86-mm-remove-unused-__set_memory_prot-fix
Date: Sat May  3 11:38:32 PM PDT 2025

x86 set_memory.h needs pgtable_types.h for pgprot_t.  Obtain it via the
higher-level pgtable.h.

Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/set_memory.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/set_memory.h~revert-x86-mm-remove-unused-__set_memory_prot-fix
+++ a/arch/x86/include/asm/set_memory.h
@@ -4,6 +4,7 @@
 
 #include <asm/page.h>
 #include <asm-generic/set_memory.h>
+#include <asm/pgtable.h>
 
 #define set_memory_rox set_memory_rox
 int set_memory_rox(unsigned long addr, int numpages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

