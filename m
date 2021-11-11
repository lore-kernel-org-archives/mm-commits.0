Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087D7C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E702161284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhKKCt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhKKCt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A6A76113B;
        Thu, 11 Nov 2021 02:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598827;
        bh=W6jrBTdgL1bnFj0Piq1aR/9juVrrwT/0pt+9FxCCmsY=;
        h=Date:From:To:Subject:From;
        b=zKxoiQmnbHJBTnmCl8VTVp6mJfl0Zpisl8lbZarkVg2i2UVYedWltbNKEp0jEMAfB
         nREpKKvwdNrxT6hT4hTXMdZKULowR7L2I7Cor1KKTG9JgBabz1ozpdxhnZtDhpm5bt
         othnz9JmJBexGdlWRBYRj8lYpbv5BT9UtUiRPnOs=
Date:   Wed, 10 Nov 2021 18:47:07 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tangyizhou@huawei.com
Subject:  [merged]
 mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch
 removed from -mm tree
Message-ID: <20211111024707.NlmyNUFRy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: add static qualifier for online_policy_to_str()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm/memory_hotplug: add static qualifier for online_policy_to_str()

online_policy_to_str is only used in memory_hotplug.c and should be
defined as static.

Link: https://lkml.kernel.org/r/20210913024534.26161-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str
+++ a/mm/memory_hotplug.c
@@ -57,7 +57,7 @@ enum {
 	ONLINE_POLICY_AUTO_MOVABLE,
 };
 
-const char *online_policy_to_str[] = {
+static const char * const online_policy_to_str[] = {
 	[ONLINE_POLICY_CONTIG_ZONES] = "contig-zones",
 	[ONLINE_POLICY_AUTO_MOVABLE] = "auto-movable",
 };
_

Patches currently in -mm which might be from tangyizhou@huawei.com are


