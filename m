Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1FDC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347610AbiATVXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347569AbiATVXq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBF2C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D0A8B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B61C340E0;
        Thu, 20 Jan 2022 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713823;
        bh=TRQ+hM1gT/Qq3A/KQa9SMesFMi+li+Dm/6vz0lwv/UM=;
        h=Date:From:To:Subject:From;
        b=EmqMTOcOobM5I7VeMO3o4r9ixnSOpS70XWiC/zAADVrrd1Rh7OcI8w5o4D/EM1zFS
         wOw+mSqLq0CrSpPrpN+hKK07UdgimDme8SYz26q0AL3FSpXQaQg4kPSoTLj+2O080q
         vyQ1jrT42aX3BrCqCAz94HHCITz5nHQYeHDkFk4k=
Date:   Thu, 20 Jan 2022 13:23:42 -0800
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, Kuan-Ying.Lee@mediatek.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        opendmb@gmail.com, peterz@infradead.org, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-base?=
 =?US-ASCII?Q?d-kasan-enable.patch?= removed from -mm tree
Message-ID: <20220120212342.7DZ_2BP-g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: fix kmemleak false positive report with HW tag-based kasan enable
has been removed from the -mm tree.  Its filename was
     kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kmemleak: fix kmemleak false positive report with HW tag-based kasan enable

With HW tag-based kasan enable, We will get the warning when we free
object whose address starts with 0xFF.

It is because kmemleak rbtree stores tagged object and this freeing
object's tag does not match with rbtree object.

In the example below, kmemleak rbtree stores the tagged object in the
kmalloc(), and kfree() gets the pointer with 0xFF tag.

Call sequence:
ptr = kmalloc(size, GFP_KERNEL);
page = virt_to_page(ptr);
offset = offset_in_page(ptr);
kfree(page_address(page) + offset);
ptr = kmalloc(size, GFP_KERNEL);

Call sequence like that may cause the warning as following:
1) Freeing unknown object:
In kfree(), we will get free unknown object warning in kmemleak_free().
Because object(0xFx) in kmemleak rbtree and pointer(0xFF) in kfree() have
different tag.

2) Overlap existing:
When we allocate that object with the same hw-tag again, we will
find the overlap in the kmemleak rbtree and kmemleak thread will
be killed.

