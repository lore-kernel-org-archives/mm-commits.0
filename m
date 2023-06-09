Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E28AC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjFIXdR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbjFIXcG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DF83585
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDDFB65CFE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50408C433EF;
        Fri,  9 Jun 2023 23:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353382;
        bh=EEe8qW1cNHGxoCTwKoeSRAdfh7MG/xRohGfDsgJYIVE=;
        h=Date:To:From:Subject:From;
        b=x8zmsKvsCSJEJi1AG4Sxa98Ai3twPu92vmBWhucUZE4JfkZXjqBE/oDEB7XFWbXwQ
         VewqIZyQaDLiVH++lo6Y+o1hoxCkHkqQXTFztuC89w083LiP8WqBnHX8rzFSp98jsQ
         GV3ApRY4uFl+UkJDzc+qX2ZGz6KbV+WakSJCymrA=
Date:   Fri, 09 Jun 2023 16:29:41 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-a-section-for-overall-architecture.patch removed from -mm tree
Message-Id: <20230609232942.50408C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add a section for overall architecture
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-a-section-for-overall-architecture.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add a section for overall architecture
Date: Thu, 25 May 2023 21:43:07 +0000

The design doc is missing overall picture of DAMON.  Add a section for
overall architeucture and layers.

Link: https://lkml.kernel.org/r/20230525214314.5204-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-overall-architecture
+++ a/Documentation/mm/damon/design.rst
@@ -4,6 +4,21 @@
 Design
 ======
 
+
+Overall Architecture
+====================
+
+DAMON subsystem is configured with three layers including
+
+- Operations Set: Implements fundamental operations for DAMON that depends on
+  the given monitoring target address-space and available set of
+  software/hardware primitives,
+- Core: Implements core logics including monitoring overhead/accurach control
+  and access-aware system operations on top of the operations set layer, and
+- Modules: Implements kernel modules for various purposes that provides
+  interfaces for the user space, on top of the core layer.
+
+
 Configurable Layers
 ===================
 
_

Patches currently in -mm which might be from sj@kernel.org are


