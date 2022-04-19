Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EF1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiDSDpb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 23:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346825AbiDSDp3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 23:45:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8F53193D
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8F9B81125
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F6DC385A7;
        Tue, 19 Apr 2022 03:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650339765;
        bh=2cteI26Vq+jlXOV5E0WNPiSL/XQI8rV4/og7G7/w7po=;
        h=Date:To:From:Subject:From;
        b=qLug1ZHAhdLwG2bSfxDbJrnLSdmYrOcjM0Pasap5lR6umfpjYVSczsfl4K6kSnWzz
         Ii2tZ+xLZ+6gBH7L/yFF34IcK7Qd20WVmvqEIbLHR/DtihNyp5xxh3IoohWVkgFkMj
         v7yt1Qel4DuQowCOpoCyP09gIrxAds7qFPQTEucM=
Date:   Mon, 18 Apr 2022 20:42:44 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, yuanchu@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-damon-to-selftests-root-makefile.patch added to -mm tree
Message-Id: <20220419034245.81F6DC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: add damon to selftests root Makefile
has been added to the -mm tree.  Its filename is
     selftests-damon-add-damon-to-selftests-root-makefile.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-damon-add-damon-to-selftests-root-makefile.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-damon-add-damon-to-selftests-root-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yuanchu Xie <yuanchu@google.com>
Subject: selftests/damon: add damon to selftests root Makefile

Currently the damon selftests are not built with the rest of the
selftests.  We add damon to the list of targets.

Link: https://lkml.kernel.org/r/20220418202017.3583638-1-yuanchu@google.com
Fixes: b348eb7abd09 ("mm/damon: add user space selftests")
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/Makefile~selftests-damon-add-damon-to-selftests-root-makefile
+++ a/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += clone3
 TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += damon
 TARGETS += drivers/dma-buf
 TARGETS += efivarfs
 TARGETS += exec
_

Patches currently in -mm which might be from yuanchu@google.com are

selftests-damon-add-damon-to-selftests-root-makefile.patch

