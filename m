Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8DCC63797
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjALV7X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbjALV7C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:59:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477046B594
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC763B82033
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584C3C433EF;
        Thu, 12 Jan 2023 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673560209;
        bh=cAbZZVwMHt96F4XXmtviax/PywUHu6y0w5/8BEr1o9Y=;
        h=Date:To:From:Subject:From;
        b=XWV7/wd3Jd3hDZ5aMwz/FrUL4MMBIN+K7tnUkuUeDpTAhxrfV2ROLMk7ffRoJCuGW
         W6NrmiI9eTl5Y13WxLzqf9UyLWjObK7UDOHU4/uafDEuhOoQ28CDTIv1EHoPFipSBf
         NUdFz8vydVZIjCBTaM7PoCroml4C+7arkdaPg77o=
Date:   Thu, 12 Jan 2023 13:50:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-motorola-specify-pmd_page-type.patch added to mm-unstable branch
Message-Id: <20230112215009.584C3C433EF@smtp.kernel.org>
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
Date: Thu, 12 Jan 2023 12:39:30 +0000

Failing to specify a specific type here breaks anything that relies on the
type being explicitly known, such as page_folio().

Make explicit the type of null pointer returned here.

Link: https://lkml.kernel.org/r/ad6be2821bbd6af10966b3704568ff458b270d9c.1673526881.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/motorola_pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

