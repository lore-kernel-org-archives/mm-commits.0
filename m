Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EEBC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiLPX7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiLPX7m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D512473306
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B345622BF
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DFAC4339B;
        Fri, 16 Dec 2022 23:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235176;
        bh=uySf4vdeigBrPSPcbeuIaFa9mENMrjgv0NsY1rNGhaQ=;
        h=Date:To:From:Subject:From;
        b=n85lnt48IP5sFtXbohgmpO0IjzrMsIFt2XuWeg/9iQz/IDNWQLSJlhmt6jIZFs7dZ
         9Fdn/WUT/577ZJVEegvR468SQDk69+vlBlnhcXaTVe43jliMUBHmSBETfsgZLE62Zh
         as8yl1GQ3zPi+X4BKH7B/78fcIipDBjwUsJJ/tkE=
Date:   Fri, 16 Dec 2022 15:59:36 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch added to mm-unstable branch
Message-Id: <20221216235936.C0DFAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/damon/reclaim: document 'skip_anon' parameter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch

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
Subject: Docs/admin-guide/damon/reclaim: document 'skip_anon' parameter
Date: Mon, 5 Dec 2022 23:08:23 +0000

Document the newly added 'skip_anon' parameter of DAMON_RECLAIM, which can
be used to avoid anonymous pages reclamation.

Link: https://lkml.kernel.org/r/20221205230830.144349-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-damon-reclaim-document-skip_anon-parameter
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -205,6 +205,15 @@ The end physical address of memory regio
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
 and reclaims.  By default, biggest System RAM is used as the region.
 
+skip_anon
+---------
+
+Skip anonymous pages reclamation.
+
+If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+pages.  By default, ``N``.
+
+
 kdamond_pid
 -----------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch

