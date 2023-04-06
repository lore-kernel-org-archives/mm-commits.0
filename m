Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EABC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbjDFCrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbjDFCpT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B89993F3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B283642A8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB776C433EF;
        Thu,  6 Apr 2023 02:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749112;
        bh=Rz7+bejoQEtqrCELzAn3pM7rv8ttJA0cLJ74/uZ/+Wg=;
        h=Date:To:From:Subject:From;
        b=WCcXCS5lsqcHgarDEWyK7X/vZYfSpBzZl2v8zJ0hGr8MixA54yDWpxwAlO9zk1lRo
         xqgdoZjiCc3y+zfoN0jcD2MFUdsLc8bT0WvRuCFfYIohOasWOAFO0sIGlFSdJGPaa6
         p6SULmxBtVP3CM+1Zi8RhW4DiLtbjByvZKVd5jAY=
Date:   Wed, 05 Apr 2023 19:45:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-hashdist-initialization-in-mm-mm_initc.patch removed from -mm tree
Message-Id: <20230406024511.DB776C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle hashdist initialization in mm/mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-handle-hashdist-initialization-in-mm-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: handle hashdist initialization in mm/mm_init.c
Date: Tue, 21 Mar 2023 19:05:03 +0200

The hashdist variable must be initialized before the first call to
alloc_large_system_hash() and free_area_init() looks like a better place
for it than page_alloc_init().

Move hashdist handling to mm/mm_init.c

Link: https://lkml.kernel.org/r/20230321170513.2401534-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c    |   22 ++++++++++++++++++++++
 mm/page_alloc.c |   18 ------------------
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/mm/mm_init.c~mm-handle-hashdist-initialization-in-mm-mm_initc
+++ a/mm/mm_init.c
@@ -607,6 +607,25 @@ int __meminit early_pfn_to_nid(unsigned
 
 	return nid;
 }
+
+int hashdist = HASHDIST_DEFAULT;
+
+static int __init set_hashdist(char *str)
+{
+	if (!str)
+		return 0;
+	hashdist = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("hashdist=", set_hashdist);
+
+static inline void fixup_hashdist(void)
+{
+	if (num_node_state(N_MEMORY) == 1)
+		hashdist = 0;
+}
+#else
+static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -1855,6 +1874,9 @@ void __init free_area_init(unsigned long
 	}
 
 	memmap_init();
+
+	/* disable hash distribution for systems with a single node */
+	fixup_hashdist();
 }
 
 /**
--- a/mm/page_alloc.c~mm-handle-hashdist-initialization-in-mm-mm_initc
+++ a/mm/page_alloc.c
@@ -6393,28 +6393,10 @@ static int page_alloc_cpu_online(unsigne
 	return 0;
 }
 
-#ifdef CONFIG_NUMA
-int hashdist = HASHDIST_DEFAULT;
-
-static int __init set_hashdist(char *str)
-{
-	if (!str)
-		return 0;
-	hashdist = simple_strtoul(str, &str, 0);
-	return 1;
-}
-__setup("hashdist=", set_hashdist);
-#endif
-
 void __init page_alloc_init(void)
 {
 	int ret;
 
-#ifdef CONFIG_NUMA
-	if (num_node_state(N_MEMORY) == 1)
-		hashdist = 0;
-#endif
-
 	ret = cpuhp_setup_state_nocalls(CPUHP_PAGE_ALLOC,
 					"mm/page_alloc:pcp",
 					page_alloc_cpu_online,
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch

