Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F20EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 21:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiGDV5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 17:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiGDV5r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 17:57:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C278EBE1F
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 14:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54FB16175C
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 21:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E0DC3411E;
        Mon,  4 Jul 2022 21:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656971865;
        bh=QRb1k14xuo5iSG1zTY1XUDIVUGm0nHhCnq4OCVe0jZ4=;
        h=Date:To:From:Subject:From;
        b=xtKTZII+kXGAMxqCsOq9CB0C1zcYolMGtng10u+bOKw+8odr5n2STTKkhAcRpAdo0
         P0mWLPiPH8yzLANhLY33PnKQutkg9QAz2plFMsuBknJ9KEfRiuyfI/AQ3+pByYVC8A
         h3HI5YRXLn51RFL+MbA3wRsqel8ehea3JWQO5sAw=
Date:   Mon, 04 Jul 2022 14:57:44 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix.patch added to mm-unstable branch
Message-Id: <20220704215745.A2E0DC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix.patch

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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix

build fix

Link: https://lkml.kernel.org/r/20220704070317.GA2473612@hori.linux.bs1.fc.nec.co.jp
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix
+++ a/mm/memory-failure.c
@@ -1664,6 +1664,7 @@ unlock:
 EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 #endif /* CONFIG_FS_DAX */
 
+#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Struct raw_hwp_page represents information about "raw error page",
  * constructing singly linked list originated from ->private field of
@@ -1786,7 +1787,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages-fix.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

