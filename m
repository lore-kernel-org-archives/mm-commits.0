Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB55B1EB1BB
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118703; cv=none; b=rEYaHiGNs557hpEiifa1odx8/v7eNDdZtSUWyoTOcqb0I0fefxnIIrvbE1Z4iGAyrgc0ZXF43D03Ua0qfGjWICFnWnfOid6waN2Bnm4lawsOVO01biAl7nwst7IJhElgJdum0wzci7czGDUMdSoU5HvenBE7fyal+R3axtiFLIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118703; c=relaxed/simple;
	bh=vq3vO4+UvP/qOVLnFC1pVmsU+Qn69pKAGg1JPgXukqU=;
	h=Date:To:From:Subject:Message-Id; b=Tphih2jGgA4OmXK2YhTOkBjZ4er7A7uwMYcmTaWH9J7HWVbrceRYIJl0lItcW2ljqiql3SuhnjeQnPQly/ieotW7zm5Y54OUvf5ATC3O5dj1DhKKuvzrIMsD/NA/2MljChbZinahtD5Vu9SQdHaFmeH3VujwZMKWGJ55FrB0/B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yd6up0FG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yd6up0FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98075C4CEE4;
	Tue, 13 May 2025 06:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118703;
	bh=vq3vO4+UvP/qOVLnFC1pVmsU+Qn69pKAGg1JPgXukqU=;
	h=Date:To:From:Subject:From;
	b=yd6up0FGCYmsErXKiiTF/IP2Ewmndkrns3Zcb46pljeiLeMGGuH+4mGqoVIO62rGZ
	 LCHYKSPMmfd+HcMyOJvFIpmxiWQtUuL1D9Su7c5g6reh/LWjGfrW5SzVoMwPE16cZC
	 e+DTPE/CePpcS4jbVqwR/7D7L+bCo3Skwf7xcrzU=
Date: Mon, 12 May 2025 23:45:03 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,lkp@intel.com,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch removed from -mm tree
Message-Id: <20250513064503.98075C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix
has been removed from the -mm tree.  Its filename was
     memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch

This patch was dropped because it was folded into memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix
Date: Sat May  3 06:37:28 PM PDT 2025

make ksm_process_profit() available on CONFIG_PROCFS=n

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505030429.a2GUiRAz-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/ksm.c~memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix
+++ a/mm/ksm.c
@@ -3268,7 +3268,6 @@ static void wait_while_offlining(void)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-#ifdef CONFIG_PROC_FS
 /*
  * The process is mergeable only if any VMA is currently
  * applicable to KSM.
@@ -3293,7 +3292,6 @@ long ksm_process_profit(struct mm_struct
 	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
-#endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SYSFS
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

