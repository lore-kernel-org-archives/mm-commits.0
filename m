Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36C2C433E1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 16:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C91619AB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 16:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhC1QmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 12:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhC1QmQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 12:42:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 709756193F;
        Sun, 28 Mar 2021 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616949736;
        bh=GGD/0y063c2X3jeAGJ01H1e8d/wGTqlxqCZbfn1Zn10=;
        h=Date:From:To:Subject:From;
        b=J8WMCbNfN4ShdpqPwZHTaxxT2kCqovri4xTHWFnskK8x5XT/hgCKth6DlNWxXygVC
         e2YT7RC90FxexamcVLJcNGZ/26UUv9M2oyWOtuUSFVyRjOh1dhDhzUjZqE42AEWH67
         E1dQ1TR5Wvz4Uh0czcvW/7UAurX+418WzSVpwsUE=
Date:   Sun, 28 Mar 2021 09:42:16 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        shuah@kernel.org
Subject:  [merged] selftests-vm-fix-out-of-tree-build.patch removed
 from -mm tree
Message-ID: <20210328164216.gEQ-TFYp1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix out-of-tree build
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-out-of-tree-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rong.a.chen@intel.com are