[  116.685312] kmemleak: Freeing unknown object at 0xffff000003f88000
[  116.686422] CPU: 5 PID: 177 Comm: cat Not tainted 5.16.0-rc1-dirty #21
[  116.687067] Hardware name: linux,dummy-virt (DT)
[  116.687496] Call trace:
[  116.687792]  dump_backtrace+0x0/0x1ac
[  116.688255]  show_stack+0x1c/0x30
[  116.688663]  dump_stack_lvl+0x68/0x84
[  116.689096]  dump_stack+0x1c/0x38
[  116.689499]  kmemleak_free+0x6c/0x70
[  116.689919]  slab_free_freelist_hook+0x104/0x200
[  116.690420]  kmem_cache_free+0xa8/0x3d4
[  116.690845]  test_version_show+0x270/0x3a0
[  116.691344]  module_attr_show+0x28/0x40
[  116.691789]  sysfs_kf_seq_show+0xb0/0x130
[  116.692245]  kernfs_seq_show+0x30/0x40
[  116.692678]  seq_read_iter+0x1bc/0x4b0
[  116.692678]  seq_read_iter+0x1bc/0x4b0
[  116.693114]  kernfs_fop_read_iter+0x144/0x1c0
[  116.693586]  generic_file_splice_read+0xd0/0x184
[  116.694078]  do_splice_to+0x90/0xe0
[  116.694498]  splice_direct_to_actor+0xb8/0x250
[  116.694975]  do_splice_direct+0x88/0xd4
[  116.695409]  do_sendfile+0x2b0/0x344
[  116.695829]  __arm64_sys_sendfile64+0x164/0x16c
[  116.696306]  invoke_syscall+0x48/0x114
[  116.696735]  el0_svc_common.constprop.0+0x44/0xec
[  116.697263]  do_el0_svc+0x74/0x90
[  116.697665]  el0_svc+0x20/0x80
[  116.698261]  el0t_64_sync_handler+0x1a8/0x1b0
[  116.698695]  el0t_64_sync+0x1ac/0x1b0
...
[  117.520301] kmemleak: Cannot insert 0xf2ff000003f88000 into the object search tree (overlaps existing)
[  117.521118] CPU: 5 PID: 178 Comm: cat Not tainted 5.16.0-rc1-dirty #21
[  117.521827] Hardware name: linux,dummy-virt (DT)
[  117.522287] Call trace:
[  117.522586]  dump_backtrace+0x0/0x1ac
[  117.523053]  show_stack+0x1c/0x30
[  117.523578]  dump_stack_lvl+0x68/0x84
[  117.524039]  dump_stack+0x1c/0x38
[  117.524472]  create_object.isra.0+0x2d8/0x2fc
[  117.524975]  kmemleak_alloc+0x34/0x40
[  117.525416]  kmem_cache_alloc+0x23c/0x2f0
[  117.525914]  test_version_show+0x1fc/0x3a0
[  117.526379]  module_attr_show+0x28/0x40
[  117.526827]  sysfs_kf_seq_show+0xb0/0x130
[  117.527363]  kernfs_seq_show+0x30/0x40
[  117.527848]  seq_read_iter+0x1bc/0x4b0
[  117.528320]  kernfs_fop_read_iter+0x144/0x1c0
[  117.528809]  generic_file_splice_read+0xd0/0x184
[  117.529316]  do_splice_to+0x90/0xe0
[  117.529734]  splice_direct_to_actor+0xb8/0x250
[  117.530227]  do_splice_direct+0x88/0xd4
[  117.530686]  do_sendfile+0x2b0/0x344
[  117.531154]  __arm64_sys_sendfile64+0x164/0x16c
[  117.531673]  invoke_syscall+0x48/0x114
[  117.532111]  el0_svc_common.constprop.0+0x44/0xec
[  117.532621]  do_el0_svc+0x74/0x90
[  117.533048]  el0_svc+0x20/0x80
[  117.533461]  el0t_64_sync_handler+0x1a8/0x1b0
[  117.533950]  el0t_64_sync+0x1ac/0x1b0
[  117.534625] kmemleak: Kernel memory leak detector disabled
[  117.535201] kmemleak: Object 0xf2ff000003f88000 (size 128):
[  117.535761] kmemleak:   comm "cat", pid 177, jiffies 4294921177
[  117.536339] kmemleak:   min_count = 1
[  117.536718] kmemleak:   count = 0
[  117.537068] kmemleak:   flags = 0x1
[  117.537429] kmemleak:   checksum = 0
[  117.537806] kmemleak:   backtrace:
[  117.538211]      kmem_cache_alloc+0x23c/0x2f0
[  117.538924]      test_version_show+0x1fc/0x3a0
[  117.539393]      module_attr_show+0x28/0x40
[  117.539844]      sysfs_kf_seq_show+0xb0/0x130
[  117.540304]      kernfs_seq_show+0x30/0x40
[  117.540750]      seq_read_iter+0x1bc/0x4b0
[  117.541206]      kernfs_fop_read_iter+0x144/0x1c0
[  117.541687]      generic_file_splice_read+0xd0/0x184
[  117.542182]      do_splice_to+0x90/0xe0
[  117.542611]      splice_direct_to_actor+0xb8/0x250
[  117.543097]      do_splice_direct+0x88/0xd4
[  117.543544]      do_sendfile+0x2b0/0x344
[  117.543983]      __arm64_sys_sendfile64+0x164/0x16c
[  117.544471]      invoke_syscall+0x48/0x114
[  117.544917]      el0_svc_common.constprop.0+0x44/0xec
[  117.545416]      do_el0_svc+0x74/0x90
[  117.554100] kmemleak: Automatic memory scanning thread ended

[akpm@linux-foundation.org: whitespace tweak]
Link: https://lkml.kernel.org/r/20211118054426.4123-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/mm/kmemleak.c~kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable
+++ a/mm/kmemleak.c
@@ -381,15 +381,20 @@ static void dump_object_info(struct kmem
 static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 {
 	struct rb_node *rb = object_tree_root.rb_node;
+	unsigned long untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 
 	while (rb) {
-		struct kmemleak_object *object =
-			rb_entry(rb, struct kmemleak_object, rb_node);
-		if (ptr < object->pointer)
+		struct kmemleak_object *object;
+		unsigned long untagged_objp;
+
+		object = rb_entry(rb, struct kmemleak_object, rb_node);
+		untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
+
+		if (untagged_ptr < untagged_objp)
 			rb = object->rb_node.rb_left;
-		else if (object->pointer + object->size <= ptr)
+		else if (untagged_objp + object->size <= untagged_ptr)
 			rb = object->rb_node.rb_right;
-		else if (object->pointer == ptr || alias)
+		else if (untagged_objp == untagged_ptr || alias)
 			return object;
 		else {
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
@@ -576,6 +581,7 @@ static struct kmemleak_object *create_ob
 	struct kmemleak_object *object, *parent;
 	struct rb_node **link, *rb_parent;
 	unsigned long untagged_ptr;
+	unsigned long untagged_objp;
 
 	object = mem_pool_alloc(gfp);
 	if (!object) {
@@ -629,9 +635,10 @@ static struct kmemleak_object *create_ob
 	while (*link) {
 		rb_parent = *link;
 		parent = rb_entry(rb_parent, struct kmemleak_object, rb_node);
-		if (ptr + size <= parent->pointer)
+		untagged_objp = (unsigned long)kasan_reset_tag((void *)parent->pointer);
+		if (untagged_ptr + size <= untagged_objp)
 			link = &parent->rb_node.rb_left;
-		else if (parent->pointer + parent->size <= ptr)
+		else if (untagged_objp + parent->size <= untagged_ptr)
 			link = &parent->rb_node.rb_right;
 		else {
 			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


