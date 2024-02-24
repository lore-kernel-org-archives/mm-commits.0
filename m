Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2D81870
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738772; cv=none; b=E832PB5hEaipgSYX++GfELQW/LLaBUzoHWm+cVdwpB6K6V2pney4pzUyk2SGmq/AjFJh1PnSpdqpcp4aOrefHol/rpYoWI0lLpXg6iZ8WrLAc1i7nkvSg0RKT3MDintJlZmFtR97Z7b4CawIXzlA9RPCLSEJwCRE8jGren6xaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738772; c=relaxed/simple;
	bh=4g3nG6MlbZK/dltP3jYM5HMctRbHT3iYjVgQ2TTug64=;
	h=Date:To:From:Subject:Message-Id; b=UroZ4qjENwRt7mLGaj/Td3DFeqYyFnxrifjqeV4e8jK+4FXQF6WlYY+R7aZ3vb29yhffSlcGy6LVWR7HVXY8lRV+YYqujdnESxG0Uw7jb5HHCnIZ++VNUdNH6XpDiG0SFeU7HW1GydxFFwfN3dNBbnFM4PnmrYTerHUwoL/yv+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EWRkokC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EWRkokC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A29C433F1;
	Sat, 24 Feb 2024 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738771;
	bh=4g3nG6MlbZK/dltP3jYM5HMctRbHT3iYjVgQ2TTug64=;
	h=Date:To:From:Subject:From;
	b=EWRkokC5ZcYs4Q8r3TaTs0qOwn8lHWu28QF+30vmhgoL/cKv5/mOEQ9i+U19wywUQ
	 /S72uRraAjP2iYcugYRRheLyy1HJ2n39dOn/4rd+UgxLru5Zvvq1+tIOl/abu+KURi
	 YNcILl1mKMR7d0a/bL2MLSv056WjfH95dPpRjY5c=
Date: Fri, 23 Feb 2024 17:39:31 -0800
To: mm-commits@vger.kernel.org,lstoakes@gmail.com,lkp@intel.com,bhe@redhat.com,anshuman.khandual@arm.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-remove-vmap_area_list-fix.patch removed from -mm tree
Message-Id: <20240224013931.97A29C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: Fix a warning in the crash_save_vmcoreinfo_init()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-vmap_area_list-fix.patch

This patch was dropped because it was folded into mm-vmalloc-remove-vmap_area_list.patch

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
Fixes: 9bdb180b2db6 ("mm/vmalloc: remove vmap_area_list")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401120218.y469Puyf-lkp@intel.com/
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
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
mm-vmalloc-remove-vmap_area_list.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch
mm-vmalloc-improve-description-of-vmap-node-layer.patch
mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

