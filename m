Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12D7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 16:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiGMQRc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 12:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiGMQRb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 12:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59575140E
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 09:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8075461B0E
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 16:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C66C34114;
        Wed, 13 Jul 2022 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657729049;
        bh=nGMuFjYrxqVx0/lwU6qj0lWWxPOR/S8qFxkJgPeFI08=;
        h=Date:To:From:Subject:From;
        b=xEJw6/6J8KIlZVGhGOEPOnEfKoqo+bOcioZ/QljNuONlBzvVw5Z7Rgxo1hnEmPg50
         vmn9bvIOvhTDwCe/BFqxmPgWVWgqVAAnDkhp3oiO8uUWSk3Az0Cl8k5hWUCRLV7Gky
         vGBAcvsJnjLz9FxYfWN0H3WlfRK9nJonoKxyaRF0=
Date:   Wed, 13 Jul 2022 09:17:28 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch added to mm-unstable branch
Message-Id: <20220713161729.C6C66C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_maple_tree: fix accounting in check_erase2_testset()
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: test_maple_tree: fix accounting in check_erase2_testset()
Date: Tue, 12 Jul 2022 14:53:11 +0000

When overwriting an empty area, do not decrement the number of expected
entries.

Link: https://lkml.kernel.org/r/20220712145303.4191493-1-Liam.Howlett@oracle.com
Fixes: 51282228cdd4 (lib/test_maple_tree: add testing for maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_maple_tree.c~lib-test_maple_tree-add-testing-for-maple-tree-fix-3
+++ a/lib/test_maple_tree.c
@@ -1486,7 +1486,8 @@ static noinline void check_erase2_testse
 		switch (set[i]) {
 		case SNULL:
 			if ((s_min == set[i+1]) && (s_max == set[i+2])) {
-				entry_count--;
+				if (s_entry)
+					entry_count--;
 			} else if ((s_min != set[i+1]) && (s_max != set[i+2])) {
 				entry_count++;
 			} else if ((mas_start.node != mas_end.node) ||
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

