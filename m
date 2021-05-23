Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D281C47081
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AA76611AD
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhEWAnU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE3B6052B;
        Sun, 23 May 2021 00:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730514;
        bh=nGHqGOOwYPHEuTTTQkNAv+nuGRFrH9WNkYdaAwDZWEs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ToeSGm4ujnmKq/sdBdn64z7tKwLl/eFS2Qv6WYYG7kTrV0qkYlegSxDO8RfwASSDa
         qi0QyRWCU1PzApTqnFzHJxWo8BzPfnWLDmh14BuxkOdy4I0rcjTnPesTBUN6PlIMjI
         yGHWT73SaOzRjMM312FMpS5ZaTOUiWvkZur688Ys=
Date:   Sat, 22 May 2021 17:41:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ckennelly@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yangyingliang@huawei.com
Subject:  [patch 04/10] tools/testing/selftests/exec: fix link
 error
Message-ID: <20210523004153.DEHj60j2v%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Subject: tools/testing/selftests/exec: fix link error

Fix the link error by adding '-static':

gcc -Wall  -Wl,-z,max-page-size=0x1000 -pie load_address.c -o /home/yang/linux/tools/testing/selftests/exec/load_address_4096
/usr/bin/ld: /tmp/ccopEGun.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `stderr@@GLIBC_2.17' which may bind externally can not be used when making a shared object; recompile with -fPIC
/usr/bin/ld: /tmp/ccopEGun.o(.text+0x158): unresolvable R_AARCH64_ADR_PREL_PG_HI21 relocation against symbol `stderr@@GLIBC_2.17'
/usr/bin/ld: final link failed: bad value
collect2: error: ld returned 1 exit status
make: *** [Makefile:25: tools/testing/selftests/exec/load_address_4096] Error 1

Link: https://lkml.kernel.org/r/20210514092422.2367367-1-yangyingliang@huawei.com
Fixes: 206e22f01941 ("tools/testing/selftests: add self-test for verifying load alignment")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Chris Kennelly <ckennelly@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/exec/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/exec/Makefile~tools-testing-selftests-exec-fix-link-error
+++ a/tools/testing/selftests/exec/Makefile
@@ -28,8 +28,8 @@ $(OUTPUT)/execveat.denatured: $(OUTPUT)/
 	cp $< $@
 	chmod -x $@
 $(OUTPUT)/load_address_4096: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie -static $< -o $@
 $(OUTPUT)/load_address_2097152: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie -static $< -o $@
 $(OUTPUT)/load_address_16777216: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie $< -o $@
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie -static $< -o $@
_
