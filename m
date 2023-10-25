Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BD6C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjJYXuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjJYXsz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1E41AC
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194B1C433C8;
        Wed, 25 Oct 2023 23:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277733;
        bh=7quDETlaKNpp1CXzM5EJkpwztcLHBHdqQvkIT9NlKBA=;
        h=Date:To:From:Subject:From;
        b=x9EA9jlo56UJhnwHXES0/5tw0vSJSV5NZQ+okFIcJ8l8Ja40WaaRPq/WDCCZP43fr
         QkZr6vvaiN6fjrHkej2AYqB01ab/ec27U2rcN7MaiSqgyZjBrPBED9ju9n9225oJ/V
         lgcBNC/k8ipVXuRQUhh7xAV4lfanELPSN5+Fz8RY=
Date:   Wed, 25 Oct 2023 16:48:52 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch removed from -mm tree
Message-Id: <20231025234853.194B1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: fix print format of pointer in pr_debug()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/kmemleak: fix print format of pointer in pr_debug()
Date: Wed, 18 Oct 2023 18:29:48 +0800

With 0x%p, the pointer will be hashed and print (____ptrval____) instead. 
And with 0x%pa, the pointer can be successfully printed but with duplicate
prefixes, which looks like:

 kmemleak: kmemleak_free(0x(____ptrval____))
 kmemleak: kmemleak_free_percpu(0x(____ptrval____))
 kmemleak: kmemleak_free_part_phys(0x0x0000000a1af86000)

Use 0x%px instead of 0x%p or 0x%pa to print the pointer. Then the print
will be like:

 kmemleak: kmemleak_free(0xffff9111c145b020)
 kmemleak: kmemleak_free_percpu(0x00000000000333b0)
 kmemleak: kmemleak_free_part_phys(0x0000000a1af80000)

Link: https://lkml.kernel.org/r/20231018102952.3339837-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-print-format-of-pointer-in-pr_debug
+++ a/mm/kmemleak.c
@@ -975,7 +975,7 @@ static void object_no_scan(unsigned long
 void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 			  gfp_t gfp)
 {
-	pr_debug("%s(0x%p, %zu, %d)\n", __func__, ptr, size, min_count);
+	pr_debug("%s(0x%px, %zu, %d)\n", __func__, ptr, size, min_count);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		create_object((unsigned long)ptr, size, min_count, gfp);
@@ -996,7 +996,7 @@ void __ref kmemleak_alloc_percpu(const v
 {
 	unsigned int cpu;
 
-	pr_debug("%s(0x%p, %zu)\n", __func__, ptr, size);
+	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
 	/*
 	 * Percpu allocations are only scanned and not reported as leaks
@@ -1020,7 +1020,7 @@ EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu)
  */
 void __ref kmemleak_vmalloc(const struct vm_struct *area, size_t size, gfp_t gfp)
 {
-	pr_debug("%s(0x%p, %zu)\n", __func__, area, size);
+	pr_debug("%s(0x%px, %zu)\n", __func__, area, size);
 
 	/*
 	 * A min_count = 2 is needed because vm_struct contains a reference to
@@ -1043,7 +1043,7 @@ EXPORT_SYMBOL_GPL(kmemleak_vmalloc);
  */
 void __ref kmemleak_free(const void *ptr)
 {
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
 		delete_object_full((unsigned long)ptr);
@@ -1061,7 +1061,7 @@ EXPORT_SYMBOL_GPL(kmemleak_free);
  */
 void __ref kmemleak_free_part(const void *ptr, size_t size)
 {
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		delete_object_part((unsigned long)ptr, size, false);
@@ -1079,7 +1079,7 @@ void __ref kmemleak_free_percpu(const vo
 {
 	unsigned int cpu;
 
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
 		for_each_possible_cpu(cpu)
@@ -1100,7 +1100,7 @@ void __ref kmemleak_update_trace(const v
 	struct kmemleak_object *object;
 	unsigned long flags;
 
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (!kmemleak_enabled || IS_ERR_OR_NULL(ptr))
 		return;
@@ -1131,7 +1131,7 @@ EXPORT_SYMBOL(kmemleak_update_trace);
  */
 void __ref kmemleak_not_leak(const void *ptr)
 {
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		make_gray_object((unsigned long)ptr);
@@ -1149,7 +1149,7 @@ EXPORT_SYMBOL(kmemleak_not_leak);
  */
 void __ref kmemleak_ignore(const void *ptr)
 {
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		make_black_object((unsigned long)ptr, false);
@@ -1169,7 +1169,7 @@ EXPORT_SYMBOL(kmemleak_ignore);
  */
 void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && size && !IS_ERR(ptr))
 		add_scan_area((unsigned long)ptr, size, gfp);
@@ -1187,7 +1187,7 @@ EXPORT_SYMBOL(kmemleak_scan_area);
  */
 void __ref kmemleak_no_scan(const void *ptr)
 {
-	pr_debug("%s(0x%p)\n", __func__, ptr);
+	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		object_no_scan((unsigned long)ptr);
@@ -1203,7 +1203,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
  */
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, gfp_t gfp)
 {
-	pr_debug("%s(0x%pa, %zu)\n", __func__, &phys, size);
+	pr_debug("%s(0x%px, %zu)\n", __func__, &phys, size);
 
 	if (kmemleak_enabled)
 		/*
@@ -1223,7 +1223,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	pr_debug("%s(0x%pa)\n", __func__, &phys);
+	pr_debug("%s(0x%px)\n", __func__, &phys);
 
 	if (kmemleak_enabled)
 		delete_object_part((unsigned long)phys, size, true);
@@ -1237,7 +1237,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	pr_debug("%s(0x%pa)\n", __func__, &phys);
+	pr_debug("%s(0x%px)\n", __func__, &phys);
 
 	if (kmemleak_enabled)
 		make_black_object((unsigned long)phys, true);
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

