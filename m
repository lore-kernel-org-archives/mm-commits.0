Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D3CC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 19:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjFIT0m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 15:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjFIT0l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 15:26:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C249C2D44
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 12:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC5465B43
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 19:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B1C433EF;
        Fri,  9 Jun 2023 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686338799;
        bh=fO6w4eTQqeZx4EWOwpm4S0CsbxqHD+1RDuZIeekotc4=;
        h=Date:To:From:Subject:From;
        b=KzKNMdyoaHNjG1EaGVDYj/VlberNzUkZgfIfH7JnOUESJ5gpYoSBTBQSZYgZhg+BQ
         afwC3q/5AII3KYjdONv0KYmUeXbk18zgSBqkd8Vs5resy1cDbZjIc3/c10vTPqMybQ
         b6eUueZUGdTlzGA7zzojmNQwtnGelB+4mgzmtJWw=
Date:   Fri, 09 Jun 2023 12:26:39 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        naresh.kamboju@linaro.org, anders.roxell@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-config-file.patch added to mm-unstable branch
Message-Id: <20230609192639.A76B1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: damon: add config file
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-config-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-config-file.patch

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
From: Anders Roxell <anders.roxell@linaro.org>
Subject: selftests: damon: add config file
Date: Wed, 12 Apr 2023 11:28:54 +0200

Building and running the subsuite 'damon' of kselftest, shows the
following issues:
 selftests: damon: debugfs_attrs.sh
  /sys/kernel/debug/damon not found

By creating a config file enabling DAMON fragments in the
selftests/damon/ directory the tests pass.

Link: https://lkml.kernel.org/r/20230412092854.3306197-1-anders.roxell@linaro.org
Fixes: b348eb7abd09 ("mm/damon: add user space selftests")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/config |    7 +++++++
 1 file changed, 7 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/config
@@ -0,0 +1,7 @@
+CONFIG_DAMON=y
+CONFIG_DAMON_SYSFS=y
+CONFIG_DAMON_DBGFS=y
+CONFIG_DAMON_PADDR=y
+CONFIG_DAMON_VADDR=y
+CONFIG_DAMON_RECLAIM=y
+CONFIG_DAMON_LRU_SORT=y
_

Patches currently in -mm which might be from anders.roxell@linaro.org are

selftests-damon-add-config-file.patch

