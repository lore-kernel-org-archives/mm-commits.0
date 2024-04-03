Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE8156868
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712181222; cv=none; b=a4fZcEoMrCmxBPXOmXCxB6IhBbjpjirrqvNdDpP7hNga3YiKISey98W+kN2nk8/LFinccLUdHHDnNgrJlADv/C9TxMkOZcjNfl8Zak7xQrPK4uLwu00trNBfA3Nevn5lutIne0gucD+zeJhelGDnAdmfMjeT1NsjU21NLgFVVtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712181222; c=relaxed/simple;
	bh=qDmHQuRmQEMGFdo8a9rpaJJaNNWbxMXdnOx3HXt/8cc=;
	h=Date:To:From:Subject:Message-Id; b=htLt8bNp8C2G2Nu/SxUPgD72+C3X5WhzbuagsQEECrdJkbrEqHOm+PhALuu3lDfgyEwb8J5xI1qhjyiZslmyh0e0ATCmQZsDIbJuoF3Vhxb9dWzjb57UJsCw6YjMDUAqmtmXN0Xj0AQ3m3Enr/KSOtNGgGAxbdYKxvyLAmxfb/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CbFJsc/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CbFJsc/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F59C433F1;
	Wed,  3 Apr 2024 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712181221;
	bh=qDmHQuRmQEMGFdo8a9rpaJJaNNWbxMXdnOx3HXt/8cc=;
	h=Date:To:From:Subject:From;
	b=CbFJsc/cxRerSSR7sVY5dTSDI5HWV296qx9g8Jt8alHKq2xvRoeL+VxWL8NN2/t8r
	 aNG8ZmVFuWtbFgPdDqR5TLeluS8F5dGGfWflRgZefLMbnTK9QKSfRYuw31l79+1tNR
	 PXjwCA1L7bYbPS0htIJHv/XB0mSxh1WGSmHXdzk0=
Date: Wed, 03 Apr 2024 14:53:41 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-missing-vmalloch-includes-fix-2.patch added to mm-unstable branch
Message-Id: <20240403215341.B3F59C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been added to the -mm mm-unstable branch.  Its filename is
     fix-missing-vmalloch-includes-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-missing-vmalloch-includes-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: fixup! fix missing vmalloc.h includes
Date: Tue, 2 Apr 2024 11:09:32 -0700

vmalloc.h header refactoring missed vmalloc.h inclusion required for
__vmalloc_start_set symbol.  Add missing inclusion.

Link: https://lkml.kernel.org/r/20240402180933.1663992-1-surenb@google.com
Fixes: 07aecea15cc8 ("fix missing vmalloc.h includes")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290536.7f9zGl5Q-lkp@intel.com/
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/mm/numa_32.c~fix-missing-vmalloch-includes-fix-2
+++ a/arch/x86/mm/numa_32.c
@@ -24,6 +24,7 @@
 
 #include <linux/memblock.h>
 #include <linux/init.h>
+#include <linux/vmalloc.h>
 
 #include "numa_internal.h"
 
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes-fix-2.patch
mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-enable-page-allocation-tagging-fix.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

