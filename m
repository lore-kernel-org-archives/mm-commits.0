Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34C6C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 22:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhLUWXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 17:23:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33468 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhLUWXd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 17:23:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97369617B8
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 22:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF12C36AE9;
        Tue, 21 Dec 2021 22:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640125413;
        bh=pCvSvX6zoyj3MB/+5sv1FErtGMrnLa7PODN6VBUpVqU=;
        h=Date:From:To:Subject:From;
        b=qvhHWGm+P0hIfM8K8FnDRAcPZRTwnQKI70zaDUdrRhi2OcJ0JVSwBlaM92XD/5foq
         ljrRiBkq6AvAF3IsD+Q18ze23dgbb3/7OgyLLq1PHi5iA31j81/bqp/DjlqMUgAR8K
         LC8wcqiyX6dlffpqYJoNKzOQw39vGI/FitJz723w=
Date:   Tue, 21 Dec 2021 14:23:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        colin.i.king@gmail.com
Subject:  + kernel-sysctlc-remove-unused-variable-ten_thousand.patch
 added to -mm tree
Message-ID: <20211221222332.20KLb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: remove unused variable ten_thousand
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-remove-unused-variable-ten_thousand.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctlc-remove-unused-variable-ten_thousand.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctlc-remove-unused-variable-ten_thousand.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: kernel/sysctl.c: remove unused variable ten_thousand

The const variable ten_thousand is not used, it is redundant and can be
removed.

Cleans up clang warning:
kernel/sysctl.c:99:18: warning: unused variable 'ten_thousand' [-Wunused-const-variable]
static const int ten_thousand = 10000;

Link: https://lkml.kernel.org/r/20211221184501.574670-1-colin.i.king@gmail.com
Fixes: c26da54dc8ca ("printk: move printk sysctl to printk/sysctl.c")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/sysctl.c~kernel-sysctlc-remove-unused-variable-ten_thousand
+++ a/kernel/sysctl.c
@@ -108,9 +108,6 @@
 static const unsigned long zero_ul;
 static const unsigned long one_ul = 1;
 static const unsigned long long_max = LONG_MAX;
-#ifdef CONFIG_PRINTK
-static const int ten_thousand = 10000;
-#endif
 #ifdef CONFIG_PERF_EVENTS
 static const int six_hundred_forty_kb = 640 * 1024;
 #endif
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch
kernel-sysctlc-remove-unused-variable-ten_thousand.patch

