Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F251C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 03:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiBWD7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiBWD7c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 22:59:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFBC59A65
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 19:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BBBAB81C1F
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 03:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC2C340E7;
        Wed, 23 Feb 2022 03:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645588743;
        bh=AgrmWQeFvVWbNl05/LLy+b5BX6cw5qx+qHawOaPrcPc=;
        h=Date:To:From:Subject:From;
        b=kwOJN5qfk7zE1lXv+5QjWj7K1psgiVObPhNVw7GW+CneqLKBIghznAyOvm87EN+AF
         lOuuwIO8qdbHWSkJkuBpDUum09McPloTLdhXXXBve4+QRhZzjCq0OjPLcF+o/u8Ih2
         qNyNO6nz60FIikrjD6lYdYNEsh6bsmyDBdI8cU5g=
Date:   Tue, 22 Feb 2022 19:59:02 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch added to -mm tree
Message-Id: <20220223035902.F1EC2C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling
has been added to the -mm tree.  Its filename is
     docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling

In DAMON's early development stage before it be merged in the mainline, it
was first designed to work exclusively with Idle page tracking to avoid
any interference between each other.  Later, but still before be merged in
the mainline, because Idle page tracking is fully under the control of
sysadmins, we made the resolving of conflict as the responsibility of
sysadmins.  The document is not updated for the change, though.  This
commit updates the document for that.

Link: https://lkml.kernel.org/r/20220222170100.17068-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/design.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/vm/damon/design.rst~docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling
+++ a/Documentation/vm/damon/design.rst
@@ -84,9 +84,10 @@ table having a mapping to the address.
 and clear the bit(s) for next sampling target address and checks whether the
 bit(s) set again after one sampling period.  This could disturb other kernel
 subsystems using the Accessed bits, namely Idle page tracking and the reclaim
-logic.  To avoid such disturbances, DAMON makes it mutually exclusive with Idle
-page tracking and uses ``PG_idle`` and ``PG_young`` page flags to solve the
-conflict with the reclaim logic, as Idle page tracking does.
+logic.  DAMON does nothing to avoid disturbing Idle page tracking, so handling
+the interference is the responsibility of sysadmins.  However, it solves the
+conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
+as Idle page tracking does.
 
 
 Address Space Independent Core Mechanisms
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch
docs-vm-damon-call-low-level-monitoring-primitives-the-operations.patch
docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
docs-damon-update-outdated-term-regions-update-interval.patch

