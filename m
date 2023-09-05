Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380F6CA0FFA
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 17:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbjIERkU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 13:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbjIERjt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 13:39:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC383A3F3;
        Tue,  5 Sep 2023 10:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED30060C37;
        Tue,  5 Sep 2023 17:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A04DC433C7;
        Tue,  5 Sep 2023 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693934091;
        bh=4kH156gC5NtbFa8I9tM0rjb82yRM0ElPBO49A+k/lyo=;
        h=Date:To:From:Subject:From;
        b=D5UhXufIoqs7bTXGUzj5pU+1ANwpicFMxeqF3Tz2xuTJQRKL+DJ0BwnIHnwpi05kG
         lm6NfvSBofuby3Qrh6B3vrnhi+RKjWASDyJlCwsGI6Fx6gDLciQi+Wrtx5I4e5ypSQ
         UsLZiXsWbjPLXBe315iuMhqoRkETP8kC0z51E4xM=
Date:   Tue, 05 Sep 2023 10:14:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        thunder.leizhen@huaweicloud.com, stable@vger.kernel.org,
        qiang.zhang1211@gmail.com, paulmck@kernel.org,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch removed from -mm tree
Message-Id: <20230905171451.4A04DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: add a safer version of find_vm_area() for debug
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: mm/vmalloc: add a safer version of find_vm_area() for debug
Date: Mon, 4 Sep 2023 18:08:04 +0000

It is unsafe to dump vmalloc area information when trying to do so from
some contexts.  Add a safer trylock version of the same function to do a
best-effort VMA finding and use it from vmalloc_dump_obj().

[applied test robot feedback on unused function fix.]
[applied Uladzislau feedback on locking.]
Link: https://lkml.kernel.org/r/20230904180806.1002832-1-joel@joelfernandes.org
Fixes: 98f180837a89 ("mm: Make mem_dump_obj() handle vmalloc() memory")
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: Zhen Lei <thunder.leizhen@huaweicloud.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug
+++ a/mm/vmalloc.c
@@ -4278,14 +4278,32 @@ void pcpu_free_vm_areas(struct vm_struct
 #ifdef CONFIG_PRINTK
 bool vmalloc_dump_obj(void *object)
 {
-	struct vm_struct *vm;
 	void *objp = (void *)PAGE_ALIGN((unsigned long)object);
+	const void *caller;
+	struct vm_struct *vm;
+	struct vmap_area *va;
+	unsigned long addr;
+	unsigned int nr_pages;
+
+	if (!spin_trylock(&vmap_area_lock))
+		return false;
+	va = __find_vmap_area((unsigned long)objp, &vmap_area_root);
+	if (!va) {
+		spin_unlock(&vmap_area_lock);
+		return false;
+	}
 
-	vm = find_vm_area(objp);
-	if (!vm)
+	vm = va->vm;
+	if (!vm) {
+		spin_unlock(&vmap_area_lock);
 		return false;
+	}
+	addr = (unsigned long)vm->addr;
+	caller = vm->caller;
+	nr_pages = vm->nr_pages;
+	spin_unlock(&vmap_area_lock);
 	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
-		vm->nr_pages, (unsigned long)vm->addr, vm->caller);
+		nr_pages, addr, caller);
 	return true;
 }
 #endif
_

Patches currently in -mm which might be from joel@joelfernandes.org are


