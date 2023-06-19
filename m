Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7014BC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjFSX1b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjFSXZv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9941BD1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BA4F60FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CDC433C0;
        Mon, 19 Jun 2023 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217013;
        bh=zGMCkxinMov1lA5ITcUDtnupvGbTO/N0NxFr0sGQ1zE=;
        h=Date:To:From:Subject:From;
        b=e8+m3aiefFclfmnMrf7TPmfXTBt8D8D9ArrGkxqCsPQANKdkRgLuGGe4Sm9hsBrIr
         X0luX0Xyao0jQDJiG7cZfjdRYPxDifQjyShAtAu7F+NrkjzULXYKFUBzJkTOIvaoDi
         LiYeUJryb5qL0IrY+TwAR9tDAWoGFlC77ucB2Mwc=
Date:   Mon, 19 Jun 2023 16:23:33 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch removed from -mm tree
Message-Id: <20230619232333.B20CDC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: remove unnecessary sentences about supported address spaces
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-remove-unnecessary-sentences-about-supported-address-spaces.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


