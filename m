Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA90EB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjG0UE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjG0UE4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:04:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752FDD9
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 13:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13C1061F28
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 20:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E10AC433CB;
        Thu, 27 Jul 2023 20:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488294;
        bh=W94v2m69yM6vVL+eqITiiHsKoTRGSe59dTQ6y3QY2Qk=;
        h=Date:To:From:Subject:From;
        b=mwqqDWt3K5CX53ensrNTChBj5NXgdnnA3DeslJLrLEePx5KatjyqKD5iLRZA2Nous
         iY+jdEZnzSyTyPKpLc5MvWv/z58BBLCONV1AzSEMNzCwCxogjNShOSLl7FhUmrVDZR
         e6yXj02k26S0uvyEE/KXCPJMDYlS0oDGqtOaqWjk=
Date:   Thu, 27 Jul 2023 13:04:53 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, hughd@google.com,
        corbet@lwn.net, rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix.patch removed from -mm tree
Message-Id: <20230727200454.5E10AC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs: fixup Docs table for huge mount options
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-documentation-of-noswap-and-huge-mount-options-fix.patch

This patch was dropped because it was folded into tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch

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

tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch
hwpoison-offline-support-fix-spelling-in-documentation-abi.patch

