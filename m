Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80BBC83F33
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjIDTac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjIDTa3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:30:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E239C197;
        Mon,  4 Sep 2023 12:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B22EB80F4B;
        Mon,  4 Sep 2023 19:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49755C433C8;
        Mon,  4 Sep 2023 19:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693855822;
        bh=KAXqIdsJ4MWqpglVN2x0udyPOU08vRRH/RZh/bp6tXA=;
        h=Date:To:From:Subject:From;
        b=aHHLqI2qdBDbGKj6FjBsW5k/+2yuiAQcosmYMmemQSTzZ59M5vgED2JrFv5pOlFqL
         TuA8mSMDV8OZUv/aDb8Jevhj0Pi4RuWhjEzhcgciP3Wdpn8pKxrHNk0cwQKOmI7ImW
         5kwRbbX/vTOH+jNDEIm9x+8o6NlXXf6juBk4Nyus=
Date:   Mon, 04 Sep 2023 12:30:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        thunder.leizhen@huaweicloud.com, stable@vger.kernel.org,
        qiang.zhang1211@gmail.com, paulmck@kernel.org,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch added to mm-hotfixes-unstable branch
Message-Id: <20230904193022.49755C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add a safer version of find_vm_area() for debug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

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

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

