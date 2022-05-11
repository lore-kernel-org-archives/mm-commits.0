Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E074C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 19:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346780AbiEKT0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 15:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346776AbiEKT02 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 15:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA224F30
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 12:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9D1C61689
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FC6C340EE;
        Wed, 11 May 2022 19:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652297181;
        bh=rZaC0s3/RTVC+96cC3O86V8AhHKb9H/e1DR41lb20qQ=;
        h=Date:To:From:Subject:From;
        b=1dhV267pCipnCD0ozIZBtTySG79/GSGnTAV0NvVmkiDlJC3bXnTzwTy+bQmu/MPAx
         oUK/hamwYWG1EjhjSHL+/oarvkm+1I+bzBVxFLosML19wLvDS/qRFi5zjXVz6W3JJc
         MTJ9ILVeS9f858+5PPB5F9iXN/a6C3swpqRySR0E=
Date:   Wed, 11 May 2022 12:26:20 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, sfr@canb.auug.org.au, minchan@kernel.org,
        mhocko@suse.com, lkp@intel.com, hannes@cmpxchg.org, guro@fb.com,
        ddstreet@ieee.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zswap-memcg-accounting-fix.patch removed from -mm tree
Message-Id: <20220511192621.12FC6C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap-memcg-accounting-fix
has been removed from the -mm tree.  Its filename was
     zswap-memcg-accounting-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-memcg-accounting-fix

fix build

Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~zswap-memcg-accounting-fix
+++ a/mm/memcontrol.c
@@ -7451,7 +7451,7 @@ static struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 /**
  * obj_cgroup_may_zswap - check if this cgroup can zswap
  * @objcg: the object cgroup
@@ -7582,7 +7582,7 @@ static struct cftype zswap_files[] = {
 	},
 	{ }	/* terminate */
 };
-#endif /* CONFIG_ZSWAP */
+#endif /* CONFIG_MEMCG_KMEM && CONFIG_ZSWAP */
 
 /*
  * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
@@ -7602,7 +7602,7 @@ static int __init mem_cgroup_swap_init(v
 
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, zswap_files));
 #endif
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

