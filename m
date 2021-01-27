Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620E1C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 23:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F33F60C41
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 23:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhA0XMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:12:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234892AbhA0XKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 18:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 232AF60C3D;
        Wed, 27 Jan 2021 23:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611788926;
        bh=jVo2VJl3u+DXdbK3bWFBDRp4KM1MTZqQSBcMTSnMnT8=;
        h=Date:From:To:Subject:From;
        b=WEMwKFWDRobtwydeaP8ZOicZDIXTTawCg3ab87e4Ij53VG0pEl6luWxUMBs1v4SBM
         CMKs7wqb4Dm89xqNN2y8cD+vAMjIFcyNuCPy+2sSC4e3jifjk71v7UNbZ/xJE/u3I+
         yiA6nNwA8J6Jv0btzXI4t9FiOZP0B1mM24vgvnmM=
Date:   Wed, 27 Jan 2021 15:08:45 -0800
From:   akpm@linux-foundation.org
To:     glider@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org, ylal@codeaurora.org
Subject:  +
 lib-stackdepot-add-support-to-configure-stack_hash_size.patch added to -mm
 tree
Message-ID: <20210127230845.eHiOXTVzl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-support-to-configure-stack_hash_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-support-to-configure-stack_hash_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-support-to-configure-stack_hash_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yogesh Lal <ylal@codeaurora.org>
Subject: lib: stackdepot: add support to configure STACK_HASH_SIZE

Use CONFIG_STACK_HASH_ORDER to configure STACK_HASH_SIZE.

Aim is to have configurable value for  STACK_HASH_SIZE,
so depend on use case one can configure it.

One example is of Page Owner, CONFIG_PAGE_OWNER works only if
page_owner=on via kernel parameter on CONFIG_PAGE_OWNER configured system.
Thus, unless admin enable it via command line option, the stackdepot will
just waste 8M memory without any customer.

Making it configurable and use lower value helps to enable features like
CONFIG_PAGE_OWNER without any significant overhead.

Link: https://lkml.kernel.org/r/1611749198-24316-1-git-send-email-vjitta@codeaurora.org
Signed-off-by: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
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
 
+config STACK_HASH_ORDER
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
@@ -141,8 +141,7 @@ static struct stack_record *depot_alloc_
 	return stack;
 }
 
-#define STACK_HASH_ORDER 20
-#define STACK_HASH_SIZE (1L << STACK_HASH_ORDER)
+#define STACK_HASH_SIZE (1L << CONFIG_STACK_HASH_ORDER)
 #define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
 #define STACK_HASH_SEED 0x9747b28c
 
_

Patches currently in -mm which might be from ylal@codeaurora.org are

lib-stackdepot-add-support-to-configure-stack_hash_size.patch

