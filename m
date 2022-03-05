Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC51CC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  5 Mar 2022 04:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiCEEaA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Mar 2022 23:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiCEE3z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2022 23:29:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B823ED33
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 20:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D2560A1C
        for <mm-commits@vger.kernel.org>; Sat,  5 Mar 2022 04:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298AFC004E1;
        Sat,  5 Mar 2022 04:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646454545;
        bh=3QgYFKLKriyRmPcPhNjx7Af6DYia7YhltRuyQlGNKC4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=v0haSeXRF0H36HFvE0OKaW4DrKysfYa+yHY4akGO8nKWA7r+PRuLSTtUy75Ckc2YJ
         lAfchNA8kIpsnJexOyYaIxxTiCaYEAG80RlyDgOR6EiREDNYe9Iq2enP7zMqFEgWdx
         nzhXmo39N6Qmt2wgGKD6UbmQhK4JmmybC7lEAOEI=
Date:   Fri, 04 Mar 2022 20:29:04 -0800
To:     skhan@linuxfoundation.org, zhouchengming@bytedance.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org>
Subject: [patch 6/8] kselftest/vm: fix tests build with old libc
Message-Id: <20220305042905.298AFC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: kselftest/vm: fix tests build with old libc

The error message when I build vm tests on debian10 (GLIBC 2.28):

userfaultfd.c: In function `userfaultfd_pagemap_test':
userfaultfd.c:1393:37: error: `MADV_PAGEOUT' undeclared (first use
in this function); did you mean `MADV_RANDOM'?
  if (madvise(area_dst, test_pgsize, MADV_PAGEOUT))
                                     ^~~~~~~~~~~~
                                     MADV_RANDOM

This patch includes these newer definitions from UAPI linux/mman.h, is
useful to fix tests build on systems without these definitions in glibc
sys/mman.h.

Link: https://lkml.kernel.org/r/20220227055330.43087-2-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~kselftest-vm-fix-tests-build-with-old-libc
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -46,6 +46,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
_
