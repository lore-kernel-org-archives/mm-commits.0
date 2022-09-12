Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3A2C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiILD3b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3426E27B38
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84D36113D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD50C433B5;
        Mon, 12 Sep 2022 03:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953323;
        bh=76DteLevHD+5Spk/6xpaQNTepS8snPMitYbrEuGQRO4=;
        h=Date:To:From:Subject:From;
        b=FpDUDsqfHFhHkE7qZom7bJKUcmWCeImejhQApFy1wgaMwB56uW94fz2Y8Z75hxjQk
         tGuUDPb2k3JlwrA5nrKN7wEqP5A/LjztAcsEG1jm4A1Nh7x/RNofwPCNZrscvzD+Dc
         cvUpwkN5wVQenuLMd73Pub9pQ8TVof7VDuubrQhI=
Date:   Sun, 11 Sep 2022 20:28:42 -0700
To:     mm-commits@vger.kernel.org, kunyu@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] page_alloc-remove-inactive-initialization.patch removed from -mm tree
Message-Id: <20220912032843.0AD50C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page_alloc: remove inactive initialization
has been removed from the -mm tree.  Its filename was
     page_alloc-remove-inactive-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li kunyu <kunyu@nfschina.com>
Subject: page_alloc: remove inactive initialization
Date: Wed, 3 Aug 2022 14:41:18 +0800

The allocation address of the table pointer variable is first performed in
the function, no initialization assignment is required, and no invalid
pointer will appear.

Link: https://lkml.kernel.org/r/20220803064118.3664-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~page_alloc-remove-inactive-initialization
+++ a/mm/page_alloc.c
@@ -8974,7 +8974,7 @@ void *__init alloc_large_system_hash(con
 {
 	unsigned long long max = high_limit;
 	unsigned long log2qty, size;
-	void *table = NULL;
+	void *table;
 	gfp_t gfp_flags;
 	bool virt;
 	bool huge;
_

Patches currently in -mm which might be from kunyu@nfschina.com are


