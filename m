Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421C4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A9461A8E
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhKRVtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:49:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhKRVtl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:49:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FA561A8A;
        Thu, 18 Nov 2021 21:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637272001;
        bh=3wiFFG/kXj0Apzt8n0yNCd6B5yMkjZYP7isp2U7o4pk=;
        h=Date:From:To:Subject:From;
        b=bRq1wJtRi+Fx5aPoI0Hs35AQJ0qAhamgjTHvMBVuUxBWVdRlzyyWmZVor2vDCeCoE
         52NaupkQ3Vh9cYzY8OXz06fnfdlzgOZurgbrdbFdKTFhCIOnXWpBenSlMYYxnsK6Fh
         WpCfUfbOCLw7bHHNXaZPEScqv8gMAr1n63mDoh/Y=
Date:   Thu, 18 Nov 2021 13:46:40 -0800
From:   akpm@linux-foundation.org
To:     Kuan-Ying.Lee@mediatek.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, opendmb@gmail.com,
        peterz@infradead.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-base?=
 =?US-ASCII?Q?d-kasan-enable.patch?= added to -mm tree
Message-ID: <20211118214640.vMY7V9tJn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: fix kmemleak false positive report with HW tag-based kasan enable
has been added to the -mm tree.  Its filename is
     kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kfree(page_address(page));
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

Link: https://lkml.kernel.org/r/20211118054426.4123-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable
+++ a/mm/kmemleak.c
@@ -381,15 +381,20 @@ static void dump_object_info(struct kmem
 static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 {
 	struct rb_node *rb = object_tree_root.rb_node;
+	unsigned long untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 
 	while (rb) {
 		struct kmemleak_object *object =
 			rb_entry(rb, struct kmemleak_object, rb_node);
-		if (ptr < object->pointer)
+		unsigned long untagged_objp;
+
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

kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable.patch

