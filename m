Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FA0C77B73
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 18:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjDPSq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 14:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDPSq2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 14:46:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AE2173D
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 11:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 601B360F5A
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 18:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E2BC4339B;
        Sun, 16 Apr 2023 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681670786;
        bh=FyNXgf4ZZnDNSwf7s/vO2k3zXPblXqQQGLmGvgPPADw=;
        h=Date:To:From:Subject:From;
        b=Fa53DxcdXdpxWvyaWmvmYuOdxsq/ITp8BOw8x462ddj3Ce0teVDs+X6n48frUo+N6
         PZjoWjboISF4yMKdl/gQTcQY82nUUCQylSknrNMEXI5HGY8e2rLSQi4eHBvV4R+TDO
         6S0Ct7YUwXaxd8bV3QljLpAtQ0w8LLw0eXhdhwIw=
Date:   Sun, 16 Apr 2023 11:46:26 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-truncate-remove-redundant-initialization-of-new_order.patch removed from -mm tree
Message-Id: <20230416184626.B0E2BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: truncate: remove redundant initialization of new_order
has been removed from the -mm tree.  Its filename was
     mm-truncate-remove-redundant-initialization-of-new_order.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm: truncate: remove redundant initialization of new_order
Date: Thu, 6 Apr 2023 10:58:17 +0100

Variable new_order is being initialized with a value that is not read, the
variable is being re-assigned later.  Remove the initialization.

Link: https://lkml.kernel.org/r/20230406095817.703426-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/truncate.c~mm-truncate-remove-redundant-initialization-of-new_order
+++ a/mm/truncate.c
@@ -213,7 +213,7 @@ bool truncate_inode_partial_folio(struct
 {
 	loff_t pos = folio_pos(folio);
 	unsigned int offset, length, remaining;
-	unsigned int new_order = folio_order(folio);
+	unsigned int new_order;
 
 	if (pos < start)
 		offset = start - pos;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege-fix.patch

