Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CF1C83F33
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbjIBXqI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBXqH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:46:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B488DCDA
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6009CB808BC
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF70BC433C7;
        Sat,  2 Sep 2023 23:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693698362;
        bh=Y7HsIhZ9kp4J4U7YnpW4I4x1vFVQXm2USLWD+DCpwUw=;
        h=Date:To:From:Subject:From;
        b=Ezu4/xvzeZUKv6KG0cbXW9qKrOeS4w78YFVMDkrYrxXe953Kazkyqti089hVX2qej
         J7JNuD4O25ZUlhJu3ojLNfJvPRh3001ySKpWCpnzKriiD+DSlHFxy9imQxKnTxKg1R
         eCl2D93YjvTElNsrmUnOhQK4pIza14goZC3JIBr8=
Date:   Sat, 02 Sep 2023 16:46:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        irogers@google.com, xiexiuqi@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-fix-undefined-reference-to-pthread_once.patch added to mm-hotfixes-unstable branch
Message-Id: <20230902234601.EF70BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/mm: fix undefined reference to pthread_once
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-mm-fix-undefined-reference-to-pthread_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-fix-undefined-reference-to-pthread_once.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

tools-mm-fix-undefined-reference-to-pthread_once.patch

