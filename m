Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B33C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357313AbiCYBbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357323AbiCYBbT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3461A29C90
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7431B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9577CC340EC;
        Fri, 25 Mar 2022 01:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171782;
        bh=PngIsjenq1mpJ2Nur/1nbnb/uUhw1KVTEtfsgeDJ6SI=;
        h=Date:To:From:Subject:From;
        b=tcSTT209jz2rDN52vYb5xhYKATzmAdlDbE7BYn1cshqz07y6DW/1MZCLX+ItYiYij
         4iXBZAi3o++IyZGXE5le38Nd68rT09laqhUiAqFHWiAB/4xBmzzpAbLkLHeJX/KnsP
         kdVaYewUbqYC2M94xH9qqrx/nrj1VcuUI2WbbKS8=
Date:   Thu, 24 Mar 2022 18:29:41 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] doc-convert-subsection-to-section-in-gfph.patch removed from -mm tree
Message-Id: <20220325012942.9577CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: convert 'subsection' to 'section' in gfp.h
has been removed from the -mm tree.  Its filename was
     doc-convert-subsection-to-section-in-gfph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: doc: convert 'subsection' to 'section' in gfp.h

Patch series "Remove remaining parts of congestion tracking code", v2.


This patch (of 11):

Various DOC: sections in gfp.h have subsection headers (~~~) but the place
where they are included in mm-api.rst does not have section, only
chapters.

So convert to section headers (---) to avoid confusion.  Specifically if
sections are added later in mm-api.rst, an error results.

Link: https://lkml.kernel.org/r/164549971112.9187.16871723439770288255.stgit@noble.brown
Link: https://lkml.kernel.org/r/164549983733.9187.17894407453436115822.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/gfp.h~doc-convert-subsection-to-section-in-gfph
+++ a/include/linux/gfp.h
@@ -79,7 +79,7 @@ struct vm_area_struct;
  * DOC: Page mobility and placement hints
  *
  * Page mobility and placement hints
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * ---------------------------------
  *
  * These flags provide hints about how mobile the page is. Pages with similar
  * mobility are placed within the same pageblocks to minimise problems due
@@ -112,7 +112,7 @@ struct vm_area_struct;
  * DOC: Watermark modifiers
  *
  * Watermark modifiers -- controls access to emergency reserves
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * ------------------------------------------------------------
  *
  * %__GFP_HIGH indicates that the caller is high-priority and that granting
  * the request is necessary before the system can make forward progress.
@@ -144,7 +144,7 @@ struct vm_area_struct;
  * DOC: Reclaim modifiers
  *
  * Reclaim modifiers
- * ~~~~~~~~~~~~~~~~~
+ * -----------------
  * Please note that all the following flags are only applicable to sleepable
  * allocations (e.g. %GFP_NOWAIT and %GFP_ATOMIC will ignore them).
  *
@@ -224,7 +224,7 @@ struct vm_area_struct;
  * DOC: Action modifiers
  *
  * Action modifiers
- * ~~~~~~~~~~~~~~~~
+ * ----------------
  *
  * %__GFP_NOWARN suppresses allocation failure reports.
  *
@@ -256,7 +256,7 @@ struct vm_area_struct;
  * DOC: Useful GFP flag combinations
  *
  * Useful GFP flag combinations
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * ----------------------------
  *
  * Useful GFP flag combinations that are commonly used. It is recommended
  * that subsystems start with one of these combinations and then set/clear
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

