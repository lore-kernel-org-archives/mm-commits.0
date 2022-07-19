Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC4BC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiGSTGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiGSTGW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A799A45048
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4051F617D1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F73C341C6;
        Tue, 19 Jul 2022 19:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658257580;
        bh=DhyF3xOoNGCe5iH3lS9zrcyZ8+1BFk/djzZmedQmuAA=;
        h=Date:To:From:Subject:From;
        b=JfECrwB50Mb9nosv0yEZVTa1KIqWDuevUbkt0hAcHe1TDzT71Fjp7pOpVLdfwAxs1
         imUiKtJvIpvJsaAkFBHydO+I/vhwcqXvlV9PUTwqkw+z4LORCPQDv78MK0BNY200r/
         kb4JocnvpzR0R8WFD44PRLCHHG4z98Jk6ws6x+Ho=
Date:   Tue, 19 Jul 2022 12:06:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        lihongyu1999@bupt.edu.cn, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-2.patch added to mm-unstable branch
Message-Id: <20220719190620.79F73C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: drop typedef from header
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-2.patch

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
Subject: maple_tree: drop typedef from header
Date: Tue, 19 Jul 2022 17:10:15 +0000

These typedefs are not used and cause issues with rust in the kernel.

Link: https://lkml.kernel.org/r/20220719171006.3299123-1-Liam.Howlett@oracle.com
Fixes: fb7297e8a66b ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Li Hongyu <lihongyu1999@bupt.edu.cn>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix-2
+++ a/include/linux/maple_tree.h
@@ -72,8 +72,6 @@
  *   0x010 : 32 bit values, type in 0-2, slot in 3-6
  *   0x110 : 64 bit values, type in 0-2, slot in 3-6
  */
-typedef struct maple_enode *maple_enode; /* encoded node */
-typedef struct maple_pnode *maple_pnode; /* parent node */
 
 /*
  * This metadata is used to optimize the gap updating code and in reverse
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

