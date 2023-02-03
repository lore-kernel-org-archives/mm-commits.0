Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8BBC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjBCGwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897BB4C1E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 394F1B82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45F3C433EF;
        Fri,  3 Feb 2023 06:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407086;
        bh=4qPcOy7BJFh4jt5tCQoxUqGS5kDATGJqbR8RPkxLT90=;
        h=Date:To:From:Subject:From;
        b=Rh9wGjNJSyK56wxL0ltawRT/xOyPReMJ0nDrlzhXeFW9krYgenPhIpiwoZb8IvgPS
         I2o7OWaQHM7g6iNkvLeQieSgncXTIOZoXYMWDmkoXuy783THRBDddCBhKDIdZlZ4rn
         GMNf4GTz7rB6qMM3AIC11XrlqHozVSk/fKgpLBfM=
Date:   Thu, 02 Feb 2023 22:51:26 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch removed from -mm tree
Message-Id: <20230203065126.D45F3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: fix DFLTCC ignoring flush modes when avail_in == 0
has been removed from the -mm tree.  Its filename was
     lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: fix DFLTCC ignoring flush modes when avail_in == 0
Date: Thu, 26 Jan 2023 14:14:24 +0100

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/40acb3f

Link: https://lkml.kernel.org/r/20230126131428.1222214-5-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc_deflate.c~lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -142,7 +142,8 @@ again:
         /* Clear history. */
         if (flush == Z_FULL_FLUSH)
             param->hl = 0;
-        *result = need_more;
+        /* Trigger block post-processing if necessary. */
+        *result = no_flush ? need_more : block_done;
         return 1;
     }
 
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


