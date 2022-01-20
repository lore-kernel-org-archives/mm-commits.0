Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C2FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377866AbiATV1U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377882AbiATV1R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C8EC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D3460A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F97C340E0;
        Thu, 20 Jan 2022 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714036;
        bh=eSQUaF9VTtMXSNRE/l3/eLSUpRlVJjYWi2jm259whlY=;
        h=Date:From:To:Subject:From;
        b=qU97US5zMBegSD+0nmmVKi+kdllCKH6xsP9s7qMjSVhoqnfrNN3uinclN27JwDgJ/
         hTp47zEia8695t1H6Pe0iqI3HMiK8Hjl9HyIChI17TNGeGkWSzmvLQd53ejqnze5cg
         ETOASmjxNW9/+2orpRvdyjAXIpTjQ87lCm2ISONA=
Date:   Thu, 20 Jan 2022 13:27:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] mm-mempolicy-fix-all-kernel-doc-warnings.patch
 removed from -mm tree
Message-ID: <20220120212716.LFmM2PxOm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix all kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-all-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/mempolicy: fix all kernel-doc warnings

Fix kernel-doc warnings in mempolicy.c:

mempolicy.c:139: warning: No description found for return value of 'numa_map_to_online_node'
mempolicy.c:2165: warning: Excess function parameter 'node' description in 'alloc_pages_vma'
mempolicy.c:2973: warning: No description found for return value of 'mpol_parse_str'

Link: https://lkml.kernel.org/r/20211213233216.5477-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-all-kernel-doc-warnings
+++ a/mm/mempolicy.c
@@ -134,6 +134,8 @@ static struct mempolicy preferred_node_p
  * @node: Node id to start the search
  *
  * Lookup the next closest node by distance if @nid is not online.
+ *
+ * Return: this @node if it is online, otherwise the closest node by distance
  */
 int numa_map_to_online_node(int node)
 {
@@ -2150,7 +2152,6 @@ static struct page *alloc_pages_preferre
  * @order: Order of the GFP allocation.
  * @vma: Pointer to VMA or NULL if not available.
  * @addr: Virtual address of the allocation.  Must be inside @vma.
- * @node: Which node to prefer for allocation (modulo policy).
  * @hugepage: For hugepages try only the preferred node if possible.
  *
  * Allocate a page for a specific address in @vma, using the appropriate
@@ -2966,7 +2967,7 @@ static const char * const policy_modes[]
  * Format of input:
  *	<mode>[=<flags>][:<nodelist>]
  *
- * On success, returns 0, else 1
+ * Return: %0 on success, else %1
  */
 int mpol_parse_str(char *str, struct mempolicy **mpol)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

sysctl-documentation-fix-table-format-warning.patch

