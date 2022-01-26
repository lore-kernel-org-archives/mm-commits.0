Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A191CC5AC75
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 01:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiAZBsw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiAZBsv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 20:48:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897FEC06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 17:48:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB461B81AC6
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 01:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2306EC340E0;
        Wed, 26 Jan 2022 01:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643161727;
        bh=UXLita449QdDoyWv+6HcOxPpicWrNWkil6mruFUsk6k=;
        h=Date:From:To:Subject:From;
        b=imse0yB58C5f/zbn4wmqsOEIHTAfPkNIQPakgRHCp+lJWL0GjivD9LpdUSTEM308/
         BG0e4MISmckuJRYxkQZ1rEgEPYpZxVCc2yaM+b6WVsdL2odJMJmJyPzd0/CEUPmVow
         Oe1bgPMhX2LTrQnKuJwsgXLb/B67pPNM3eS7RZxk=
Date:   Tue, 25 Jan 2022 17:48:46 -0800
From:   akpm@linux-foundation.org
To:     andrealmeid@collabora.com, apopple@nvidia.com,
        chi.minghao@zte.com.cn, dave@stgolabs.net, davem@davemloft.net,
        dvhart@infradead.org, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mic@digikod.net, mingo@redhat.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, shuah@kernel.org,
        tglx@linutronix.de, usama.anjum@collabora.com
Subject:  +
 selftests-add-and-export-a-kernel-uapi-headers-path.patch added to -mm tree
Message-ID: <20220126014846.4eImQBN5L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add and export a kernel uapi headers path
has been added to the -mm tree.  Its filename is
     selftests-add-and-export-a-kernel-uapi-headers-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-add-and-export-a-kernel-uapi-headers-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-and-export-a-kernel-uapi-headers-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: add and export a kernel uapi headers path

Kernel uapi headers can be present at different paths depending upon how
the build was invoked.  It becomes impossible for the tests to include the
correct headers directory.  Set and export KHDR_INCLUDES variable to make
it possible for sub make files to include the header files.

Link: https://lkml.kernel.org/r/20220119101531.2850400-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andr Almeida <andrealmeid@collabora.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Mickal Salan <mic@digikod.net>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/Makefile~selftests-add-and-export-a-kernel-uapi-headers-path
+++ a/tools/testing/selftests/Makefile
@@ -129,8 +129,11 @@ ifneq ($(KBUILD_OUTPUT),)
   # $(realpath ...) resolves symlinks
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
+  KHDR_INCLUDES := -I${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
+  abs_srctree := $(shell cd $(top_srcdir) && pwd)
+  KHDR_INCLUDES := -I${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
@@ -139,6 +142,7 @@ include $(top_srcdir)/scripts/subarch.in
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
 export BUILD
+export KHDR_INCLUDES
 
 # set default goal to all, so make without a target runs all, even when
 # all isn't the first target in the file.
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-set-the-build-variable-to-absolute-path.patch
selftests-add-and-export-a-kernel-uapi-headers-path.patch
selftests-correct-the-headers-install-path.patch
selftests-futex-add-the-uapi-headers-include-variable.patch
selftests-kvm-add-the-uapi-headers-include-variable.patch
selftests-landlock-add-the-uapi-headers-include-variable.patch
selftests-net-add-the-uapi-headers-include-variable.patch
selftests-mptcp-add-the-uapi-headers-include-variable.patch
selftests-vm-add-the-uapi-headers-include-variable.patch
selftests-vm-remove-dependecy-from-internal-kernel-macros.patch

