Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD3EEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjFSXWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjFSXVh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A00510F4
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 905A460F38
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB14C433C0;
        Mon, 19 Jun 2023 23:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216884;
        bh=qp36uebUG4N/BJiAMa2mtc4cU8+bw/nzkZlqZtr6QgY=;
        h=Date:To:From:Subject:From;
        b=D/BtxH8LU8Qy2lSKrWZsDPB0GoZaiqgAn26eo/Sdt7TGGlMmNkPa10gvjrAULgbWs
         wbq6OOPDZVjZfuA+Wjrvix4hZILisSDD1aPN73+WFrG1ChoHkj+59xjmM4XM8GbbiK
         PsyDS+UxaHGGX4td7GQlnnmqh/sT79xIZUr1B0Ac=
Date:   Mon, 19 Jun 2023 16:21:23 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sj@kernel.org, naresh.kamboju@linaro.org, anders.roxell@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-config-file.patch removed from -mm tree
Message-Id: <20230619232123.EBB14C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: damon: add config file
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-config-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
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


