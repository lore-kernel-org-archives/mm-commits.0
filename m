Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3866BC00140
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244511AbiHIBOS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiHIBOR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA6E18362
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4A16116C
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCCEC433B5;
        Tue,  9 Aug 2022 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007655;
        bh=dEnzJAEIHt0g8epSnE0UwdwjQjN7cOiEceMUXPBWI3c=;
        h=Date:To:From:Subject:From;
        b=tEQ1avTZL6NPT/GR5K8/+gEYs06hGBHJsOuqdYcApclQbKHMgzBsvGWAcbN7uCeQD
         WJf7iT3fwdOurgom8RLBdn0IeYTqWDwI0feLRDn2iEMW96nZxq0PV/h1fGgJLegsow
         2txvl2QkyeIbHE6rNLLXlalztss66tguB3nB7kAQ=
Date:   Mon, 08 Aug 2022 18:14:14 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch removed from -mm tree
Message-Id: <20220809011415.7FCCEC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: optimize vmemmap_optimize_mode handling
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: optimize vmemmap_optimize_mode handling
Date: Tue, 28 Jun 2022 17:22:29 +0800

We hold an another reference to hugetlb_optimize_vmemmap_key when making
vmemmap_optimize_mode on, because we use static_key to tell memory_hotplug
that memory_hotplug.memmap_on_memory should be overridden.  However, this
rule has gone when we have introduced PageVmemmapSelfHosted.  Therefore,
we could simplify vmemmap_optimize_mode handling by not holding an another
reference to hugetlb_optimize_vmemmap_key.  This also means that we not
incur the extra page_fixed_fake_head checks if there are no vmemmap
optinmized hugetlb pages after this change.

Link: https://lkml.kernel.org/r/20220628092235.91270-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +--
 mm/hugetlb_vmemmap.c       |   65 +++--------------------------------
 2 files changed, 9 insertions(+), 62 deletions(-)

--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling
+++ a/include/linux/page-flags.h
@@ -205,8 +205,7 @@ enum pageflags {
 #ifndef __GENERATING_BOUNDS_H
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
-			 hugetlb_optimize_vmemmap_key);
+DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
 /*
  * If the feature of optimizing vmemmap pages associated with each HugeTLB
@@ -226,8 +225,7 @@ DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
-	if (!static_branch_maybe(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
-				 &hugetlb_optimize_vmemmap_key))
+	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return page;
 
 	/*
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling
+++ a/mm/hugetlb_vmemmap.c
@@ -23,42 +23,15 @@
 #define RESERVE_VMEMMAP_NR		1U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
-enum vmemmap_optimize_mode {
-	VMEMMAP_OPTIMIZE_OFF,
-	VMEMMAP_OPTIMIZE_ON,
-};
-
-DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
-			hugetlb_optimize_vmemmap_key);
+DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
-static enum vmemmap_optimize_mode vmemmap_optimize_mode =
+static bool vmemmap_optimize_enabled =
 	IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 
-static void vmemmap_optimize_mode_switch(enum vmemmap_optimize_mode to)
-{
-	if (vmemmap_optimize_mode == to)
-		return;
-
-	if (to == VMEMMAP_OPTIMIZE_OFF)
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	else
-		static_branch_inc(&hugetlb_optimize_vmemmap_key);
-	WRITE_ONCE(vmemmap_optimize_mode, to);
-}
-
 static int __init hugetlb_vmemmap_early_param(char *buf)
 {
-	bool enable;
-	enum vmemmap_optimize_mode mode;
-
-	if (kstrtobool(buf, &enable))
-		return -EINVAL;
-
-	mode = enable ? VMEMMAP_OPTIMIZE_ON : VMEMMAP_OPTIMIZE_OFF;
-	vmemmap_optimize_mode_switch(mode);
-
-	return 0;
+	return kstrtobool(buf, &vmemmap_optimize_enabled);
 }
 early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_early_param);
 
@@ -100,7 +73,7 @@ int hugetlb_vmemmap_alloc(struct hstate
 static unsigned int vmemmap_optimizable_pages(struct hstate *h,
 					      struct page *head)
 {
-	if (READ_ONCE(vmemmap_optimize_mode) == VMEMMAP_OPTIMIZE_OFF)
+	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return 0;
 
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG)) {
@@ -191,7 +164,6 @@ void __init hugetlb_vmemmap_init(struct
 
 	if (!is_power_of_2(sizeof(struct page))) {
 		pr_warn_once("cannot optimize vmemmap pages because \"struct page\" crosses page boundaries\n");
-		static_branch_disable(&hugetlb_optimize_vmemmap_key);
 		return;
 	}
 
@@ -212,36 +184,13 @@ void __init hugetlb_vmemmap_init(struct
 }
 
 #ifdef CONFIG_PROC_SYSCTL
-static int hugetlb_optimize_vmemmap_handler(struct ctl_table *table, int write,
-					    void *buffer, size_t *length,
-					    loff_t *ppos)
-{
-	int ret;
-	enum vmemmap_optimize_mode mode;
-	static DEFINE_MUTEX(sysctl_mutex);
-
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	mutex_lock(&sysctl_mutex);
-	mode = vmemmap_optimize_mode;
-	table->data = &mode;
-	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (write && !ret)
-		vmemmap_optimize_mode_switch(mode);
-	mutex_unlock(&sysctl_mutex);
-
-	return ret;
-}
-
 static struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
 		.procname	= "hugetlb_optimize_vmemmap",
-		.maxlen		= sizeof(enum vmemmap_optimize_mode),
+		.data		= &vmemmap_optimize_enabled,
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= hugetlb_optimize_vmemmap_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= proc_dobool,
 	},
 	{ }
 };
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


