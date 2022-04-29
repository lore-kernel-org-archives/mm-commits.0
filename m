Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C039C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379275AbiD2Qtu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379277AbiD2Qtt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF14D557D
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B9F662380
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC9BC385AE;
        Fri, 29 Apr 2022 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651250789;
        bh=wBVwVqxMUk2rWVmm/Xuks70q3p3+7ePAP32xFzEKd2E=;
        h=Date:To:From:Subject:From;
        b=ILb1zMXQZaP+jia6XoXfu85I+/ODvIMMgDP+r2fxtu8pEe4atUAk+zgBAh7hXrW/h
         UnZiZ7ogrj+ilZrjog+K9S9Y9VknMsyGrZOHwHQ7OQHXa7Q9aBcPclP9oQt9Q1VjLu
         T+lcQPFo0/gGrvWumjNNPX83AmVbh3OMeneHJlf8=
Date:   Fri, 29 Apr 2022 09:46:28 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mcgrof@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch added to mm-unstable branch
Message-Id: <20220429164628.DEC9BC385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: override memmap_on_memory when hugetlb_free_vmemmap=on
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch

This patch should soon appear in the mm-unstable branch at
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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: override memmap_on_memory when hugetlb_free_vmemmap=on

When "hugetlb_free_vmemmap=on" and "memory_hotplug.memmap_on_memory" are
both passed to boot cmdline, the variable of "memmap_on_memory" will be
set to 1 even if the vmemmap pages will not be allocated from the hotadded
memory since the former takes precedence over the latter.  In the next
patch, we want to enable or disable the feature of freeing vmemmap pages
of HugeTLB via sysctl.  We need a way to know if the feature of
memory_hotplug.memmap_on_memory is enabled when enabling the feature of
freeing vmemmap pages since those two features are not compatible,
however, the variable of "memmap_on_memory" cannot indicate this nowadays.
Do not set "memmap_on_memory" to 1 when both parameters are passed to
cmdline, in this case, "memmap_on_memory" could indicate if this feature
is enabled by the users.

Also introduce mhp_memmap_on_memory() helper to move the definition of
"memmap_on_memory" to the scope of CONFIG_MHP_MEMMAP_ON_MEMORY.  In the
next patch, mhp_memmap_on_memory() will also be exported to be used in
hugetlb_vmemmap.c.

Link: https://lkml.kernel.org/r/20220429121816.37541-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

