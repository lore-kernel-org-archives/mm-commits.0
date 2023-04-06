Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAF2C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjDFCdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbjDFCdh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:33:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AA95BA0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2006362B47
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727C6C433EF;
        Thu,  6 Apr 2023 02:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748415;
        bh=FMPx3Cyd6xRmeNcXvEpQp/QiWDRRU6SmtZiyB6MrG2o=;
        h=Date:To:From:Subject:From;
        b=Gjh+QDCF/G8NRd71grCNwUQp9B7hzczSh+xKfDycs3sandKpoIv76Aysh6HpXPUy3
         QkSWcqgzNC/5nMCRfXnxdOmY3D7lSqhIk+YDGAwDsPDO/I47dUNxqW9j+2ZWBpTG3X
         c2JZldleBGQK4Co42xLWnO99A9ejzkvsyB3bRdV4=
Date:   Wed, 05 Apr 2023 19:33:34 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, lkp@intel.com,
        kirill@shutemov.name, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-treewide-redefine-max_order-sanely-fix-2.patch removed from -mm tree
Message-Id: <20230406023335.727C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-2
has been removed from the -mm tree.  Its filename was
     mm-treewide-redefine-max_order-sanely-fix-2.patch

This patch was dropped because it was folded into mm-treewide-redefine-max_order-sanely.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-treewide-redefine-max_order-sanely-fix-2
Date: Wed Mar 15 01:54:45 PM PDT 2023

fix another min_t warning

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: kernel test robot <lkp@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-treewide-redefine-max_order-sanely-fix-2
+++ a/mm/memory_hotplug.c
@@ -605,7 +605,7 @@ static void online_pages_range(unsigned
 	 * this and the first chunk to online will be pageblock_nr_pages.
 	 */
 	for (pfn = start_pfn; pfn < end_pfn;) {
-		int order = min(MAX_ORDER, __ffs(pfn));
+		int order = min_t(int, MAX_ORDER, __ffs(pfn));
 
 		(*online_page_callback)(pfn_to_page(pfn), order);
 		pfn += (1UL << order);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-treewide-redefine-max_order-sanely.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

