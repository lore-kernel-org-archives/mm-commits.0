Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459FFC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjC0U2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjC0U2P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A519935BF
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9BC9B81902
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5274C433D2;
        Mon, 27 Mar 2023 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679948891;
        bh=yF7qDCIagn78L7VjjCIsDOckjnkMEsBqfLq/zk/myHs=;
        h=Date:To:From:Subject:From;
        b=mYVJ8HiTQaU+oWeJ+EP1eYJzwbrUpJoAKgicovHPTsli54QlV3lVmajnqcoEOfmCg
         850QaIvC8gnTwfmH6z5driggSmaqFWUGjVNjrO+dCCTH/fYm+jJM/Y5jlmvoS0lSLt
         dL5YvBpkVMExH9D19e92rlPmOrSRMRApZ4fg2/no=
Date:   Mon, 27 Mar 2023 13:28:10 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] elf-document-some-de-facto-pt_-abi-quirks.patch removed from -mm tree
Message-Id: <20230327202811.A5274C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ELF: document some de-facto PT_* ABI quirks
has been removed from the -mm tree.  Its filename was
     elf-document-some-de-facto-pt_-abi-quirks.patch

This patch was dropped because an updated version will be merged

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

 Documentation/ELF/ELF.rst |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

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

