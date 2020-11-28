Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E86C64E7D
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 17:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B2C0246E8
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 17:57:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hi7Vovgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbgK1Rzz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 28 Nov 2020 12:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732377AbgK1ETb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 23:19:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A1921973;
        Sat, 28 Nov 2020 04:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606537127;
        bh=1twkKRWydFKRQrIGArIEigLqW2YjpRnvhH6LDiXskZY=;
        h=Date:From:To:Subject:From;
        b=Hi7VovgfpzgEI5k6Yx/RrIWVoDuCWhihME4hsGhFovagsGP7Wbk9qDv73nuM4qaVO
         8A0+2b6JQWFUJKOeSTN3dA39O4Bb9LVLvE6WCF1YJHmrDlLjgjRliuyhYJQKMIgo7Q
         wCrdEVumWp8EkAONUW1adE4mWkPXn9uW+0JEf3mY=
Date:   Fri, 27 Nov 2020 20:18:46 -0800
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, dan.j.williams@intel.com, glider@google.com,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        ylal@codeaurora.org, zhenhuah@codeaurora.org
Subject:  [to-be-updated]
 lib-stackdepot-add-support-to-configure-stack_hash_size.patch removed from
 -mm tree
Message-ID: <20201128041846.kZUjGdR0x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-support-to-configure-stack_hash_size.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yogesh Lal <ylal@codeaurora.org>
Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE

Use STACK_HASH_ORDER_SHIFT to configure STACK_HASH_SIZE.

Aim is to have configurable value for  STACK_HASH_SIZE,
so depend on use case one can configure it.

One example is of Page Owner, default value of
STACK_HASH_SIZE lead stack depot to consume 8MB of static memory.
Making it configurable and use lower value helps to enable features like
CONFIG_PAGE_OWNER without any significant overhead.

Link: https://lkml.kernel.org/r/1603372546-27118-1-git-send-email-vjitta@codeaurora.org
Signed-off-by: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Zhenhua Huang <zhenhuah@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig      |    9 +++++++++
 lib/stackdepot.c |    3 +--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/lib/Kconfig~lib-stackdepot-add-support-to-configure-stack_hash_size
+++ a/lib/Kconfig
@@ -651,6 +651,15 @@ config STACKDEPOT
 	bool
 	select STACKTRACE
 
+config STACK_HASH_ORDER_SHIFT
+	int "stack depot hash size (12 => 4KB, 20 => 1024KB)"
+	range 12 20
+	default 20
+	depends on STACKDEPOT
+	help
+	 Select the hash size as a power of 2 for the stackdepot hash table.
+	 Choose a lower value to reduce the memory impact.
+
 config SBITMAP
 	bool
 
--- a/lib/stackdepot.c~lib-stackdepot-add-support-to-configure-stack_hash_size
+++ a/lib/stackdepot.c
@@ -142,8 +142,7 @@ static struct stack_record *depot_alloc_
 	return stack;
 }
 
-#define STACK_HASH_ORDER 20
-#define STACK_HASH_SIZE (1L << STACK_HASH_ORDER)
+#define STACK_HASH_SIZE (1L << CONFIG_STACK_HASH_ORDER_SHIFT)
 #define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
 #define STACK_HASH_SEED 0x9747b28c
 
_

Patches currently in -mm which might be from ylal@codeaurora.org are


