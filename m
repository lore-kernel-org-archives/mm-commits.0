Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF6F56741
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 19:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYMgr/6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0159C433C7;
	Thu, 11 Jan 2024 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705002749;
	bh=U2UWYASePMajcEEzzpodrR52fhbvPvVu9pOTjRIC1sY=;
	h=Date:To:From:Subject:From;
	b=DYMgr/6bELSuer1nVlsDwOY9jKPT+IigKuPhczfaqaMRAriz809QGvEQ73c0CFskF
	 X5nssy7sK3a5knvpXUFymzB9x3Dcd9OD95qN+mJxyyBBh0L7WcOA4ezQCtDtIdHLZs
	 d0o2E1BdG0Ezamkb7wo7ZNvxJGYvGcKnC87PYkmM=
Date: Thu, 11 Jan 2024 11:52:28 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-vmap_area_list-fix.patch added to mm-unstable branch
Message-Id: <20240111195228.F0159C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: Fix a warning in the crash_save_vmcoreinfo_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-vmap_area_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-vmap_area_list-fix.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: Fix a warning in the crash_save_vmcoreinfo_init()
Date: Thu, 11 Jan 2024 20:23:29 +0100

The vmcoreinfo_append_str() function expects "long unsigned int" type as a
second argument(0x%lx) to print a beginning of vmalloc start address which
is defined as a VMALLOC_START macro.

For some architectures it can be considered as "int" type, for example m68
generates a compile warning message.  To fix it cast a second argument to
"unsigned long".

Link: https://lkml.kernel.org/r/20240111192329.449189-1-urezki@gmail.com
Fixes: 9bdb180b2d ("mm/vmalloc: remove vmap_area_list")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401120218.y469Puyf-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_core.c~mm-vmalloc-remove-vmap_area_list-fix
+++ a/kernel/crash_core.c
@@ -748,7 +748,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL_ARRAY(swapper_pg_dir);
 #endif
 	VMCOREINFO_SYMBOL(_stext);
-	vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
+	vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", (unsigned long) VMALLOC_START);
 
 #ifndef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(mem_map);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-vmap_area_list-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

