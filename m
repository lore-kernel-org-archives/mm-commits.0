Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCC4EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjFSX1a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjFSXZv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804AD10DB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 612DA60F32
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9822C433C8;
        Mon, 19 Jun 2023 23:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217012;
        bh=/FSxY20sCiBBeUjC/kuMyUzUcqt4U41gUEWYc0YzOdc=;
        h=Date:To:From:Subject:From;
        b=kxovUfvd21/4ZUJvTGjhnM+G913zVyGNhlqwEeEYULdAhSr8P8VaLDT6CgJB06lUY
         b4XcCvSzoWg8nfxxvpfjJ8THb2+XAzY10Iq7b+GGweTMarnQMwFPsXzf+i5MMb2xLL
         jYogM97RE/Vx3tkFnU8B3wMI0x5GPGhEyoOoZS28=
Date:   Mon, 19 Jun 2023 16:23:32 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch removed from -mm tree
Message-Id: <20230619232332.B9822C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix typos in references and commas
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix typos in references and commas
Date: Fri, 16 Jun 2023 19:17:38 +0000

Fix typos including a unnecessary comma and incomplete ':ref:' keywords.

Link: https://lkml.kernel.org/r/20230616191742.87531-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -139,7 +139,7 @@ scheme of the kdamond.  Writing ``clear_
 file clears the DAMON-based operating scheme action tried regions directory for
 each DAMON-based operation scheme of the kdamond.  For details of the
 DAMON-based operation scheme action tried regions directory, please refer to
-:ref:tried_regions section <sysfs_schemes_tried_regions>`.
+:ref:`tried_regions section <sysfs_schemes_tried_regions>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
@@ -282,7 +282,7 @@ memory regions having specific access pa
 that can be written to and read from the file and their meaning are as below.
 
 Note that support of each action depends on the running DAMON operations set
-`implementation <sysfs_contexts>`.
+:ref:`implementation <sysfs_contexts>`.
 
  - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
@@ -432,8 +432,7 @@ starting from ``0`` under this directory
 exposing detailed information about each of the memory region that the
 corresponding scheme's ``action`` has tried to be applied under this directory,
 during next :ref:`aggregation interval <sysfs_monitoring_attrs>`.  The
-information includes address range, ``nr_accesses``, , and ``age`` of the
-region.
+information includes address range, ``nr_accesses``, and ``age`` of the region.
 
 The directories will be removed when another special keyword,
 ``clear_schemes_tried_regions``, is written to the relevant
_

Patches currently in -mm which might be from sj@kernel.org are


