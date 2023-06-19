Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A343EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjFSX1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjFSXZv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA7D1BD5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58B5F60F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C11C433C8;
        Mon, 19 Jun 2023 23:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217015;
        bh=R88cN/WN7on7s1swXGzGVTBjHu6Mu+q8DbNHcgXrVLg=;
        h=Date:To:From:Subject:From;
        b=ENkEAnC12EEoj/ZRCRCCW/ucHLmMbrcdHVg1guXT96GqDFbS5slw9+gDKDWJcJZVF
         9spgV+Qqq723h0Eb1ADqyNX7SmNcg4ebcBoapkLtq41OncutT/ag5H2XhIa2/16jmc
         NWZSiIdPov6CtUMZfxSkXoOqsxTXtEKeINbJAuys=
Date:   Mon, 19 Jun 2023 16:23:35 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch removed from -mm tree
Message-Id: <20230619232335.B2C11C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: clarify quotas and watermarks sysfs interface
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: clarify quotas and watermarks sysfs interface
Date: Fri, 16 Jun 2023 19:17:41 +0000

Explanation of DAMOS quotas and watermarks are not clearly explaining the
meaning and expectation of each file.  Add more clarification for those.

Link: https://lkml.kernel.org/r/20230616191742.87531-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-clarify-quotas-and-watermarks-sysfs-interface
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -306,7 +306,8 @@ Under the ``access_pattern`` directory,
 ``nr_accesses``, and ``age``) each having two files (``min`` and ``max``)
 exist.  You can set and get the access pattern for the given scheme by writing
 to and reading from the ``min`` and ``max`` files under ``sz``,
-``nr_accesses``, and ``age`` directories, respectively.
+``nr_accesses``, and ``age`` directories, respectively.  Note that the ``min``
+and the ``max`` form a closed interval.
 
 schemes/<N>/quotas/
 -------------------
@@ -320,7 +321,13 @@ Under ``quotas`` directory, three files
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
-respectively.  You can also set the :ref:`prioritization weights
+respectively.  Then, DAMON tries to use only up to ``time quota`` milliseconds
+for applying the ``action`` to memory regions of the ``access_pattern``, and to
+apply the action to only up to ``bytes`` bytes of memory regions within the
+``reset_interval_ms``.  Setting both ``ms`` and ``bytes`` zero disables the
+quota limits.
+
+You can also set the :ref:`prioritization weights
 <damon_design_damos_quotas_prioritization>` for size, access frequency, and age
 in per-thousand unit by writing the values to the three files under the
 ``weights`` directory.
_

Patches currently in -mm which might be from sj@kernel.org are


