Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B103CC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbjJYXuO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjJYXtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D65810C3
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3F6C433C9;
        Wed, 25 Oct 2023 23:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277735;
        bh=uOzjn88cXqP93Lu+MenRLxQstcIL7RAMx4MZSSrOfHY=;
        h=Date:To:From:Subject:From;
        b=lnDdbqLxSGSibSSaaKv85wCb9cP850TaNEBWWkCZs96eECveN8oDgLNXk2aMr9JZf
         ggeGNU3nRmTyV7HGpTf9x+Vc6IfEBvqM+zVFOhqcC4Vb0qGp6Wt4JVGnlNeWdMrNud
         jTiHC4OFTP7FxYFwbkTb8H9e0sro0FwvgxQ2koZE=
Date:   Wed, 25 Oct 2023 16:48:55 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-add-__find_and_remove_object.patch removed from -mm tree
Message-Id: <20231025234855.DB3F6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmemleak: add __find_and_remove_object()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-add-__find_and_remove_object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: kmemleak: add __find_and_remove_object()
Date: Wed, 18 Oct 2023 18:29:51 +0800

Add new __find_and_remove_object() without kmemleak_lock protect, it is in
preparation for the next patch.

Link: https://lkml.kernel.org/r/20231018102952.3339837-7-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-add-__find_and_remove_object
+++ a/mm/kmemleak.c
@@ -583,6 +583,19 @@ static void __remove_object(struct kmeml
 	object->del_state |= DELSTATE_REMOVED;
 }
 
+static struct kmemleak_object *__find_and_remove_object(unsigned long ptr,
+							int alias,
+							bool is_phys)
+{
+	struct kmemleak_object *object;
+
+	object = __lookup_object(ptr, alias, is_phys);
+	if (object)
+		__remove_object(object);
+
+	return object;
+}
+
 /*
  * Look up an object in the object search tree and remove it from both
  * object_tree_root (or object_phys_tree_root) and object_list. The
@@ -596,9 +609,7 @@ static struct kmemleak_object *find_and_
 	struct kmemleak_object *object;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
-	object = __lookup_object(ptr, alias, is_phys);
-	if (object)
-		__remove_object(object);
+	object = __find_and_remove_object(ptr, alias, is_phys);
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
 
 	return object;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

