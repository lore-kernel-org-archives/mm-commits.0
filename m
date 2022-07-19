Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BCFC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiGSTi1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiGSTi0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:38:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D444504C
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B43C6185D
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612A0C341C6;
        Tue, 19 Jul 2022 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658259504;
        bh=ls7U2o7t1RO/hb3PoukxKmAqoKB49q8WCIQxec8C6Y8=;
        h=Date:To:From:Subject:From;
        b=XSphPY6DTD8fekGJzq9lWIiPbqoWx2OujWvUVsVsAjo1oW+wawF+zS1hZx/CUN/yY
         ca1et1lMwfcZ9k+Uv0YmX8IYGH6p5Gf/4CwKlacINk48P2thGIwYAac1eO2T+sJtIj
         tOLml+/zONlk0o6DfcSv75a2qeQWrzz+hXTzIwg0=
Date:   Tue, 19 Jul 2022 12:38:23 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-3.patch added to mm-unstable branch
Message-Id: <20220719193824.612A0C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_empty_area() wrapping
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-3.patch

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
Subject: maple_tree: fix mas_empty_area() wrapping
Date: Tue, 19 Jul 2022 17:01:30 +0000

Set the error code correctly when at the left most node and search has
been exhausted.  This was an overflow bug.

Link: https://lkml.kernel.org/r/20220719170118.3296447-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-3
+++ a/lib/maple_tree.c
@@ -4994,7 +4994,7 @@ static inline bool mas_anode_descend(str
 		}
 next_slot:
 		min = pivot + 1;
-		if (mas->last < min) {
+		if (mas->last <= pivot) {
 			mas_set_err(mas, -EBUSY);
 			return true;
 		}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
maple-tree-add-new-data-structure-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

