Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9566CA0FE2
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 17:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbjIERkK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 13:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240865AbjIERjm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 13:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B068B7A5
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 10:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF3F60C34
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 17:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7D7C433C9;
        Tue,  5 Sep 2023 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693934090;
        bh=tbnAijfK0RAXt3b1j7p2bVfoNELHJdxxo+NZVJ1Bc/w=;
        h=Date:To:From:Subject:From;
        b=zG8JP6lZX8l2KJo3SqQpYYpkPT9dGZ0HOeBBFLRk4Wf4kWkygIyfo6O2+Lo+SdmoK
         +EWaQPUKuKxHtOfLqyBb1A0r0iW1dO3UixXpy6nxpoXv2/+cnk4XOmgAWphTNPcIj6
         pZOXC5mmqaymwfb66kndLSmBxkxMoVHso2S94EDM=
Date:   Tue, 05 Sep 2023 10:14:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        irogers@google.com, xiexiuqi@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-mm-fix-undefined-reference-to-pthread_once.patch removed from -mm tree
Message-Id: <20230905171450.0F7D7C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/mm: fix undefined reference to pthread_once
has been removed from the -mm tree.  Its filename was
     tools-mm-fix-undefined-reference-to-pthread_once.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: tools/mm: fix undefined reference to pthread_once
Date: Thu, 31 Aug 2023 11:42:05 +0800

Commit 97d5f2e9ee12 ("tools api fs: More thread safety for global
filesystem variables") introduces pthread_once, so the libpthread
should be added at link time, or we'll meet the following compile
error when 'make -C tools/mm':

  gcc -Wall -Wextra -I../lib/ -o page-types page-types.c ../lib/api/libapi.a
  ~/linux/tools/lib/api/fs/fs.c:146: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:147: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:148: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:149: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:150: undefined reference to `pthread_once'
  /usr/bin/ld: ../lib/api/libapi.a(libapi-in.o):~/linux/tools/lib/api/fs/fs.c:151:
  more undefined references to `pthread_once' follow
  collect2: error: ld returned 1 exit status
  make: *** [Makefile:22: page-types] Error 1

Link: https://lkml.kernel.org/r/20230831034205.2376653-1-xiexiuqi@huaweicloud.com
Fixes: 97d5f2e9ee12 ("tools api fs: More thread safety for global filesystem variables")
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/mm/Makefile~tools-mm-fix-undefined-reference-to-pthread_once
+++ a/tools/mm/Makefile
@@ -8,8 +8,8 @@ TARGETS=page-types slabinfo page_owner_s
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 
-CFLAGS += -Wall -Wextra -I../lib/
-LDFLAGS += $(LIBS)
+CFLAGS += -Wall -Wextra -I../lib/ -pthread
+LDFLAGS += $(LIBS) -pthread
 
 all: $(TARGETS)
 
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are


