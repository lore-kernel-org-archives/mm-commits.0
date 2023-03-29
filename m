Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB403C6FD18
	for <mm-commits@archiver.kernel.org>; Wed, 29 Mar 2023 18:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjC2SvL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Mar 2023 14:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjC2SvK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2023 14:51:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936404C3A
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 11:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B133B8241B
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 18:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB76C433D2;
        Wed, 29 Mar 2023 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680115867;
        bh=V1cr5MwJeC5jCieVSRP127Kib/BtIiMTlymw5uS3H74=;
        h=Date:To:From:Subject:From;
        b=jpQ1roi8TA/QoAx08qDaRE4GerTpInPbSs+tdRM/qgVU0DNxAatDv6+w0h+99/FRf
         +12+mvkK58B+U8lyTNNUbZMB2Vc+swWKgQ9fzFhTshCQJstfwcRHwr5CB5OtN4wQvB
         tQgX28Pl+3AFci5FtwZl9qBjqA/S+Atr+D0ur6kI=
Date:   Wed, 29 Mar 2023 11:51:06 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        rdunlap@infradead.org, keescook@chromium.org,
        ebiederm@xmission.com, corbet@lwn.net, brauner@kernel.org,
        bagasdotme@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] elf-document-some-de-facto-pt_-abi-quirks.patch removed from -mm tree
Message-Id: <20230329185106.EBB76C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ELF: document some de-facto PT_* ABI quirks
has been removed from the -mm tree.  Its filename was
     elf-document-some-de-facto-pt_-abi-quirks.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF: document some de-facto PT_* ABI quirks
Date: Sun, 26 Mar 2023 19:49:49 +0300

Turns out rules about PT_INTERP, PT_GNU_STACK and PT_GNU_PROPERTY
program headers are slightly different.

Link: https://lkml.kernel.org/r/c4233c97-306c-4db8-9667-34fc31ec4aed@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ELF/ELF.rst   |   32 ++++++++++++++++++++++++++++++++
 Documentation/ELF/index.rst |   10 ++++++++++
 Documentation/index.rst     |    1 +
 3 files changed, 43 insertions(+)

--- /dev/null
+++ a/Documentation/ELF/ELF.rst
@@ -0,0 +1,32 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+Linux-specific ELF idiosyncrasies
+=================================
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
--- /dev/null
+++ a/Documentation/ELF/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+ELF
+===
+
+.. toctree::
+   :maxdepth: 1
+
+   ELF
--- a/Documentation/index.rst~elf-document-some-de-facto-pt_-abi-quirks
+++ a/Documentation/index.rst
@@ -113,6 +113,7 @@ to ReStructured Text format, or are simp
    :maxdepth: 1
 
    staging/index
+   ELF/index
 
 
 Translations
_

Patches currently in -mm which might be from adobriyan@gmail.com are

mm-uninline-kstrdup.patch
elf-fix-all-elf-typos.patch

