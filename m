Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893E4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 16:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244449AbiEJRAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 13:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347747AbiEJRAX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 13:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFC224642C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 09:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC6F61673
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 16:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2FDC385C9;
        Tue, 10 May 2022 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652201781;
        bh=ZkcplmcD1pYQuaQz81mNUXMOrmx55eGRmAPByDfouno=;
        h=Date:To:From:Subject:From;
        b=TS3HGiOyhC0H317cogOi9lddYudYi3Ck7W9NJILMBEmB/Mz7wVyao0C+J26f6KsJQ
         nk3GNSNgFWPnkkzz+6kxOwa9oTlo94AQeUvPHIFfyaQPFqCnBa8lFgejyDOQqHidMU
         G5w4OuAx50pVtohzMk/bn6fwmaXC9ofnWppp6q4g=
Date:   Tue, 10 May 2022 09:56:20 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        zhouchengming@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-vm-override-targets-from-arguments.patch removed from -mm tree
Message-Id: <20220510165621.3E2FDC385C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftest/vm: override TARGETS from arguments
has been removed from the -mm tree.  Its filename was
     kselftest-vm-override-targets-from-arguments.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: kselftest/vm: override TARGETS from arguments

We can specify which testcases to build using TARGETS argument, for
example: make -C tools/testing/selftests TARGETS=vm, cause the ordinary
assignment of TARGETS in Makefile will be ignored.  So we need to use
override directive to change that.

Link: https://lkml.kernel.org/r/20220227055330.43087-1-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~kselftest-vm-override-targets-from-arguments
+++ a/tools/testing/selftests/vm/Makefile
@@ -59,7 +59,7 @@ CAN_BUILD_I386 := $(shell ./../x86/check
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
 
-TARGETS := protection_keys
+override TARGETS := protection_keys
 BINARIES_32 := $(TARGETS:%=%_32)
 BINARIES_64 := $(TARGETS:%=%_64)
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are


