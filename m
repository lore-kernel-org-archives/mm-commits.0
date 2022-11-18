Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C4BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 01:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbiKRBKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 20:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiKRBKH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 20:10:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE11463CF4
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 17:10:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5799B8221F
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 01:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFDC433C1;
        Fri, 18 Nov 2022 01:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668733802;
        bh=dHkfhdMI/XZ15OALQO7EiLWoWyjbfrqI/tjWwNiswE8=;
        h=Date:To:From:Subject:From;
        b=lk7S5eAf6DwVz1iQZcS5/MTIhKp2HH9xmPYgZql7tcEDHBqLo6d0O7aoeOQRbOcCb
         BRM4EehoJUsq7bnxi5VQoahfnUEY/9P2S15u0Pi26qsbEgpfTcAuTnYTHPpCmCA9JH
         b4WfWXOfOMKePHR/cUgm5ndBxkBfv3LLWtHXrZcE=
Date:   Thu, 17 Nov 2022 17:10:02 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-zram-document-zram-recompress-sysfs-knobs.patch added to mm-unstable branch
Message-Id: <20221118011002.A4AFDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/ABI/zram: document zram recompress sysfs knobs
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-zram-document-zram-recompress-sysfs-knobs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-zram-document-zram-recompress-sysfs-knobs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Docs/ABI/zram: document zram recompress sysfs knobs
Date: Tue, 15 Nov 2022 11:03:14 +0900

Document zram re-compression sysfs knobs.

Link: https://lkml.kernel.org/r/20221115020314.386235-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
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

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-introduce-recompress-sysfs-knob-fix.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch
docs-abi-zram-document-zram-recompress-sysfs-knobs.patch
zram-remove-unused-stats-fields.patch

