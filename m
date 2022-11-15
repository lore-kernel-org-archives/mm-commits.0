Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDA7C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbiKOArW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiKOArU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E051DA44
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5565B810FA
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509F7C433D7;
        Tue, 15 Nov 2022 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668473237;
        bh=ZWEex2GMUFVDhV7QZupl+4as6Yj6HfA+7hPSuAngs2Y=;
        h=Date:To:From:Subject:From;
        b=Tl3vV50LzzYMl81MNg56DOlyNaZF5BAm+/dw8i926FzTGGDc//e8zmP9Hp601ri0r
         4p+5slroJsKC69JnPBpVvnCLAEReylpDUy3R1zwTc1yY6i2qX0wyQXSvRST/lotbt+
         BmV45d1A19v6AERC2UNbYtftOEPhkwN10pqO2vas=
Date:   Mon, 14 Nov 2022 16:47:16 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch added to mm-unstable branch
Message-Id: <20221115004717.509F7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: sanity check write bit for uffd-wp protected ptes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: sanity check write bit for uffd-wp protected ptes
Date: Sun, 13 Nov 2022 19:04:47 -0500

Let's add one sanity check for CONFIG_DEBUG_VM on the write bit in
whatever chance we have when walking through the pgtables.  It can bring
the error earlier even before the app notices the data was corrupted on
the snapshot.  Also it helps us to identify this is a wrong pgtable setup,
so hopefully a great information to have for debugging too.

Link: https://lkml.kernel.org/r/20221114000447.1681003-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h~mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes
+++ a/arch/x86/include/asm/pgtable.h
@@ -291,7 +291,23 @@ static inline pte_t pte_clear_flags(pte_
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	return pte_flags(pte) & _PAGE_UFFD_WP;
+	bool wp = pte_flags(pte) & _PAGE_UFFD_WP;
+
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * Having write bit for wr-protect-marked present ptes is fatal,
+	 * because it means the uffd-wp bit will be ignored and write will
+	 * just go through.
+	 *
+	 * Use any chance of pgtable walking to verify this (e.g., when
+	 * page swapped out or being migrated for all purposes). It means
+	 * something is already wrong.  Tell the admin even before the
+	 * process crashes. We also nail it with wrong pgtable setup.
+	 */
+	WARN_ON_ONCE(wp && pte_write(pte));
+#endif
+
+	return wp;
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch
mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch

