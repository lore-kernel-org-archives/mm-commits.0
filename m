Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F27C4321E
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJCVLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJCVK1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462875073D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93DD6611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E879AC433D6;
        Mon,  3 Oct 2022 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831213;
        bh=CuhCjvDTv6qkAfjs5munaFUaSZySXw0cQn+HCDa0BqU=;
        h=Date:To:From:Subject:From;
        b=g1+RxvucTyJPnSgIfUmtylxA+AsGvXET3T1DEm6PR0is7wGi5BYiKiLDPl0k4WZ2j
         snCrAPCGvG4Hgv0/S1k2Os8pltkFUxZTN02UDfAwGW52L2hzTavX/6fB21Qf/EeXKs
         NnAMOik20e0pDOs5U8DOW5frcAaWVWAbbK/5GkVQ=
Date:   Mon, 03 Oct 2022 14:06:52 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch removed from -mm tree
Message-Id: <20221003210652.E879AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon: rename the title of the document
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

