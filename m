Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3803DC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbjDFCpN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbjDFCoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86A93C3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65756421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3DDC4339B;
        Thu,  6 Apr 2023 02:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749077;
        bh=GkDJNbA29R5rL3plMGgIIQJR1PHZ5N7v+Y/StLTRVZk=;
        h=Date:To:From:Subject:From;
        b=rSF2z1gqM/R+k2lnTVlPZ5mLpeIaXp7h7eZPR4bi1qt39g2kiDsAEMhsVQTJi/9rb
         yZ6MawXZS72fPWWt/13yHsWLgzzvpF5H13t37ZScfQHNNR6YuCRu1C5e0k9DQmSjwF
         brTwxiFu94pVOWybffCB+xwvFcFS625ieKhvpqrE=
Date:   Wed, 05 Apr 2023 19:44:36 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, penberg@kernel.org,
        cl@linux.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slub-fix-max_order-usage-in-calculate_order.patch removed from -mm tree
Message-Id: <20230406024437.4C3DDC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/slub: fix MAX_ORDER usage in calculate_order()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-max_order-usage-in-calculate_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/slub: fix MAX_ORDER usage in calculate_order()
Date: Wed, 15 Mar 2023 14:31:31 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in calculate_order().

Link: https://lkml.kernel.org/r/20230315113133.11326-9-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-max_order-usage-in-calculate_order
+++ a/mm/slub.c
@@ -4171,7 +4171,7 @@ static inline int calculate_order(unsign
 	/*
 	 * Doh this slab cannot be placed using slub_max_order.
 	 */
-	order = calc_slab_order(size, 1, MAX_ORDER, 1);
+	order = calc_slab_order(size, 1, MAX_ORDER - 1, 1);
 	if (order < MAX_ORDER)
 		return order;
 	return -ENOSYS;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


