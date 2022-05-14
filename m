Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11215C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiENTzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiENTzY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4BB377F1
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85E1561150
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD303C340EE;
        Sat, 14 May 2022 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558123;
        bh=VFcFiuUBYt4CpO1ycmU2ummmmmQjCCPoinp0uEuQn6I=;
        h=Date:To:From:Subject:From;
        b=LkbIbG+XnCQIpx3odDiSfchtPNq9r3hr12NZ3F76bSGHLU5hrSRgoa9i+TiZjurO9
         dToGLNIWp9WWTat4UPirPkV6TjqUvqkpmtSggcot7XiQhHq4ohMYnnn+ddh8RRffQp
         dQd0huxvAg6NLth52asrmq7VKpBZizYeddt28zFM=
Date:   Sat, 14 May 2022 12:55:22 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mcgrof@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch removed from -mm tree
Message-Id: <20220514195522.DD303C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory_hotplug: override memmap_on_memory when hugetlb_free_vmemmap=on
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: override memmap_on_memory when hugetlb_free_vmemmap=on

Optimizing HugeTLB vmemmap pages is not compatible with allocating memmap
on hot added memory.  If "hugetlb_free_vmemmap=on" and
memory_hotplug.memmap_on_memory" are both passed on the kernel command
line, optimizing hugetlb pages takes precedence.  However, the global
variable memmap_on_memory will still be set to 1, even though we will not
try to allocate memmap on hot added memory.

Also introduce mhp_memmap_on_memory() helper to move the definition of
"memmap_on_memory" to the scope of CONFIG_MHP_MEMMAP_ON_MEMORY.  In the
next patch, mhp_memmap_on_memory() will also be exported to be used in
hugetlb_vmemmap.c.

Link: https://lkml.kernel.org/r/20220512041142.39501-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on
+++ a/mm/memory_hotplug.c
@@ -42,14 +42,36 @@
 #include "internal.h"
 #include "shuffle.h"
 
+#ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
+static int memmap_on_memory_set(const char *val, const struct kernel_param *kp)
+{
+	if (hugetlb_optimize_vmemmap_enabled())
+		return 0;
+	return param_set_bool(val, kp);
+}
+
+static const struct kernel_param_ops memmap_on_memory_ops = {
+	.flags	= KERNEL_PARAM_OPS_FL_NOARG,
+	.set	= memmap_on_memory_set,
+	.get	= param_get_bool,
+};
 
 /*
  * memory_hotplug.memmap_on_memory parameter
  */
 static bool memmap_on_memory __ro_after_init;
-#ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
-module_param(memmap_on_memory, bool, 0444);
+module_param_cb(memmap_on_memory, &memmap_on_memory_ops, &memmap_on_memory, 0444);
 MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug");
+
+static inline bool mhp_memmap_on_memory(void)
+{
+	return memmap_on_memory;
+}
+#else
+static inline bool mhp_memmap_on_memory(void)
+{
+	return false;
+}
 #endif
 
 enum {
@@ -1289,9 +1311,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 *       altmap as an alternative source of memory, and we do not exactly
 	 *       populate a single PMD.
 	 */
-	return memmap_on_memory &&
-	       !hugetlb_optimize_vmemmap_enabled() &&
-	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
+	return mhp_memmap_on_memory() &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
 	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
@@ -2076,7 +2096,7 @@ static int __ref try_remove_memory(u64 s
 	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
 	 * the same granularity it was added - a single memory block.
 	 */
-	if (memmap_on_memory) {
+	if (mhp_memmap_on_memory()) {
 		nr_vmemmap_pages = walk_memory_blocks(start, size, NULL,
 						      get_nr_vmemmap_pages_cb);
 		if (nr_vmemmap_pages) {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


