Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A416C6379F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjBMX42 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjBMX4B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:56:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B074199D2
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 807E2CE0B18
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E40EC433EF;
        Mon, 13 Feb 2023 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332539;
        bh=g+1fVFJSMwpbXKxF3Q7Iy+GKpjjozARwRyv5KmzbaZ0=;
        h=Date:To:From:Subject:From;
        b=ZMZ0B/EuHgIoTxeID7RNpDyIPI2QCfzfSl6p0FKTE90NPerc9KOToLTjWqbd8PjQl
         i1FGCbMenHPa/Gl+E2OzyAUFDUJQR+bufbspVvtZg8v1QNrf0gihK4Ng6suYMxM6M2
         Je45i+BdxghZHUfvoXbWClhEObZpxjRdxxCFGhiA=
Date:   Mon, 13 Feb 2023 15:55:39 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice.patch removed from -mm tree
Message-Id: <20230213235539.9E40EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/Kconfig: add DAMON debugfs interface deprecation notice
has been removed from the -mm tree.  Its filename was
     mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/Kconfig: add DAMON debugfs interface deprecation notice
Date: Thu, 9 Feb 2023 19:20:08 +0000

DAMON debugfs interface has announced to be deprecated after >v5.15 LTS
kernel is released.  And, v6.1.y has announced to be an LTS[1].

Though the announcement was there for a while, some people might not
noticed that so far.  Also, some users could depend on it and have
problems at  movng to the alternative (DAMON sysfs interface).

For such cases, note DAMON debugfs interface as deprecated, and contacts
to ask helps on the Kconfig.

[1] https://git.kernel.org/pub/scm/docs/kernel/website.git/commit/?id=332e9121320bc7461b2d3a79665caf153e51732c

Link: https://lkml.kernel.org/r/20230209192009.7885-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/Kconfig~mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice
+++ a/mm/damon/Kconfig
@@ -60,7 +60,7 @@ config DAMON_SYSFS
 	  the interface for arbitrary data access monitoring.
 
 config DAMON_DBGFS
-	bool "DAMON debugfs interface"
+	bool "DAMON debugfs interface (DEPRECATED!)"
 	depends on DAMON_VADDR && DAMON_PADDR && DEBUG_FS
 	help
 	  This builds the debugfs interface for DAMON.  The user space admins
@@ -68,8 +68,9 @@ config DAMON_DBGFS
 
 	  If unsure, say N.
 
-	  This will be removed after >5.15.y LTS kernel is released, so users
-	  should move to the sysfs interface (DAMON_SYSFS).
+	  This is deprecated, so users should move to the sysfs interface
+	  (DAMON_SYSFS).  If you depend on this and cannot move, please report
+	  your usecase to damon@lists.linux.dev and linux-mm@kvack.org.
 
 config DAMON_DBGFS_KUNIT_TEST
 	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
_

Patches currently in -mm which might be from sj@kernel.org are


