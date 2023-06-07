Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D45AC77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 19:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjFGTIZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjFGTIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 15:08:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806021721
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 12:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04028642FC
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 19:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A322C433D2;
        Wed,  7 Jun 2023 19:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686164897;
        bh=G6MfHCEytSE1eN89fep9QtepoajtYNu+JuigNiXv164=;
        h=Date:To:From:Subject:From;
        b=guvaGI1TnEKAtmo2eFrq8okT6Zfyud9z/wcMX9mtiXlzNgFr753CZAjINhGp8GRfb
         an+PPunstOQ28/26WvSlZAGmwLgrF1uhRX4BqNNkW/FzdVvZQB+exmvuYWHAUGqhxr
         hJ7apmCL9K3UtNoO39PilS9t8KV1sb8WJ83If35c=
Date:   Wed, 07 Jun 2023 12:08:16 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        lkp@intel.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch removed from -mm tree
Message-Id: <20230607190817.5A322C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix
has been removed from the -mm tree.  Its filename was
     zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch

This patch was dropped because it was folded into zswap-do-not-shrink-if-cgroup-may-not-zswap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix
Date: Thu Jun  1 01:46:19 PM PDT 2023

s/ENOSPC/ENOMEM/

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix
+++ a/mm/zswap.c
@@ -1181,7 +1181,7 @@ static int zswap_frontswap_store(unsigne
 	 */
 	objcg = get_obj_cgroup_from_page(page);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
-		ret = -ENOSPC;
+		ret = -ENOMEM;
 		goto reject;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

