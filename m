Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA99C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiLAAAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLAAAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC64B7E425
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D81DB81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3C8C433C1;
        Thu,  1 Dec 2022 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852817;
        bh=giD63DRJUKx+gOsrmibcw0mE0dSEweldnTiQvVaGZ3s=;
        h=Date:To:From:Subject:From;
        b=iPGZyGCmp/h5f0hs7A8jFKD7wqtR+IJfFB6pYiEvWpSyhv7jBFLDELoZrS4B+9OUe
         Djp6j+ETayTcKDV1/7PnbgkFs/pWM7wbTpcA2l+3yD4rhQcwZwB4E36dtUVU9KwgXK
         TFg0Eyj4w9oCjOR/CUS0zQ1uzv/ZDh+cwOhTFJxs=
Date:   Wed, 30 Nov 2022 16:00:16 -0800
To:     mm-commits@vger.kernel.org, vpetrucci@gmail.com, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch removed from -mm tree
Message-Id: <20221201000017.1B3C8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: describe the rules of sysfs region directories
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: describe the rules of sysfs region directories
Date: Mon, 24 Oct 2022 17:46:18 +0000

Patch series "Docs/admin-buide/mm/damon/usage: minor fixes".

DAMON usage document contains an unclear description and a wrong usage
example.  This patchset fixes the two minor problems.


This patch (of 2):

Target region directories of DAMON sysfs interface should contain no
overlap and sorted by the address, but not clearly documented.  Actually,
a user had an issue[1] due to the poor documentation.  Add clear
description of it on the usage document.

[1] https://lore.kernel.org/damon/CAEZ6=UNUcH2BvJj++OrT=XQLdkidU79wmCO=tantSOB36pPNTg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221024174619.15600-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20221024174619.15600-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Vinicius Petrucci <vpetrucci@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -235,6 +235,9 @@ In each region directory, you will find
 can set and get the start and end addresses of the initial monitoring target
 region by writing to and reading from the files, respectively.
 
+Each region should not overlap with others.  ``end`` of directory ``N`` should
+be equal or smaller than ``start`` of directory ``N+1``.
+
 contexts/<N>/schemes/
 ---------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are


