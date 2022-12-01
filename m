Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0F7C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiLAALW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiLAAKD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1675D89326
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D3A61E6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03258C4347C;
        Thu,  1 Dec 2022 00:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852991;
        bh=28UhDAe1Fxw4UAgkXgZE/4ksOnxJWPZaKFjOUz/A/kM=;
        h=Date:To:From:Subject:From;
        b=fx0pztFbIb5zUL6pXFf4dmseGm9JmEcKb4WFrQq82qWGgAtX9bpXm6nUhBO9xJc+2
         T4VM4vhPBidNtI9Rj3bBby/HaCu38hrosjpBgkksfs3xPloYvkHnJPsNOleG3OeyhG
         2tuUIh0JBBhPwowMd+q8Yri1l/FNR+/9JMv7u8WA=
Date:   Wed, 30 Nov 2022 16:03:10 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        corbet@lwn.net, aarcange@redhat.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch removed from -mm tree
Message-Id: <20221201000311.03258C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: documentation/mm: update pmd_present() in arch_pgtable_helpers.rst
has been removed from the -mm tree.  Its filename was
     documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


