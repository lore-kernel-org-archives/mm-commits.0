Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D111FC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjASBUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjASBTc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B126CCCA
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE53AB81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60132C433F0;
        Thu, 19 Jan 2023 01:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090987;
        bh=GZOZcHD6klYaxGyjuuKx53qCSd5VXxqW/V8Q0r2pyIY=;
        h=Date:To:From:Subject:From;
        b=C2wInj+QqWiD6Klq95Cbd9yhVUMJxop+x6zUbso7/UeTwv7e/HYbUQPzz2XU55MyV
         Do4SjGju3aQHR5QZMaM3UMfJP18mpKsANwugSqX4w5Ho3v5BTMwVNfPkwf/c2l3WVB
         aoVOwANnOIPcM1ccykeCpzWGCJfqll8DmG7UD82o=
Date:   Wed, 18 Jan 2023 17:16:26 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-correctly-handle-all-next_arg-cases.patch removed from -mm tree
Message-Id: <20230119011627.60132C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: correctly handle all next_arg() cases
has been removed from the -mm tree.  Its filename was
     zram-correctly-handle-all-next_arg-cases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: correctly handle all next_arg() cases
Date: Tue, 3 Jan 2023 12:01:19 +0900

When supplied buffer does not have assignment sign next_arg() sets `val`
pointer to NULL, so we cannot dereference it.  Add a NULL pointer test to
handle `param` case, in addition to `*val` test, which handles cases when
param has no value assigned to it: `param=`.

Link: https://lkml.kernel.org/r/20230103030119.1496358-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-correctly-handle-all-next_arg-cases
+++ a/drivers/block/zram/zram_drv.c
@@ -1140,7 +1140,7 @@ static ssize_t recomp_algorithm_store(st
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
-		if (!*val)
+		if (!val || !*val)
 			return -EINVAL;
 
 		if (!strcmp(param, "algo")) {
@@ -1824,7 +1824,7 @@ static ssize_t recompress_store(struct d
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
-		if (!*val)
+		if (!val || !*val)
 			return -EINVAL;
 
 		if (!strcmp(param, "type")) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

