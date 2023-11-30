Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F2DC10DCE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377162AbjK3WX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377150AbjK3WXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3D41715
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:23:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76B2C433CA;
        Thu, 30 Nov 2023 22:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383003;
        bh=qB6K3s4oikiDTPcw2wl4u4leCrCZWIXUagPurnNZ+i8=;
        h=Date:To:From:Subject:From;
        b=0jnWK4Wi4SHH7E99ba/DxCt+cYwHalsPC3HLY7zjI+eYX+BsFCvH/QKhz1ywGJZud
         NvrWIztPj/47t3LUpdWuqQGZpCi9GQf1RC1dCoTIsuYnHq2EXMxBsidlRu+xabPZNp
         DCmFI1W11lNdFC96XkctC7wetjQdHH3/bF+Jn11M=
Date:   Thu, 30 Nov 2023 14:23:23 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-damos-quota-auto-tuning.patch added to mm-unstable branch
Message-Id: <20231130222323.C76B2C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: document DAMOS quota auto tuning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-damos-quota-auto-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-damos-quota-auto-tuning.patch

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
Subject: Docs/mm/damon/design: document DAMOS quota auto tuning
Date: Thu, 30 Nov 2023 02:36:50 +0000

Document the DAMOS quota auto tuning feature on the design document.

Link: https://lkml.kernel.org/r/20231130023652.50284-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-quota-auto-tuning
+++ a/Documentation/mm/damon/design.rst
@@ -346,6 +346,17 @@ the weight will be respected are up to t
 implementation.
 
 
+Aim-oriented Feedback-driven Auto-tuning
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Automatic feedback-driven quota tuning.  Instead of setting the absolute quota
+value, users can repeatedly provide numbers representing how much of their goal
+for the scheme is achieved as feedback.  DAMOS then automatically tunes the
+aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
+is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
+is over achieving the goal, it decreases the quota.
+
+
 .. _damon_design_damos_watermarks:
 
 Watermarks
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

