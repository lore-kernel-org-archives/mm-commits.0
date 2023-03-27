Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC634C761A6
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjC0U3c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjC0U3b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:29:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E521FD6
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140F5614E9
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AAFC433D2;
        Mon, 27 Mar 2023 20:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679948969;
        bh=W80SM4mitbUhX7G6/n4athq0QdBkvePa1FZXr6yh9gU=;
        h=Date:To:From:Subject:From;
        b=Fc6CC+1KNO/u+o25mO7ryPx+9x3fDjpGWECd9DaFXzqTn5sxdUbxeQQXXxLQwjaA+
         QcU3826cAJfIpTQFGSD8bX0RRD+1TNJs8WtUQoilN5jBHOhLUYp0R/luzwbg1M5IsM
         92UsDvQ2E1nkPmPjjWNbcXRIvflUZSN6rFRiIP5Q=
Date:   Mon, 27 Mar 2023 13:29:28 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        rdunlap@infradead.org, keescook@chromium.org,
        ebiederm@xmission.com, corbet@lwn.net, brauner@kernel.org,
        bagasdotme@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + elf-document-some-de-facto-pt_-abi-quirks.patch added to mm-nonmm-unstable branch
Message-Id: <20230327202929.61AAFC433D2@smtp.kernel.org>
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
elf-document-some-de-facto-pt_-abi-quirks.patch

