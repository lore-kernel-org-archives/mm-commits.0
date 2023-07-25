Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4811C0015E
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 17:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjGYRVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjGYRVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 13:21:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0A1985
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 10:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E594261802
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 17:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3A1C433C7;
        Tue, 25 Jul 2023 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690305663;
        bh=HlhCylAcZ5gXJaJzI01kibkT1iQJB/fjQL/kTLPy5g0=;
        h=Date:To:From:Subject:From;
        b=Ic7g28nprSZyPyKz+J8PRVW+oHdvtgOBH6ZI2ZGn7qIrp591zLP3X5oibf8HO9kJZ
         9XM0akzvNmqNkMdFWx6F6GgRPJBPHzYRTGsjWyZmYMVPGNuq6RNDK1sHhv5pT2LaWN
         ZJrfhEse4Z3Y7XMHKvSvQ3CgBRj/NR6sNjMcfHx0=
Date:   Tue, 25 Jul 2023 10:21:02 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, hughd@google.com,
        corbet@lwn.net, rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230725172103.3F3A1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fixup Docs table for huge mount options
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: tmpfs: fixup Docs table for huge mount options
Date: Mon, 24 Jul 2023 22:23:33 -0700

A table's header and footer lines must match its text columns in
width, so extend the header/footer for column 1 to match the text.

Fixes this documentation build error:
Documentation/filesystems/tmpfs.rst:116: ERROR: Malformed table.
Text in column margin in table line 4.

Link: https://lkml.kernel.org/r/20230725052333.26857-1-rdunlap@infradead.org
Fixes: a0ebb5aa2de3 ("tmpfs: fix Documentation of noswap and huge mount options")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/lkml/3084e97c-3a7d-ace8-2e9c-31642fd663df@google.com/T/#me28ed2124bca2e632eee86ff1d986e5c1f731a7c
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix
+++ a/Documentation/filesystems/tmpfs.rst
@@ -110,13 +110,13 @@ configured with CONFIG_TRANSPARENT_HUGEP
 your system (has_transparent_hugepage(), which is architecture specific).
 The mount options for this are:
 
-===========  ==============================================================
-huge=never   Do not allocate huge pages.  This is the default.
-huge=always  Attempt to allocate huge page every time a new page is needed.
+================ ==============================================================
+huge=never       Do not allocate huge pages.  This is the default.
+huge=always      Attempt to allocate huge page every time a new page is needed.
 huge=within_size Only allocate huge page if it will be fully within i_size.
-             Also respect madvise(2) hints.
-huge=advise  Only allocate huge page if requested with madvise(2).
-===========  ==============================================================
+                 Also respect madvise(2) hints.
+huge=advise      Only allocate huge page if requested with madvise(2).
+================ ==============================================================
 
 See also Documentation/admin-guide/mm/transhuge.rst, which describes the
 sysfs file /sys/kernel/mm/transparent_hugepage/shmem_enabled: which can
_

Patches currently in -mm which might be from rdunlap@infradead.org are

tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix.patch
hwpoison-offline-support-fix-spelling-in-documentation-abi.patch

