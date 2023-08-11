Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10955C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbjHKXBp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjHKXAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48D63A81
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F0B678C4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE17C433C7;
        Fri, 11 Aug 2023 23:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794802;
        bh=sxazDNh7jmffcttdLdy6Q8h5FtMUiPGWOkUElbS1XZs=;
        h=Date:To:From:Subject:From;
        b=HCBqKggk/2zCDm7TfPTQnLOZFVd+ao0hmhsaJH/PunRvZ9WbTuW4uSe3ofqdzw8Vl
         PK3GSzdlSR9ezE+UDqTZgX9f1LCNJZc9YXyZyVw4yB9ML2WucYGHTRAtdI55hyadFz
         djbvS2Qr21/CvND7qte/WdUywx/WIGKQZEFMdBgA=
Date:   Fri, 11 Aug 2023 16:00:02 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        anshuman.khandual@arm.com, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-mark-check_for_memory-as-__init.patch removed from -mm tree
Message-Id: <20230811230002.8DE17C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: mark check_for_memory() as __init
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-mark-check_for_memory-as-__init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: mark check_for_memory() as __init
Date: Mon, 10 Jul 2023 09:37:50 +0000

The only caller of check_for_memory() is free_area_init(), which is
annotated with __init, so it should be safe to also mark the former as
__init.

Link: https://lkml.kernel.org/r/20230710093750.1294-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-mark-check_for_memory-as-__init
+++ a/mm/mm_init.c
@@ -1736,7 +1736,7 @@ static void __init free_area_init_node(i
 }
 
 /* Any regular or high memory on that node ? */
-static void check_for_memory(pg_data_t *pgdat)
+static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are


