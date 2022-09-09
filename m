Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3B2ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiIIVaj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiIIVag (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FFE8B993
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03402620FD
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEEBC433B5;
        Fri,  9 Sep 2022 21:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759034;
        bh=gNbxzaOdxqFOSN3P3Qenl54Wjc/pEIB+LVuTGCwS3wQ=;
        h=Date:To:From:Subject:From;
        b=oD8/cwiQmICaSKSS+kayqYsSuQ6TEgzxnxHxDxakoHBNwTYuLexW6LugzGL6TLSIr
         XDNdsbHUlQLtR4zrgsg4kPa1DFTpBsjYGeiA7ohNjXU1fIFytmsg3m73DHtpVwzy5j
         fHje1DM/O06hVCixZ718ej8F8ngGqOBVTDj1NfI0=
Date:   Fri, 09 Sep 2022 14:30:33 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-kconfig-notify-debugfs-deprecation-plan.patch added to mm-unstable branch
Message-Id: <20220909213034.4FEEBC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/Kconfig: notify debugfs deprecation plan
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-kconfig-notify-debugfs-deprecation-plan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-kconfig-notify-debugfs-deprecation-plan.patch

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
Subject: mm/damon/Kconfig: notify debugfs deprecation plan
Date: Fri, 9 Sep 2022 20:28:59 +0000

Commit b18402726bd1 ("Docs/admin-guide/mm/damon/usage: document DAMON
sysfs interface") announced the DAMON debugfs interface deprecation plan,
but it is not so aggressively announced.  As the deprecation time is
coming, this commit makes the announce more easy to be found by adding the
note to the config menu of DAMON debugfs interface.

Link: https://lkml.kernel.org/r/20220909202901.57977-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-kconfig-notify-debugfs-deprecation-plan
+++ a/mm/damon/Kconfig
@@ -68,6 +68,9 @@ config DAMON_DBGFS
 
 	  If unsure, say N.
 
+	  This will be removed after >5.15.y LTS kernel is released, so users
+	  should move to the sysfs interface (DAMON_SYSFS).
+
 config DAMON_DBGFS_KUNIT_TEST
 	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
 	depends on DAMON_DBGFS && KUNIT=y
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

