Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94808C6FD1F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCNVau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCNVat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:30:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAAF2F789
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA9C0B81BBD
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F57C433EF;
        Tue, 14 Mar 2023 21:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678829444;
        bh=r4AtZnKCSUPGGbNlTpRNSZMiJkI/ESFIx1UnjnPO6cI=;
        h=Date:To:From:Subject:From;
        b=kCX/7JCPJzNmdBEmkzhRt75ciHpD2ck8/iMZd5hsShyhof1ogfFkBD7pR+cYhMNb5
         wpBaRPDMcjQ3Pw41JLP49eJA5ft4ClLG6OUf7e4s7mXCpgT+BScEnqbanH12Zb7EJZ
         +CxZUdIbWPllucaZpfimGGWhQThW1Q0MbrLUpD1w=
Date:   Tue, 14 Mar 2023 14:30:43 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + elf-document-some-de-facto-pt_-abi-quirks.patch added to mm-nonmm-unstable branch
Message-Id: <20230314213044.99F57C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF: document some de-facto PT_* ABI quirks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     elf-document-some-de-facto-pt_-abi-quirks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/elf-document-some-de-facto-pt_-abi-quirks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF: document some de-facto PT_* ABI quirks
Date: Tue, 14 Mar 2023 20:02:21 +0300

Turns out rules about PT_INTERP, PT_GNU_STACK and PT_GNU_PROPERTY
segment headers are slightly different.

Link: https://lkml.kernel.org/r/2acb586c-08a9-42d9-a41e-7986cc1383ea@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- /dev/null
+++ a/Documentation/ELF/ELF.rst
@@ -0,0 +1,28 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Definitions
+===========
+
+"First" program header is the one with the smallest offset in the file:
+e_phoff. "Last" program header is the one with the biggest offset:
+e_phoff + (e_phnum - 1) * sizeof(Elf_Phdr).
+
+PT_INTERP
+=========
+
+First PT_INTERP program header is used to locate the filename of ELF
+interpreter. Other PT_INTERP headers are ignored (since Linux 2.4.11).
+
+PT_GNU_STACK
+============
+
+Last PT_GNU_STACK program header defines userspace stack executability
+(since Linux 2.6.6). Other PT_GNU_STACK headers are ignored.
+
+PT_GNU_PROPERTY
+===============
+
+ELF interpreter's last PT_GNU_PROPERTY program header is used (since
+Linux 5.8). If interpreter doesn't have one, then the last PT_GNU_PROPERTY
+program header of an executable is used. Other PT_GNU_PROPERTY headers
+are ignored.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

mm-uninline-kstrdup.patch
elf-fix-all-elf-typos.patch
elf-document-some-de-facto-pt_-abi-quirks.patch

