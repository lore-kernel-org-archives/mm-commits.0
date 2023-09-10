Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54701EE49A4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjIJUsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUsA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB83E188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:47:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B5C433C8;
        Sun, 10 Sep 2023 20:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378876;
        bh=vm2eLvm6mZkdLZF3T95Kv5RMd9V+W2qG4cXvqf2bTM4=;
        h=Date:To:From:Subject:From;
        b=T8jOQgzBLJnoY2Sj8E74TUPQb7tnARCWcmT9BTGkiRbKoBcuEo/66ns33XGCoh+BC
         nX7U2E/PIGMW5D87Ds/2TH4YufGfCS9UcqicQr518h6yQuqHIzU9RTRyOYSgkTF5/W
         j4Tb+Jy8GL2XUixh4XjsgfLFe9oKqxO9gX2mKcwk=
Date:   Sun, 10 Sep 2023 13:47:55 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch added to mm-unstable branch
Message-Id: <20230910204756.421B5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: move debugfs intro to the bottom of the section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch

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
Subject: Docs/admin-guide/mm/damon/usage: move debugfs intro to the bottom of the section
Date: Thu, 7 Sep 2023 02:29:21 +0000

On the DAMON usage introduction section, the introduction of DAMON
debugfs interface, which is deprecated, is above kernel API, which is
actively supported.  Move the DAMON debugfs intro to bottom, so that
readers have less chances to read it.

Link: https://lkml.kernel.org/r/20230907022929.91361-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -20,18 +20,18 @@ DAMON provides below interfaces for diff
   you can write and use your personalized DAMON sysfs wrapper programs that
   reads/writes the sysfs files instead of you.  The `DAMON user space tool
   <https://github.com/awslabs/damo>`_ is one example of such programs.
-- *debugfs interface. (DEPRECATED!)*
-  :ref:`This <debugfs_interface>` is almost identical to :ref:`sysfs interface
-  <sysfs_interface>`.  This is deprecated, so users should move to the
-  :ref:`sysfs interface <sysfs_interface>`.  If you depend on this and cannot
-  move, please report your usecase to damon@lists.linux.dev and
-  linux-mm@kvack.org.
 - *Kernel Space Programming Interface.*
   :doc:`This </mm/damon/api>` is for kernel space programmers.  Using this,
   users can utilize every feature of DAMON most flexibly and efficiently by
   writing kernel space DAMON application programs for you.  You can even extend
   DAMON for various address spaces.  For detail, please refer to the interface
   :doc:`document </mm/damon/api>`.
+- *debugfs interface. (DEPRECATED!)*
+  :ref:`This <debugfs_interface>` is almost identical to :ref:`sysfs interface
+  <sysfs_interface>`.  This is deprecated, so users should move to the
+  :ref:`sysfs interface <sysfs_interface>`.  If you depend on this and cannot
+  move, please report your usecase to damon@lists.linux.dev and
+  linux-mm@kvack.org.
 
 .. _sysfs_interface:
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

