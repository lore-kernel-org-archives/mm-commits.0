Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B6AECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiIIVak (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiIIVah (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC5D9C523
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1F08CE2452
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66001C433D6;
        Fri,  9 Sep 2022 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759032;
        bh=5ADYOSlBqeQhQf8l2pDvuFL2x0QBsl/aVr7ZOkEL1kE=;
        h=Date:To:From:Subject:From;
        b=hwJMrrHwj9JJmCVHIWhOyUJVt0hyhQh23H2A3yhnV3vtBjMOvmg3Fh9DU6dtup/Wm
         okyx2scA/G9LUUQ8gLOCrbIZIU/2wyVNYB8Wc6cq5RaCsVUTGJNgfvycqUATjGN5KU
         RCr0CbQJ6wXHbGN+ZxilTwUlQp8/WjszG9PRaIhY=
Date:   Fri, 09 Sep 2022 14:30:31 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch added to mm-unstable branch
Message-Id: <20220909213032.66001C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon: rename the title of the document
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon: rename the title of the document
Date: Fri, 9 Sep 2022 20:28:58 +0000

The title of the DAMON document for admin-guide, 'Monitoring Data
Accesses', could confuse readers in some ways.  First of all, DAMON is not
the only single way for data access monitoring.  And the document is for
not only the data access monitoring but also data access pattern based
memory management optimizations (DAMOS).  This commit updates the title to
'DAMON: Data Access MONitor', which more explicitly explains what the
document describes.

Link: https://lkml.kernel.org/r/20220909202901.57977-5-sj@kernel.org
Fixes: c4ba6014aec3 ("Documentation: add documents for DAMON")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/index.rst~docs-admin-guide-mm-damon-rename-the-title-of-the-document
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-========================
-Monitoring Data Accesses
-========================
+==========================
+DAMON: Data Access MONitor
+==========================
 
 :doc:`DAMON </mm/damon/index>` allows light-weight data access monitoring.
 Using DAMON, users can analyze the memory access patterns of their systems and
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

