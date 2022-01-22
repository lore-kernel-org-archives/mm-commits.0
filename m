Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61633C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiAVGNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGNs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F42C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52063B8216D
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EA5C004E1;
        Sat, 22 Jan 2022 06:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832026;
        bh=G+CirkaGuf3U0Ctj8zohvkboH9ldNSxVUUngGwSfWWI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vbNsf9TGFgj6KuVcv/kZzv719Y2+IHGLZlIsWIy+usEJNzt11ufKLoXitbRPCbfTy
         eC/u+N4ftLNKQ2duIzmo0M6JTC7i6KHz5ZYg+v2xyrXMb1cJz9aXKFSYztHxh1+HtK
         TrAk+9FWIhwc4PUni9GUop7sRRmJP2+IiaBk1Lwg=
Date:   Fri, 21 Jan 2022 22:13:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 42/69] kernel/sysctl.c: remove unused variable
 ten_thousand
Message-ID: <20220122061345.JD5s2KopC%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -96,9 +96,6 @@
 
 /* Constants used for minimum and  maximum */
 
-#ifdef CONFIG_PRINTK
-static const int ten_thousand = 10000;
-#endif
 #ifdef CONFIG_PERF_EVENTS
 static const int six_hundred_forty_kb = 640 * 1024;
 #endif
_
