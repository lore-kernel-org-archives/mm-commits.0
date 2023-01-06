Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EB5C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 03:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjAFDA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 22:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbjAFDAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 22:00:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA0C6950D
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 19:00:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B2FA61CC9
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 03:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF17C433EF;
        Fri,  6 Jan 2023 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672974036;
        bh=6WVsCOgqou9E9d9qp9+GNE2eoPbumkv8gmhPxBaUcSE=;
        h=Date:To:From:Subject:From;
        b=OhZetwCj+dLp/SFFnH11IBquKuWOtuEBw8q9GMMpPZv5EUeWXxKrcjwirx1cFKnrD
         VN9YxhR9XHy42wem1wS2aopVNzY8s1Z1ETro3BatZG4zuwSPfvdI+yCQl0No0XEpBE
         YhKRRBng0NoQUcuyLGzg/J0Mihofcxa1Wf327EM4=
Date:   Thu, 05 Jan 2023 19:00:35 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-correctly-handle-all-next_arg-cases.patch added to mm-unstable branch
Message-Id: <20230106030036.BAF17C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: correctly handle all next_arg() cases
has been added to the -mm mm-unstable branch.  Its filename is
     zram-correctly-handle-all-next_arg-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-correctly-handle-all-next_arg-cases.patch

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

zram-correctly-handle-all-next_arg-cases.patch

