Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083E2C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiLAAIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiLAAGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9E0880FC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EFF0B81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC17C43140;
        Thu,  1 Dec 2022 00:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852949;
        bh=jGTg6c/g4jYlb11R0moDxABVJQLFIlwllycTttAiZIs=;
        h=Date:To:From:Subject:From;
        b=xBfo6uPzvZZzWRAFa4u3tv4JJbKOHOoEdkj4vtPzapLabT2RK7crsyaycbvs5Pi1P
         W6QJCBjVS1TrWOc2rgdsMMUSozAYKsePX9cmUtIBomVFandDVv+fRBIXk9MKtS5bwe
         RLwgBzy64UwNQ/foNqZfAQOgYy84sBMNi6QM1/6g=
Date:   Wed, 30 Nov 2022 16:02:28 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate-stop-using-0-as-null-pointer.patch removed from -mm tree
Message-Id: <20221201000228.DBC17C43140@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate.c: stop using 0 as NULL pointer
has been removed from the -mm tree.  Its filename was
     migrate-stop-using-0-as-null-pointer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/migrate.c: stop using 0 as NULL pointer
Date: Wed, 16 Nov 2022 09:23:45 +0800

mm/migrate.c:1198:24: warning: Using plain integer as NULL pointer

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3080
Link: https://lkml.kernel.org/r/20221116012345.84870-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~migrate-stop-using-0-as-null-pointer
+++ a/mm/migrate.c
@@ -1180,7 +1180,7 @@ static int unmap_and_move(new_page_t get
 		return -ENOMEM;
 	dst = page_folio(newpage);
 
-	dst->private = 0;
+	dst->private = NULL;
 	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(&dst->page, reason);
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch

