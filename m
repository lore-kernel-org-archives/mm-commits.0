Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8E8ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiIIVan (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiIIVam (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9D8A50D0
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F39FB8265B
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32936C433C1;
        Fri,  9 Sep 2022 21:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759038;
        bh=gW0uYACkKW/EAm+2iiDgsPD4B1A/mOUUdciAx4cjxdw=;
        h=Date:To:From:Subject:From;
        b=i/G8EfgDF7CjsxnAD2G++l/mQ0k5q6lNs+b27auKDTw3ZalzVUfMTToRxNpOrcoQa
         rTJFZYGu/CpYjN3+tzP14SXUJpIKYRZPSnbrcvCIwhdvdtmz2FbrGrlpGabzCfS+jI
         sBCQJQKKCIhdlhrDbBf/DZSOJY7njFO+vrPieSFQ=
Date:   Fri, 09 Sep 2022 14:30:37 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch added to mm-unstable branch
Message-Id: <20220909213038.32936C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: note DAMON debugfs interface deprecation plan
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

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
Subject: Docs/admin-guide/mm/damon/usage: note DAMON debugfs interface deprecation plan
Date: Fri, 9 Sep 2022 20:29:01 +0000

Commit b18402726bd1 ("Docs/admin-guide/mm/damon/usage: document DAMON
sysfs interface") announced the DAMON debugfs interface deprecation plan,
but it is not so aggressively announced.  As the deprecation time is
coming, this commit makes the announce more easy to be found by adding the
note at the beginning of the DAMON debugfs interface usage document.

Link: https://lkml.kernel.org/r/20220909202901.57977-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -393,6 +393,11 @@ the files as above.  Above is only for a
 debugfs Interface
 =================
 
+.. note::
+
+  DAMON debugfs interface will be removed after next LTS kernel is released, so
+  users should move to the :ref:`sysfs interface <sysfs_interface>`.
+
 DAMON exports eight files, ``attrs``, ``target_ids``, ``init_regions``,
 ``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` and
 ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
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

