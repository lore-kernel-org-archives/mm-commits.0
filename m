Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD02C61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 22:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBIWOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBIWOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 17:14:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90A8269B
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 14:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 837BE61BD4
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 22:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3ADC433EF;
        Thu,  9 Feb 2023 22:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675980891;
        bh=DM2wXr03Ni6AQHX/0U9kort9mPFh2TmceqosqC2n4bE=;
        h=Date:To:From:Subject:From;
        b=JLCqJtdQlf2d1Mxvo8QoQwKTCQP8bA+l6oleql2vCgqjEVp4X7a+truqSXFCvmrw8
         Xek7aCiFHS4sa9idkB9m5v2dan7/MS2iYqUrBjNOVVix3ez4FIbfy5TKND5axMehsZ
         ysal/5RKAYuQBEmBgdbLaDPyaxgcXoDwV1hVSvgw=
Date:   Thu, 09 Feb 2023 14:14:51 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch added to mm-unstable branch
Message-Id: <20230209221451.CF3ADC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: add DAMON debugfs interface deprecation notice
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch

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
Subject: Docs/admin-guide/mm/damon/usage: add DAMON debugfs interface deprecation notice
Date: Thu, 9 Feb 2023 19:20:07 +0000

Patch series "mm/damon: deprecate DAMON debugfs interface".

DAMON debugfs interface has announced to be deprecated after >v5.15 LTS
kernel is released.  And v6.1.y has been announced to be an LTS[1].

Though the announcement was there for a while, some people might not have
noticed that so far.  Also, some users could depend on it and have
problems at movng to the alternative (DAMON sysfs interface).

For such cases, keep the code and documents with warning messages and
contacts to ask helps for the deprecation.

[1] https://git.kernel.org/pub/scm/docs/kernel/website.git/commit/?id=332e9121320bc7461b2d3a79665caf153e51732c


This patch (of 3):

DAMON debugfs interface has announced to be deprecated after >v5.15 LTS
kernel is released.  And, v6.1.y has announced to be an LTS[1].

Though the announcement was there for a while, some people might not
noticed that so far.  Also, some users could depend on it and have
problems at  movng to the alternative (DAMON sysfs interface).

For such cases, note DAMON debugfs interface as deprecated, and contacts
to ask helps on the document.

[1] https://git.kernel.org/pub/scm/docs/kernel/website.git/commit/?id=332e9121320bc7461b2d3a79665caf153e51732c

Link: https://lkml.kernel.org/r/20230209192009.7885-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230209192009.7885-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   20 +++++++++++------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -25,10 +25,12 @@ DAMON provides below interfaces for diff
   interface provides only simple :ref:`statistics <damos_stats>` for the
   monitoring results.  For detailed monitoring results, DAMON provides a
   :ref:`tracepoint <tracepoint>`.
-- *debugfs interface.*
+- *debugfs interface. (DEPRECATED!)*
   :ref:`This <debugfs_interface>` is almost identical to :ref:`sysfs interface
-  <sysfs_interface>`.  This will be removed after next LTS kernel is released,
-  so users should move to the :ref:`sysfs interface <sysfs_interface>`.
+  <sysfs_interface>`.  This is deprecated, so users should move to the
+  :ref:`sysfs interface <sysfs_interface>`.  If you depend on this and cannot
+  move, please report your usecase to damon@lists.linux.dev and
+  linux-mm@kvack.org.
 - *Kernel Space Programming Interface.*
   :doc:`This </mm/damon/api>` is for kernel space programmers.  Using this,
   users can utilize every feature of DAMON most flexibly and efficiently by
@@ -487,13 +489,17 @@ the files as above.  Above is only for a
 
 .. _debugfs_interface:
 
-debugfs Interface
-=================
+debugfs Interface (DEPRECATED!)
+===============================
 
 .. note::
 
-  DAMON debugfs interface will be removed after next LTS kernel is released, so
-  users should move to the :ref:`sysfs interface <sysfs_interface>`.
+  THIS IS DEPRECATED!
+
+  DAMON debugfs interface is deprecated, so users should move to the
+  :ref:`sysfs interface <sysfs_interface>`.  If you depend on this and cannot
+  move, please report your usecase to damon@lists.linux.dev and
+  linux-mm@kvack.org.
 
 DAMON exports eight files, ``attrs``, ``target_ids``, ``init_regions``,
 ``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` and
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

