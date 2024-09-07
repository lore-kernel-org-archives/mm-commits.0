Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBD71B85DC
	for <mm-commits@vger.kernel.org>; Sat,  7 Sep 2024 03:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725678927; cv=none; b=T2HA5QFj1Ly6zMfOzsP0QUsX/n9s/4O0n/wOzJwMp5k+SZTG+11RpiL4iSfr8dx7ZrT4wbPM2KJTE0bFORluXSo9vZ4mnsC+WjrUe/f9+q8XObVB7T/Dg4WiZPOYcIrxVNYZoQD04b9C7VsRtko4J4ziNibAB8nNKVTl0sc1LdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725678927; c=relaxed/simple;
	bh=veHyp4GLwYBwYHt9mIKikq/Nyb4TvxZ0fEyhZwxV8tI=;
	h=Date:To:From:Subject:Message-Id; b=n7q1RTrUlBpNt5/GrqVjTCDjK5knyjTXteMPYR09xN7fExQPhB1psNUFp1NuMpnDGr1ZYDx2Hppj6gt5atzr1/OUkyZcJpHKHYBNcuFVm85l7nwZKkMHRAoRa/VjAApvf5J0Cu57bwuQAJCmBA/HSp/3KdE/s2WileVYlImxxhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HlcPxq72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HlcPxq72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E187C4CEC2;
	Sat,  7 Sep 2024 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725678927;
	bh=veHyp4GLwYBwYHt9mIKikq/Nyb4TvxZ0fEyhZwxV8tI=;
	h=Date:To:From:Subject:From;
	b=HlcPxq725ulI272PGzRH0Y5D4pkpzMzx4uB/ojLFd4I0LAnwvQYGWKueSMwxzQHye
	 pFB+oruKPoJo1P1ONPPjTAbTVS/ho1NBUoyukhMC4aaeCCv+mfMyjZ0Y5WQ9WrtDeg
	 QxttzJUhU/KIIyMAKnAWhdYjsDuhvbUusUIBIwNA=
Date: Fri, 06 Sep 2024 20:15:26 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,zhangpeng362@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-use-helper-function-va_size.patch added to mm-unstable branch
Message-Id: <20240907031527.0E187C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: use helper function va_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmallocc-use-helper-function-va_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-use-helper-function-va_size.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/vmalloc.c: use helper function va_size()
Date: Fri, 6 Sep 2024 18:25:39 +0800

Use helper function va_size() to improve code readability. No functional
modification involved.

Link: https://lkml.kernel.org/r/20240906102539.3537207-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-use-helper-function-va_size
+++ a/mm/vmalloc.c
@@ -1940,7 +1940,7 @@ static inline void setup_vmalloc_vm(stru
 {
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
-	vm->size = va->va_end - va->va_start;
+	vm->size = va_size(va);
 	vm->caller = caller;
 	va->vm = vm;
 }
@@ -2018,7 +2018,7 @@ retry:
 
 	if (vm) {
 		vm->addr = (void *)va->va_start;
-		vm->size = va->va_end - va->va_start;
+		vm->size = va_size(va);
 		va->vm = vm;
 	}
 
@@ -2215,7 +2215,7 @@ static void purge_vmap_node(struct work_
 	vn->nr_purged = 0;
 
 	list_for_each_entry_safe(va, n_va, &vn->purge_list, list) {
-		unsigned long nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
+		unsigned long nr = va_size(va) >> PAGE_SHIFT;
 		unsigned int vn_id = decode_vn_id(va->flags);
 
 		list_del_init(&va->list);
@@ -2355,8 +2355,8 @@ static void free_vmap_area_noflush(struc
 	if (WARN_ON_ONCE(!list_empty(&va->list)))
 		return;
 
-	nr_lazy = atomic_long_add_return((va->va_end - va->va_start) >>
-				PAGE_SHIFT, &vmap_lazy_nr);
+	nr_lazy = atomic_long_add_return(va_size(va) >> PAGE_SHIFT,
+					 &vmap_lazy_nr);
 
 	/*
 	 * If it was request by a certain node we would like to
@@ -2952,8 +2952,7 @@ void vm_unmap_ram(const void *mem, unsig
 	if (WARN_ON_ONCE(!va))
 		return;
 
-	debug_check_no_locks_freed((void *)va->va_start,
-				    (va->va_end - va->va_start));
+	debug_check_no_locks_freed((void *)va->va_start, va_size(va));
 	free_unmap_vmap_area(va);
 }
 EXPORT_SYMBOL(vm_unmap_ram);
@@ -4953,7 +4952,7 @@ static void show_purge_info(struct seq_f
 		list_for_each_entry(va, &vn->lazy.head, list) {
 			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
 				(void *)va->va_start, (void *)va->va_end,
-				va->va_end - va->va_start);
+				va_size(va));
 		}
 		spin_unlock(&vn->lazy.lock);
 	}
@@ -4975,7 +4974,7 @@ static int vmalloc_info_show(struct seq_
 				if (va->flags & VMAP_RAM)
 					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
 						(void *)va->va_start, (void *)va->va_end,
-						va->va_end - va->va_start);
+						va_size(va));
 
 				continue;
 			}
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-vmallocc-use-helper-function-va_size.patch

