Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47003E7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbjJDUSa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243994AbjJDUSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E251C0
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8375C433CA;
        Wed,  4 Oct 2023 20:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450698;
        bh=32VzL6IXvDJrEmOz1Wmp3JWe7xL90iCHGFjsXPYuHlI=;
        h=Date:To:From:Subject:From;
        b=r6ZTuNsRt9Sw1WGUDYyK1MLXiNWufZz23MuPdk3xBObNsNhB0vItZ3EDuKJpJcfsh
         a6aGgsGbSCM7Xwlp825J3be9U0cj64q3UoSlwA+W4BQzn9kRg9rfrFqytgI93BcaNY
         cUuy0ndD9znCDsCxu4TvKoLMQzisO/dxHbfsmijQ=
Date:   Wed, 04 Oct 2023 13:18:16 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch removed from -mm tree
Message-Id: <20231004201817.B8375C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: move debugfs intro to the bottom of the section
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


