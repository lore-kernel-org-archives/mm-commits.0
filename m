Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF79C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 00:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhLNAF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 19:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhLNAF4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 19:05:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1664BC061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 16:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5EBA612D3
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 00:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE127C34600;
        Tue, 14 Dec 2021 00:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639440355;
        bh=1T+TNzGbznSjutbPLvxfqpXUomQ83eIpM/XoOE35Ldc=;
        h=Date:From:To:Subject:From;
        b=O5KPZzzA7JvQlKH7AK1uP+9nulhDNbYV+kOn5yk0Aq9Qt28D1ReuLJKV8tFECagLG
         KPeGpIky8tgvxX18ykymcjVC91p1bU5RoGc1UQoZ/+OzWjabAbOfByaTPtMbMHDopV
         MR2YAe3MZvpSJPTkfCyXPK33WXYIZcpLeQm++3SI=
Date:   Mon, 13 Dec 2021 16:05:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + mm-mempolicy-fix-all-kernel-doc-warnings.patch added to
 -mm tree
Message-ID: <20211214000554.UY4a_WEQH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix all kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-all-kernel-doc-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-all-kernel-doc-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-all-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-mark-more-list-instances-as-moderated.patch
mm-mempolicy-fix-all-kernel-doc-warnings.patch

