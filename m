Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F141AC47DBE
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjKNX0K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjKNX0J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:26:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC826D6
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:26:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C0FC433C8;
        Tue, 14 Nov 2023 23:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700004366;
        bh=P36D7wLwLgfeL0Vw6MkyPX1cfCpysxE1b8OpTZbB+iU=;
        h=Date:To:From:Subject:From;
        b=zt76cqR9GYfap9UvsKAdIT83ibn+znYDGXsDeu7ve2cQ30V8UNv09rdrySMkoK+0y
         cnEldfkoUlXa8TuS1iVvnEJ5tHhbLqyFFRTMK2f/C/y+XexqdBOmU4NLJSspzMl0lS
         xMy0AGf//6mwfTOV4kb7RPotW7/kXibxs4pLj7f4=
Date:   Tue, 14 Nov 2023 15:26:05 -0800
To:     mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers.patch added to mm-unstable branch
Message-Id: <20231114232606.69C0FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: drop pte_bad() descriptions from arch page table helpers
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers.patch

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
Subject: Documentation/mm: drop pte_bad() descriptions from arch page table helpers
Date: Tue, 14 Nov 2023 12:04:56 +0530

pte_bad() never existed unlike similar helpers at PMU, PUD, and PGD level.
This was added erroneously and hence should be dropped instead.

Link: https://lkml.kernel.org/r/20231114063456.339652-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    2 --
 1 file changed, 2 deletions(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -18,8 +18,6 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_same                  | Tests whether both PTE entries are the same      |
 +---------------------------+--------------------------------------------------+
-| pte_bad                   | Tests a non-table mapped PTE                     |
-+---------------------------+--------------------------------------------------+
 | pte_present               | Tests a valid mapped PTE                         |
 +---------------------------+--------------------------------------------------+
 | pte_young                 | Tests a young PTE                                |
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers.patch

