Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4B2C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 23:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B41A20796
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 23:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601682227;
	bh=wBftZ2wis/3YjDRHhsaZU8mfTjEl+b0v0U3AK7kQess=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hPiTAHQKWVy2qIgj5oqttfNVU71Q+GZ0NoYcSqHA4+4TrE9ImUHH0RRxB0SLHxcdz
	 bplCoOndmrRxR7vEvnveiz9GERwpc1eHH+NH77oZc2ynikYMp9HdV/iIPXfCAZCVe6
	 g1m1tSnrf2FnNh5S3RGNFR/tnno+xG16LAIyTHIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgJBXnr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 19:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJBXnq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 19:43:46 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C93206A2;
        Fri,  2 Oct 2020 23:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601682226;
        bh=wBftZ2wis/3YjDRHhsaZU8mfTjEl+b0v0U3AK7kQess=;
        h=Date:From:To:Subject:From;
        b=0xo7Gp5pUDSrDjscUHlob2ZaUjhnTmIOV2gbaSqzmIkdSwaKkSdezwFBCgH36WJWa
         FAHGSTqIS17dv7d7oAI3//Js/gREM4apj3bYf8JJm/aqrB6cygho/F0fxSpJ0LJp4w
         dcgQMyyESKvpOot92B0Hp7whfotndMHH3OJe46is=
Date:   Fri, 02 Oct 2020 16:43:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ujjwalkumar0501@gmail.com,
        michal.lkml@markovi.net, masahiroy@kernel.org,
        keescook@chromium.org, corbet@lwn.net, akpm@linux-foundation.org,
        lukas.bulwahn@gmail.com
Subject:  + kbuild-doc-describe-proper-script-invocation.patch added
 to -mm tree
Message-ID: <20201002234345.8Qp4z%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: doc: describe proper script invocation
has been added to the -mm tree.  Its filename is
     kbuild-doc-describe-proper-script-invocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kbuild-doc-describe-proper-script-invocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kbuild-doc-describe-proper-script-invocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: kbuild: doc: describe proper script invocation

During an investigation to fix up the execute bits of scripts in the
kernel repository, Andrew Morton and Kees Cook pointed out that the
execute bit should not matter, and that build scripts cannot rely on that.
Kees could not point to any documentation, though.

Masahiro Yamada explained the convention of setting execute bits to make
it easier for manual script invocation.

Provide some basic documentation how the build shall invoke scripts, such
that the execute bits do not matter, and acknowledge that execute bits are
useful nonetheless.

This serves as reference for further clean-up patches in the future.

Link: https://lore.kernel.org/lkml/20200830174409.c24c3f67addcce0cea9a9d4c@linux-foundation.org/
Link: https://lore.kernel.org/lkml/202008271102.FEB906C88@keescook/
Link: https://lore.kernel.org/linux-kbuild/CAK7LNAQdrvMkDA6ApDJCGr+5db8SiPo=G+p8EiOvnnGvEN80gA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20201001075723.24246-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ujjwal Kumar <ujjwalkumar0501@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/makefiles.rst |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/Documentation/kbuild/makefiles.rst~kbuild-doc-describe-proper-script-invocation
+++ a/Documentation/kbuild/makefiles.rst
@@ -21,6 +21,7 @@ This document describes the Linux kernel
 	   --- 3.10 Special Rules
 	   --- 3.11 $(CC) support functions
 	   --- 3.12 $(LD) support functions
+	   --- 3.13 Script Invocation
 
 	=== 4 Host Program support
 	   --- 4.1 Simple Host Program
@@ -605,6 +606,25 @@ more details, with real examples.
 		#Makefile
 		LDFLAGS_vmlinux += $(call ld-option, -X)
 
+3.13 Script invocation
+----------------------
+
+	Make rules may invoke scripts to build the kernel. The rules shall
+	always provide the appropriate interpreter to execute the script. They
+	shall not rely on the execute bits being set, and shall not invoke the
+	script directly. For the convenience of manual script invocation, such
+	as invoking ./scripts/checkpatch.pl, it is recommended to set execute
+	bits on the scripts nonetheless.
+
+	Kbuild provides variables $(CONFIG_SHELL), $(AWK), $(PERL),
+	$(PYTHON) and $(PYTHON3) to refer to interpreters for the respective
+	scripts.
+
+	Example::
+
+		#Makefile
+		cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
+			     $(KERNELRELEASE)
 
 4 Host Program support
 ======================
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

kbuild-doc-describe-proper-script-invocation.patch

