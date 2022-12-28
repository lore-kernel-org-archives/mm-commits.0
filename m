Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6226C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 23:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiL1X3M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 18:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiL1X3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 18:29:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA15013F66
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 15:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C8F7B81913
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 23:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1FCC433F0;
        Wed, 28 Dec 2022 23:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672270136;
        bh=5vdh9v1xKxNPf2FTWt9jFTt1+VHNUOCvKLtqVSKHbG4=;
        h=Date:To:From:Subject:From;
        b=cr9n+W5bKzQwYyDafyqcpbFm9hgTgFrh1B6FxKU6DfBzym+0VX8hRdSpE35EIjQWV
         KnJ27zNqKeBAaUNL1Perp9mHnxbZfl708C2BF40ZnkN5l/eFJzqTrRKmbcZNyMXyeB
         vIIkQ2LAFsQlzNFdSo/o/XbrqUidKVUmlMM28ll8=
Date:   Wed, 28 Dec 2022 15:28:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-motorola-specify-pmd_page-type.patch added to mm-unstable branch
Message-Id: <20221228232855.EF1FCC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm/motorola: specify pmd_page() type
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-mm-motorola-specify-pmd_page-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-mm-motorola-specify-pmd_page-type.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: m68k/mm/motorola: specify pmd_page() type
Date: Mon, 26 Dec 2022 08:44:21 +0000

Failing to specify a specific type here breaks anything that relies on the
type being explicitly known, such as page_folio().

Make explicit the type of null pointer returned here.

Link: https://lkml.kernel.org/r/4b59f47ff4cd89ff76a5b6edbef6e8e0b37046f1.1672043615.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-motorola-specify-pmd_page-type
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -124,7 +124,7 @@ static inline void pud_set(pud_t *pudp,
  * expects pmd_page() to exists, only to then DCE it all. Provide a dummy to
  * make the compiler happy.
  */
-#define pmd_page(pmd)		NULL
+#define pmd_page(pmd)		((struct page *)NULL)
 
 
 #define pud_none(pud)		(!pud_val(pud))
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

