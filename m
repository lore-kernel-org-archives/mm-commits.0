Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833D1C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 415FA64E6C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBXUGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235186AbhBXUF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15D7F64F20;
        Wed, 24 Feb 2021 20:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197102;
        bh=vFh4qvEWMqr1XNAa0CR0/f9E19one+5mBlwsfnK63do=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=meL1AX21BoUYPv4qlKtSqm6odGKPfuEoD82MDU2TScTniGMZwOr0pcsbPO237E+d5
         iq1ur6bK0JZRaeMauMQsK/WRfqXyV28JeKKfqPIL5oXDZKPRL++LHVDOzz2CKZn3H/
         KS9feUiChP4IAVZbnqA2JgCKXc6s7/AeglK5esw4=
Date:   Wed, 24 Feb 2021 12:05:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        adobriyan@gmail.com, akpm@linux-foundation.org, bhe@redhat.com,
        dyoung@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com, vgoyal@redhat.com
Subject:  [patch 085/173] vmalloc: remove redundant NULL check
Message-ID: <20210224200500.Nfm1N1293%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: vmalloc: remove redundant NULL check

Fix below warnings reported by coccicheck:
./fs/proc/vmcore.c:1503:2-7: WARNING: NULL check before some freeing
functions is not needed.

Link: https://lkml.kernel.org/r/1611216753-44598-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/proc/vmcore.c~vmalloc-remove-redundant-null-check
+++ a/fs/proc/vmcore.c
@@ -1503,11 +1503,8 @@ int vmcore_add_device_dump(struct vmcore
 	return 0;
 
 out_err:
-	if (buf)
-		vfree(buf);
-
-	if (dump)
-		vfree(dump);
+	vfree(buf);
+	vfree(dump);
 
 	return ret;
 }
_
