Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B371C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC56261426
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhEEBlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhEEBlL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A05161423;
        Wed,  5 May 2021 01:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178816;
        bh=RwYenkykS+k7VbAmzczu6oh7V8zOWUjR93fdJvDhvJM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Hk0DUHBp910sh/mCHkuuDht/BkPXiWodxZ3FBhTTroppZxIQoKO4xA5MKzMurdbMo
         aLrLBm99kzr8aAN4T/CJFLLFviMLmwPoC26D+uaWwdr+7dPM/Tg2LU2ExNkoyA1yi4
         0YMDblWNG1KssrMVQXFkUv7rhwwM/+7I+wfjDSHQ=
Date:   Tue, 04 May 2021 18:40:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhang.yunkai@zte.com.cn
Subject:  [patch 139/143] mm/process_vm_access.c: remove duplicate
 include
Message-ID: <20210505014015.jvfymrW5Y%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: mm/process_vm_access.c: remove duplicate include

'linux/compat.h' included in 'process_vm_access.c' is duplicated.

Link: https://lkml.kernel.org/r/20210306132122.220431-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/process_vm_access.c~mm-process_vm_access-remove-duplicate-include
+++ a/mm/process_vm_access.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
-#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
_
