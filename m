Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5244CC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B63A61A34
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCYEhN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhCYEgr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Mar 2021 00:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF27C61A14;
        Thu, 25 Mar 2021 04:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647007;
        bh=b4ShdLbawH1da2mMX3GriiEiSupRdXsPs1YK7OK2YV0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Iru9u6oh+qflhrLKAYy4x3f59CUty3S2ySK3K4CZjWEbnzMudS59xv+a2z9/Qswz3
         hmDEpLhEdR4sORUHCtOok6IWB+p4e68DUPKBZ5LWIPBxqUW2mMGxGKtSBCfgYRBBTw
         hJgxPZsWqDJ8zVYgYxtUWB7hVwcnxkj8FVbRA+S0=
Date:   Wed, 24 Mar 2021 21:36:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        shuah@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/14] selftests/vm: fix out-of-tree build
Message-ID: <20210325043646.zWXA9MYSn%akpm@linux-foundation.org>
In-Reply-To: <20210324213324.fe1ba237e471b5de17a08775@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rong Chen <rong.a.chen@intel.com>
Subject: selftests/vm: fix out-of-tree build

When building out-of-tree, attempting to make target from $(OUTPUT) directory:

  make[1]: *** No rule to make target '$(OUTPUT)/protection_keys.c', needed by '$(OUTPUT)/protection_keys_32'.

Link: https://lkml.kernel.org/r/20210315094700.522753-1-rong.a.chen@intel.com
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-fix-out-of-tree-build
+++ a/tools/testing/selftests/vm/Makefile
@@ -101,7 +101,7 @@ endef
 ifeq ($(CAN_BUILD_I386),1)
 $(BINARIES_32): CFLAGS += -m32
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
-$(BINARIES_32): %_32: %.c
+$(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(TARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
@@ -109,7 +109,7 @@ endif
 ifeq ($(CAN_BUILD_X86_64),1)
 $(BINARIES_64): CFLAGS += -m64
 $(BINARIES_64): LDLIBS += -lrt -ldl
-$(BINARIES_64): %_64: %.c
+$(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(TARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
_
