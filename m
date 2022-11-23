Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D595C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 20:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiKWU0g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239874AbiKWU0Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 15:26:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFD98FFBB
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 12:21:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 131BEB82480
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 20:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F589C433C1;
        Wed, 23 Nov 2022 20:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669234881;
        bh=qLT4bp/CcF3PY9m1GsTg412732zQsWlavbqWzc7UhWQ=;
        h=Date:To:From:Subject:From;
        b=Xm+h5zKq4pYDceQrXTZNTm/GnNCjyM6HIR7M3Wvj2M944fzuzNuczbE5CFb1o4i+z
         pB0rGBsTaXyJxNuDK6fhr6n+CY4pWiDcO0UmX/z4kC0SrBJT8XlSlJneedbBPzuYVQ
         9+vDwSkraxXL1v/a993Nv272cp4oBz4eam+yQx8I=
Date:   Wed, 23 Nov 2022 12:21:20 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        corbet@lwn.net, aarcange@redhat.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch added to mm-unstable branch
Message-Id: <20221123202121.9F589C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: documentation/mm: update pmd_present() in arch_pgtable_helpers.rst
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: documentation/mm: update pmd_present() in arch_pgtable_helpers.rst
Date: Wed, 23 Nov 2022 10:43:19 +0530

Although pmd_present() might seem to indicate a valid and mapped pmd
entry, in reality it returns true when pmd_page() points to a valid page
in memory , regardless whether the pmd entry is mapped or not.  Andrea
Arcangeli had earlier explained [1] the required semantics for
pmd_present().  This just updates the documentation for pmd_present() as
required.

[1] https://lore.kernel.org/lkml/20181017020930.GN30832@redhat.com/

Link: https://lkml.kernel.org/r/20221123051319.1312582-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -94,7 +94,7 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_trans_huge            | Tests a Transparent Huge Page (THP) at PMD       |
 +---------------------------+--------------------------------------------------+
-| pmd_present               | Tests a valid mapped PMD                         |
+| pmd_present               | Tests whether pmd_page() points to valid memory  |
 +---------------------------+--------------------------------------------------+
 | pmd_young                 | Tests a young PMD                                |
 +---------------------------+--------------------------------------------------+
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch

