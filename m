Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEDBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiEJENr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbiEJENb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92E820CA53
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6829561714
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DF4C385C8;
        Tue, 10 May 2022 04:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155774;
        bh=WTkT8fI53Ls3L4zy5QGvTLgDk4uaJ8m6KlUOkA6rQQ0=;
        h=Date:To:From:Subject:From;
        b=coz07pcF15oqeD/S2GAfS0cVepUOQFYBNKexmQXXUlfWDra7btOdM+FEBF63jzO6N
         cwAFS6oVYSRgwqMYFErPq8UGWQhNW8fdV9H3KsYPXuo7FpIZjYJnXdonNIkjTYR4FH
         hB+xsDv2eHVCig41dYCQMorY9+ahauhzuNfpdQ4M=
Date:   Mon, 09 May 2022 21:09:34 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        sandipan@linux.ibm.com, npache@redhat.com, dave.hansen@intel.com,
        jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-vm-makefile-rename-targets-to-vmtargets.patch removed from -mm tree
Message-Id: <20220510040934.B9DF4C385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: Makefile: rename TARGETS to VMTARGETS
has been removed from the -mm tree.  Its filename was
     selftests-vm-makefile-rename-targets-to-vmtargets.patch

This patch was dropped because it was merged into mm-hotfixes-stable

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests: vm: Makefile: rename TARGETS to VMTARGETS

The tools/testing/selftests/vm/Makefile uses the variable TARGETS
internally to generate a list of platform-specific binary build targets
suffixed with _{32,64}.  When building the selftests using its own
Makefile directly, such as via the following command run in a kernel tree:

One receives an error such as the following:

make: Entering directory '/root/linux/tools/testing/selftests'
make --no-builtin-rules ARCH=x86 -C ../../.. headers_install
make[1]: Entering directory '/root/linux'
  INSTALL ./usr/include
make[1]: Leaving directory '/root/linux'
make[1]: Entering directory '/root/linux/tools/testing/selftests/vm'
make[1]: *** No rule to make target 'vm.c', needed by '/root/linux/tools/testing/selftests/vm/vm_64'.  Stop.
make[1]: Leaving directory '/root/linux/tools/testing/selftests/vm'
make: *** [Makefile:175: all] Error 2
make: Leaving directory '/root/linux/tools/testing/selftests'

The TARGETS variable passed to tools/testing/selftests/Makefile collides
with the TARGETS used in tools/testing/selftests/vm/Makefile, so rename
the latter to VMTARGETS, eliminating the collision with no functional
change.

Link: https://lkml.kernel.org/r/20220504213454.1282532-1-jsavitz@redhat.com
Fixes: f21fda8f6453 ("selftests: vm: pkeys: fix multilib builds for x86")
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Acked-by: Nico Pache <npache@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-makefile-rename-targets-to-vmtargets
+++ a/tools/testing/selftests/vm/Makefile
@@ -57,9 +57,9 @@ CAN_BUILD_I386 := $(shell ./../x86/check
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
 
-TARGETS := protection_keys
-BINARIES_32 := $(TARGETS:%=%_32)
-BINARIES_64 := $(TARGETS:%=%_64)
+VMTARGETS := protection_keys
+BINARIES_32 := $(VMTARGETS:%=%_32)
+BINARIES_64 := $(VMTARGETS:%=%_64)
 
 ifeq ($(CAN_BUILD_WITH_NOPIE),1)
 CFLAGS += -no-pie
@@ -112,7 +112,7 @@ $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
-$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-32,$(t))))
+$(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
@@ -120,7 +120,7 @@ $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
-$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-64,$(t))))
+$(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
 # x86_64 users should be encouraged to install 32-bit libraries
_

Patches currently in -mm which might be from jsavitz@redhat.com are


