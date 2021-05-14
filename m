Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AE5C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED02D611BE
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhENWQF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 18:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhENWQE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 18:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EE861440;
        Fri, 14 May 2021 22:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621030491;
        bh=X+QQP0uQx5UUUQKThN7SFINpYLk6aBMXaU3EopoSLzI=;
        h=Date:From:To:Subject:From;
        b=jhnwycSp7UXYA6nKPF+JFYQkWeXCFSckuVadmMTvc2ga6SYOHK4+4yIKRQTYa2FKs
         LPw3mKjC+TJ7bXwCsOF2iN7cYNN1OiMePYg9jUDhKhEFfKGRfPcpUR2u74mDbYBpYZ
         Ad/h+SYQMUcxBLMvK2TjfjAhgpSR325PIjTeLrpo=
Date:   Fri, 14 May 2021 15:14:51 -0700
From:   akpm@linux-foundation.org
To:     ckennelly@google.com, mm-commits@vger.kernel.org,
        yangyingliang@huawei.com
Subject:  + tools-testing-selftests-exec-fix-link-error.patch added
 to -mm tree
Message-ID: <20210514221451.dSKuxGZqg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/exec: fix link error
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-exec-fix-link-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-exec-fix-link-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-exec-fix-link-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yangyingliang@huawei.com are

tools-testing-selftests-exec-fix-link-error.patch
ocfs2-remove-unnecessary-init_list_head.patch

