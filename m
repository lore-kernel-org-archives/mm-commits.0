Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5866EB64DA
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 22:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbjFPWGu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343977AbjFPWGs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 18:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4928D3AB5
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 15:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E3A625CA
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38763C433C0;
        Fri, 16 Jun 2023 22:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686953204;
        bh=W0EnWHXE8DzZ1KYWl/7DnBYgYwDiHRWKUm/Kxxc+tK4=;
        h=Date:To:From:Subject:From;
        b=m3OjjSicBranssZmHprggRyYeIEY7IFImyrcNEdIydl9TGgidhGbGYSudm7T7mI/z
         zprh0YvlLHRn29yR0bopyBuqlw77hYfwy/dXQCLFFozvcYSZuk5usoVW1RneLgDICD
         kdnz8oUC6J0fyegtnRtiUAhGeMXTdbO5lm14YqMQ=
Date:   Fri, 16 Jun 2023 15:06:43 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch added to mm-unstable branch
Message-Id: <20230616220644.38763C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix typos in references and commas
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch

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

mm-damon-core-test-add-a-test-for-damon_set_attrs.patch
docs-mm-damon-design-document-age-of-region.patch
docs-admin-guide-mm-damon-start-update-damos-example-command.patch
docs-admin-guide-mm-damon-usage-fix-typos-in-references-and-commas.patch
docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch
docs-admin-guide-mm-damon-usage-link-design-document-for-damos.patch
docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-update-the-ways-for-getting-monitoring-results.patch

