Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819C2EB64D8
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 22:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbjFPWGt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbjFPWGs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 18:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AFB2110
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 15:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 462FA62064
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A523C433C8;
        Fri, 16 Jun 2023 22:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686953202;
        bh=KRJwKxGmHyygP7CdPdnNYhltVLn8mMzBS9gVF8Pmdws=;
        h=Date:To:From:Subject:From;
        b=XVplbDHhDPIo7L1wp5hLmwK4B0VpGIEzILfNbXhx21/158U4OtO8KCMDYCBxyuepZ
         LsnVU8fggZ8pYxGJKofCvWHWzK8MLKWcjBhvpT2au76mqhnC6mYEyhdSWECTBlI8n/
         UUl0UXkHrbNfQialSjyP0g9kmwMR8UWGfCcgBJm0=
Date:   Fri, 16 Jun 2023 15:06:41 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-start-update-damos-example-command.patch added to mm-unstable branch
Message-Id: <20230616220642.9A523C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: update DAMOS example command
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-start-update-damos-example-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-start-update-damos-example-command.patch

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
Subject: Docs/admin-guide/mm/damon/start: update DAMOS example command
Date: Fri, 16 Jun 2023 19:17:37 +0000

DAMON user-space tool, damo, has deprecated[1] its old DAMOS schemes
specification format.  However, an example of DAMON documentation is still
using it.  Update the example to use one of the alternative options.

[1] https://github.com/awslabs/damo/commit/e9950ae68f6c

Link: https://lkml.kernel.org/r/20230616191742.87531-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-update-damos-example-command
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -119,9 +119,9 @@ set size has chronologically changed.::
 Data Access Pattern Aware Memory Management
 ===========================================
 
-Below three commands make every memory region of size >=4K that doesn't
-accessed for >=60 seconds in your workload to be swapped out. ::
+Below command makes every memory region of size >=4K that has not accessed for
+>=60 seconds in your workload to be swapped out. ::
 
-    $ echo "#min-size max-size min-acc max-acc min-age max-age action" > test_scheme
-    $ echo "4K        max      0       0       60s     max     pageout" >> test_scheme
-    $ damo schemes -c test_scheme <pid of your workload>
+    $ sudo damo schemes --damos_access_rate 0 0 --damos_sz_region 4K max \
+                        --damos_age 60s max --damos_action pageout \
+                        <pid of your workload>
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

