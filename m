Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6CCC001DB
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 01:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbjICBaw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 21:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjICBau (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 21:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC05FA2
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 18:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9C9B80AAF
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 01:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB51EC433C8;
        Sun,  3 Sep 2023 01:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693704640;
        bh=GMBQuILrFjCX71w1Y64s17b6M0xq1sKAkSumHrz4vx8=;
        h=Date:To:From:Subject:From;
        b=bSmxe5h0mmXzjCrBFcGw7WKx0KZmxfj2edInd2FcbCRZKOJ/28pBCZJlOvmAOwHHV
         agVmpX3jqpYzLyHpF5gX8KIwzYhx1jAC/Z7c5KCKgTfPCNC7bF6rZ8iahxpJs3dsEW
         7ubhRw6ZYk3gVuoJOqeQwUd67lUfwWqGrI2bhiic=
Date:   Sat, 02 Sep 2023 18:30:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        thunder.leizhen@huaweicloud.com, qiang.zhang1211@gmail.com,
        paulmck@kernel.org, hch@infradead.org, joel@joelfernandes.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch added to mm-unstable branch
Message-Id: <20230903013040.CB51EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add a safer version of find_vm_area() for debug
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

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
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: mm/vmalloc: add a safer version of find_vm_area() for debug
Date: Wed, 30 Aug 2023 11:03:59 +0000

It is unsafe to dump vmalloc area information when trying to do so from
some contexts.  Add a safer trylock version of the same function to do a
best-effort VMA finding and use it from vmalloc_dump_obj().

Link: https://lkml.kernel.org/r/20230830110402.386898-1-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reported-by: Zhen Lei <thunder.leizhen@huaweicloud.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug
+++ a/mm/vmalloc.c
@@ -1865,6 +1865,18 @@ struct vmap_area *find_vmap_area(unsigne
 	return va;
 }
 
+static struct vmap_area *find_vmap_area_trylock(unsigned long addr)
+{
+	struct vmap_area *va;
+
+	if (!spin_trylock(&vmap_area_lock))
+		return NULL;
+	va = __find_vmap_area(addr, &vmap_area_root);
+	spin_unlock(&vmap_area_lock);
+
+	return va;
+}
+
 static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
 {
 	struct vmap_area *va;
@@ -2672,6 +2684,27 @@ struct vm_struct *find_vm_area(const voi
 }
 
 /**
+ * try_to_find_vm_area - find a continuous kernel virtual area
+ * @addr:	  base address
+ *
+ * This function is the same as find_vm_area() except that it is
+ * safe to call if vmap_area_lock is already held and returns NULL
+ * if it is. See comments in find_vmap_area() for other details.
+ *
+ * Return: the area descriptor on success or %NULL on failure.
+ */
+static struct vm_struct *try_to_find_vm_area(const void *addr)
+{
+	struct vmap_area *va;
+
+	va = find_vmap_area_trylock((unsigned long)addr);
+	if (!va)
+		return NULL;
+
+	return va->vm;
+}
+
+/**
  * remove_vm_area - find and remove a continuous kernel virtual area
  * @addr:	    base address
  *
@@ -4281,7 +4314,7 @@ bool vmalloc_dump_obj(void *object)
 	struct vm_struct *vm;
 	void *objp = (void *)PAGE_ALIGN((unsigned long)object);
 
-	vm = find_vm_area(objp);
+	vm = try_to_find_vm_area(objp);
 	if (!vm)
 		return false;
 	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
_

Patches currently in -mm which might be from joel@joelfernandes.org are

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch

