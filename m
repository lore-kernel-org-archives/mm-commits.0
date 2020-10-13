Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EBAC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5329921D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632887;
	bh=UHDO2kbLumbCRFdsNcCHbIRs0caO3uvCsH9z0iS+Q9k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aFc3XipDC3F71ycTSk9C+z5cHyZziiuTANRK4Hq9QznD4EfsWJ+9HvCRiPT7+f5CT
	 Ivf/dB+oBByPQ8rz+ZbsVOI+GmHqRdhLVNAy1FTAHf9590RA2niQhePCobh1KqsbGz
	 5/D5tmjU0CQDLjjSSVta04lgYfiskfPyIiguSfAQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbgJMXsH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFAF021582;
        Tue, 13 Oct 2020 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632886;
        bh=UHDO2kbLumbCRFdsNcCHbIRs0caO3uvCsH9z0iS+Q9k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U/RtUieH1vVXrPZRH6D5tqHI2hOz1FaZcKKRMBsmq7r2CrsjqieGIr3wqXP7Ra+Yk
         UoDOvnr2pprwFfYrDbcyDkMCE2iyPpqCgjk+DJlYVRMk9C8zfdF31e11esQk1NRzq2
         ZOfFxagtL2jrr/npy46Qq+Ci8Zk7nFVunvq9u00Q=
Date:   Tue, 13 Oct 2020 16:48:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, keescook@chromium.org,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ujjwalkumar0501@gmail.com
Subject:  [patch 010/181] kbuild: doc: describe proper script
 invocation
Message-ID: <20201013234805.CImnJB6vD%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
