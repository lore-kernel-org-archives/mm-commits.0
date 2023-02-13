Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FEBC636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjBMX4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjBMXzo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C721815A
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5205A60DB9
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C9C433EF;
        Mon, 13 Feb 2023 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332538;
        bh=6NilP0EzKdEHut4MEePAaUm5+/tCK6WjGwooL1HYjO4=;
        h=Date:To:From:Subject:From;
        b=fyYRCDqbozHeLfGKiPghltwu4LLJi/8+TdKZ70kmw4pnRmaTMl88FJnlqkEo3pOLN
         l9ZrymylP5OKEUaeSUxyRUSssOgwCA3suYGRlmRppvhXCG5p63CkzQmllcrEAWA07s
         ioSGKL/YUf4SFN6DJIvNudzQ1qiVNwHTR4GblPCw=
Date:   Mon, 13 Feb 2023 15:55:38 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch removed from -mm tree
Message-Id: <20230213235538.A55C9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: add DAMON debugfs interface deprecation notice
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


