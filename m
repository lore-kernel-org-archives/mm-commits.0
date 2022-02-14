Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C1EC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 22:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiBNWwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:52:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiBNWwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 17:52:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67D0DF11
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 14:52:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6070F614F8
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 22:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D8AC340E9;
        Mon, 14 Feb 2022 22:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644879145;
        bh=ux02WLDSEhuX9igTWt2ik/fJEUzpOwrK33GTv6DiNAU=;
        h=Date:To:From:Subject:From;
        b=xKHkfA0eSb4BH71KxLzrLwyaZHqCBFKWwVVtuQ4N5Xdfmg3BfFnhGma6EZutbxdcH
         mzm4C28urBRuUfedBySDBje2bMgqCzr0H9uWH1Hs7hOyN/xEBNaBWoq8d82vIjrmrR
         w28w7VCWQf9glC7TpsIFqho1888yWuMGSePPQBbI=
Date:   Mon, 14 Feb 2022 14:52:25 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        keescook@chromium.org, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-use-isystem-instead-of-i-to-include-headers.patch added to -mm tree
Message-Id: <20220214225225.A5D8AC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: use -isystem instead of -I to include headers
has been added to the -mm tree.  Its filename is
     selftests-use-isystem-instead-of-i-to-include-headers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-use-isystem-instead-of-i-to-include-headers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-use-isystem-instead-of-i-to-include-headers.patch

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
Subject: selftests: use -isystem instead of -I to include headers

Selftests need kernel headers and glibc for compilation.  In compilation
of selftests, uapi headers from kernel source are used instead of default
ones while glibc has already been compiled with different header files
installed in the operating system.  So there can be redefinition warnings
from compiler.  These warnings can be suppressed by using -isystem to
include the uapi headers.

Link: https://lkml.kernel.org/r/20220214160756.3543590-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/Makefile~selftests-use-isystem-instead-of-i-to-include-headers
+++ a/tools/testing/selftests/Makefile
@@ -129,11 +129,11 @@ ifneq ($(KBUILD_OUTPUT),)
   # $(realpath ...) resolves symlinks
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
-  KHDR_INCLUDES := -I${abs_objtree}/usr/include
+  KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
-  KHDR_INCLUDES := -I${abs_srctree}/usr/include
+  KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
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
selftests-use-isystem-instead-of-i-to-include-headers.patch

