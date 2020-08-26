Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF04C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A49206F0
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598400910;
	bh=nCPx5esdOo0BbNy+40YxoF3a2+yVmmzMz7ru1wqi8q8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QK59sYsZx+m3WhqlK5CzZUiwy0qJ0L+7UWY34HULNvBiKLU6AbQA5fzIAwnQ8x6Cd
	 yEZOQLzvJxGuVzBGpSf08ZQwpV9AQ5QI1G1/Mu4TwW58cjWtOQZTgAdBU69NJEFv/Z
	 1IpY7daFEEQq3/fqdyyQOqG6n0zMaI1bzPhYtCr8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgHZAPK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHZAPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:15:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E1C206F0;
        Wed, 26 Aug 2020 00:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598400908;
        bh=nCPx5esdOo0BbNy+40YxoF3a2+yVmmzMz7ru1wqi8q8=;
        h=Date:From:To:Subject:From;
        b=CI9bfHOAUpP+sDCOJtVa0R6AoVjCNdWrjXo9S0gLxfczRqfGEsYgeqh2MXAIYiILL
         j5nyuPNwdqDTwrLkjjPN/qtEIUL0e94sfIHJXA+IjwoOCTKO1PSwCGgiFa9t34O1as
         Vm5dFeEsCE+pFgOT+XnK1nA2XwJi/HqBgb4Q5as4=
Date:   Tue, 25 Aug 2020 17:15:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        joao.m.martins@oracle.com, lkp@intel.com,
        mm-commits@vger.kernel.org, vishal.l.verma@intel.com
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-introduce-default-phys=5Fto=5Ftarget=5Fn?=
 =?US-ASCII?Q?ode-implementation-fix.patch?= added to -mm tree
Message-ID: <20200826001507.ViCJxK7fC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix

fix CONFIG_MEMORY_HOTPLUG=n build

Link: https://lkml.kernel.org/r/202008252130.7YrHIyMI%25lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix
+++ a/include/linux/memory_hotplug.h
@@ -149,20 +149,6 @@ int add_pages(int nid, unsigned long sta
 	      struct mhp_params *params);
 #endif /* ARCH_HAS_ADD_PAGES */
 
-#ifdef CONFIG_NUMA
-extern int memory_add_physaddr_to_nid(u64 start);
-extern int phys_to_target_node(u64 start);
-#else
-static inline int memory_add_physaddr_to_nid(u64 start)
-{
-	return 0;
-}
-static inline int phys_to_target_node(u64 start)
-{
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
 /*
  * For supporting node-hotadd, we have to allocate a new pgdat.
@@ -289,6 +275,20 @@ static inline bool movable_node_is_enabl
 }
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_NUMA
+extern int memory_add_physaddr_to_nid(u64 start);
+extern int phys_to_target_node(u64 start);
+#else
+static inline int memory_add_physaddr_to_nid(u64 start)
+{
+	return 0;
+}
+static inline int phys_to_target_node(u64 start)
+{
+	return 0;
+}
+#endif
+
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 /*
  * pgdat resizing functions
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

