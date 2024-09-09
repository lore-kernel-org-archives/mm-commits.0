Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A5118E375
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925323; cv=none; b=agD4a0vtslsBcHm5FPPMTfCaG61/VPQ/ZD/wdKKRheJk2krL8elXjYdEnM5lBI4gJkVPReREs66JxylVjW1b6YPnq167GNpLsGf2/Pas/4ZbH8dKGWN9gQSjZqpYMek7VAX4tWL7Ae+Q89lNkBlJwqsNqUDZtd/ueGV2HH4fu+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925323; c=relaxed/simple;
	bh=ha6xcoDV4cSBYBAOwq8bjWTVXvwid/CUZ68CdOcDfG8=;
	h=Date:To:From:Subject:Message-Id; b=BbNubUdgZjtMfb3djFde/7Ssvfu50bPSKuezlmOngE+6fIQrTbWXJuN6RzQPDbT840a25zdM33tkZddk/h/fP7ONrtWXx02Fbuv/cCZNS1/6msgIdilO9T2Q+VRNDfSLj/o4QvYPG7RmM4TztIf3AKVoT2SMGJ+n6W9fw/t2ZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=03Hu/sIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03Hu/sIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB5BC4CEC6;
	Mon,  9 Sep 2024 23:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925323;
	bh=ha6xcoDV4cSBYBAOwq8bjWTVXvwid/CUZ68CdOcDfG8=;
	h=Date:To:From:Subject:From;
	b=03Hu/sIgU4m+J2nufEDQRcMBjNBafx7m9FlBWR8PfEQDK0IXC0E1oE55aeYOppAIq
	 veUN4TIy4L62XuNCA/thH0DFVHaZZcolu847+RXRcHhPlQAyQ1gy/g7asRFy/xn47h
	 gi3ABAex56su9hWgr8EfDZE0W8I21sh5AeLItLJ0=
Date: Mon, 09 Sep 2024 16:42:02 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,zhangpeng362@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-use-helper-function-va_size.patch removed from -mm tree
Message-Id: <20240909234203.1DB5BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: use helper function va_size()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-use-helper-function-va_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 
@@ -2192,7 +2192,7 @@ static void purge_vmap_node(struct work_
 	vn->nr_purged = 0;
 
 	list_for_each_entry_safe(va, n_va, &vn->purge_list, list) {
-		unsigned long nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
+		unsigned long nr = va_size(va) >> PAGE_SHIFT;
 		unsigned long orig_start = va->va_start;
 		unsigned long orig_end = va->va_end;
 		unsigned int vn_id = decode_vn_id(va->flags);
@@ -2336,8 +2336,8 @@ static void free_vmap_area_noflush(struc
 	if (WARN_ON_ONCE(!list_empty(&va->list)))
 		return;
 
-	nr_lazy = atomic_long_add_return((va->va_end - va->va_start) >>
-				PAGE_SHIFT, &vmap_lazy_nr);
+	nr_lazy = atomic_long_add_return(va_size(va) >> PAGE_SHIFT,
+					 &vmap_lazy_nr);
 
 	/*
 	 * If it was request by a certain node we would like to
@@ -2933,8 +2933,7 @@ void vm_unmap_ram(const void *mem, unsig
 	if (WARN_ON_ONCE(!va))
 		return;
 
-	debug_check_no_locks_freed((void *)va->va_start,
-				    (va->va_end - va->va_start));
+	debug_check_no_locks_freed((void *)va->va_start, va_size(va));
 	free_unmap_vmap_area(va);
 }
 EXPORT_SYMBOL(vm_unmap_ram);
@@ -4932,7 +4931,7 @@ static void show_purge_info(struct seq_f
 		list_for_each_entry(va, &vn->lazy.head, list) {
 			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
 				(void *)va->va_start, (void *)va->va_end,
-				va->va_end - va->va_start);
+				va_size(va));
 		}
 		spin_unlock(&vn->lazy.lock);
 	}
@@ -4954,7 +4953,7 @@ static int vmalloc_info_show(struct seq_
 				if (va->flags & VMAP_RAM)
 					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
 						(void *)va->va_start, (void *)va->va_end,
-						va->va_end - va->va_start);
+						va_size(va));
 
 				continue;
 			}
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


