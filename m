Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48752C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiLAAFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiLAADm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4F78EE51
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F08F361E5B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439C2C43470;
        Thu,  1 Dec 2022 00:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852900;
        bh=wccNEyhwRPnvPpSgXyGED6y7a0sICSbsV6icNQ9xNWk=;
        h=Date:To:From:Subject:From;
        b=LLL00vRppIaHTg1wGdVmDwCWdYVXdzihmcT0n/Dr5aMd20a9NLJZtwJbDPC6aTIX4
         knNUD5K9m8tlzE7o4GnLSvoFZtZdCC6PIa/z3S/5cNmC1RNsu1hEcaQ3K0W5hGadSR
         7ZSuhRv2eKxuv8agqnsb/49C5cZIdpRTvZJMOd0s=
Date:   Wed, 30 Nov 2022 16:01:39 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-zram-document-zram-recompress-sysfs-knobs.patch removed from -mm tree
Message-Id: <20221201000140.439C2C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/ABI/zram: document zram recompress sysfs knobs
has been removed from the -mm tree.  Its filename was
     docs-abi-zram-document-zram-recompress-sysfs-knobs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Docs/ABI/zram: document zram recompress sysfs knobs
Date: Tue, 15 Nov 2022 11:03:14 +0900

Document zram re-compression sysfs knobs.

Link: https://lkml.kernel.org/r/20221115020314.386235-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/ABI/testing/sysfs-block-zram~docs-abi-zram-document-zram-recompress-sysfs-knobs
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -137,3 +137,17 @@ Description:
 		The writeback_limit file is read-write and specifies the maximum
 		amount of writeback ZRAM can do. The limit could be changed
 		in run time.
+
+What:		/sys/block/zram<id>/recomp_algorithm
+Date:		November 2022
+Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
+Description:
+		The recomp_algorithm file is read-write and allows to set
+		or show secondary compression algorithms.
+
+What:		/sys/block/zram<id>/recompress
+Date:		November 2022
+Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
+Description:
+		The recompress file is write-only and triggers re-compression
+		with secondary compression algorithms.
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


