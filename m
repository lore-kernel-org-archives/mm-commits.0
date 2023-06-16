Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB78DEB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 22:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbjFPWHB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345135AbjFPWGu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 18:06:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025283AB8
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 15:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCCC62064
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2808C433C0;
        Fri, 16 Jun 2023 22:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686953205;
        bh=rlecxEASzX3gYpfRTv4BPtB/e6Q/5H6d6Ge214xE2ag=;
        h=Date:To:From:Subject:From;
        b=wb7PWUCji54+/BuSm7rb26LGaq4i0sQVu6v7Ju7smbYiDpqydbiQnOxmqpEuBFYUM
         vXWXYCYVcx5nrrng8aS8CKelRcs2M+fOS7Nm+93u2yiO1Zf4ZjJL+PQF4LWRWgktOI
         bqkpq0FLgLMWF+Vg4TZ6RTrPeON0IoLKyhI3hpTs=
Date:   Fri, 16 Jun 2023 15:06:45 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch added to mm-unstable branch
Message-Id: <20230616220645.D2808C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: remove unnecessary sentences about supported address spaces
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch

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
Subject: Docs/admin-guide/mm/damon/usage: remove unnecessary sentences about supported address spaces
Date: Fri, 16 Jun 2023 19:17:39 +0000

Brief explanation of DAMON user space tool and sysfs interface are
unnecessarily and repeatedly mentioning the list of address spaces that
DAMON is supporting.  Remove those.

Link: https://lkml.kernel.org/r/20230616191742.87531-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -10,9 +10,8 @@ DAMON provides below interfaces for diff
   `This <https://github.com/awslabs/damo>`_ is for privileged people such as
   system administrators who want a just-working human-friendly interface.
   Using this, users can use the DAMON’s major features in a human-friendly way.
-  It may not be highly tuned for special cases, though.  It supports both
-  virtual and physical address spaces monitoring.  For more detail, please
-  refer to its `usage document
+  It may not be highly tuned for special cases, though.  For more detail,
+  please refer to its `usage document
   <https://github.com/awslabs/damo/blob/next/USAGE.md>`_.
 - *sysfs interface.*
   :ref:`This <sysfs_interface>` is for privileged user space programmers who
@@ -20,10 +19,9 @@ DAMON provides below interfaces for diff
   features by reading from and writing to special sysfs files.  Therefore,
   you can write and use your personalized DAMON sysfs wrapper programs that
   reads/writes the sysfs files instead of you.  The `DAMON user space tool
-  <https://github.com/awslabs/damo>`_ is one example of such programs.  It
-  supports both virtual and physical address spaces monitoring.  Note that this
-  interface provides only simple :ref:`statistics <damos_stats>` for the
-  monitoring results.  For detailed monitoring results, DAMON provides a
+  <https://github.com/awslabs/damo>`_ is one example of such programs.  Note
+  that this interface provides only simple :ref:`statistics <damos_stats>` for
+  the monitoring results.  For detailed monitoring results, DAMON provides a
   :ref:`tracepoint <tracepoint>`.
 - *debugfs interface. (DEPRECATED!)*
   :ref:`This <debugfs_interface>` is almost identical to :ref:`sysfs interface
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

