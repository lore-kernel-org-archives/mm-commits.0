Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15635C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiANWIb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60182 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiANWI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8DE4B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FD4C36AE9;
        Fri, 14 Jan 2022 22:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198105;
        bh=v6vpo38FPm930nZRXR76SyfDcmtpeF2iC8fXDHHjDGc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GML2lh0QuUQYJp2Q0BosyKpG3llyvdbbRKrqzsd3GJtrqGcKIwQPbT4H0HjxWgXd7
         a88ss1+sJnILLJdHNn0tnQpEj1OPXQnIV4Qv6UCKbjfPl7H8xt1DAH8vAuTEKQaZ8K
         /C6+V+Y6Uku/Dxzu0N5173/FiwesVCXKls2nMi2s=
Date:   Fri, 14 Jan 2022 14:08:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 099/146] mm/mempolicy: fix all kernel-doc warnings
Message-ID: <20220114220824.z6HclrP9P%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
