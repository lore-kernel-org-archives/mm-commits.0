Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BDEC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbiCVVk0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiCVVkU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FECCFF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1AA7B81D77
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48672C340EC;
        Tue, 22 Mar 2022 21:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985129;
        bh=/819+sq3ahm8VUreO7KPVHi7/M9kvrngEM4MD0yp4zU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=iu1fXYeqquvwjQCK7+6PMR6Ep6Pt5lo2F4eddZ4j15AR4I1y/N8Fw3Fqvc4pCT3Tc
         8FOTT1k0HtY2+NwEfFcaCvLVOyHqQXE9Ppgb1Qv7q9KWdIJch4Mo5mpxu0ZcS9cc8c
         afwf1RCLqF1HTZIgUSS6v5O+X32zSpZ9MYNYUmfc=
Date:   Tue, 22 Mar 2022 14:38:48 -0700
To:     trond.myklebust@hammerspace.com, philipp.reisner@linbit.com,
        paolo.valente@linaro.org, miklos@szeredi.hu,
        lars.ellenberg@linbit.com, konishi.ryusuke@gmail.com,
        jlayton@kernel.org, jaegeuk@kernel.org, jack@suse.cz,
        idryomov@gmail.com, fengguang.wu@intel.com, djwong@kernel.org,
        chao@kernel.org, axboe@kernel.dk, Anna.Schumaker@Netapp.com,
        neilb@suse.de, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 006/227] doc: convert 'subsection' to 'section' in gfp.h
Message-Id: <20220322213849.48672C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
