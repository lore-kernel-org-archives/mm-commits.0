Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE773C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 22:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjBJWal (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 17:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjBJWak (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 17:30:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD817FECE
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 14:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6584BB82607
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 22:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F5EC433EF;
        Fri, 10 Feb 2023 22:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676068234;
        bh=FufPmIw/KZTv+imuTCJ1GMF/crBbSZ7gltmDJFC9W/g=;
        h=Date:To:From:Subject:From;
        b=BLcVE/O0yoMs4eVE+LImDVvsV0Y1V6CsCnCcccCzxhh2boapkSEnu5cKuticnHi/C
         udDGwxTZeSi9fI6vCNG9nxXJcGTJlzYNG3xUdBXZkobjU9I6gwfv8av5+x9YrQHxfH
         D5oFevSfOwiUWoQ8+PZ0X7DS0Ga9RVlPrxzxzyng=
Date:   Fri, 10 Feb 2023 14:30:33 -0800
To:     mm-commits@vger.kernel.org, rdunlap@xenotime.net, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix.patch added to mm-unstable branch
Message-Id: <20230210223034.06F5EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix.patch

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
Subject: mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix
Date: Fri, 10 Feb 2023 04:48:38 +0000

split DAMON debugfs file open warning message, per Randy


Link: https://lkml.kernel.org/r/20230209192009.7885-4-sj@kernel.org
Link: https://lkml.kernel.org/r/20230210044838.63723-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix
+++ a/mm/damon/dbgfs.c
@@ -22,7 +22,10 @@ static DEFINE_MUTEX(damon_dbgfs_lock);
 
 static void damon_dbgfs_warn_deprecation(void)
 {
-	pr_warn_once("DAMON debugfs interface is deprecated, so users should move to the sysfs interface (DAMON_SYSFS).  If you depend on this and cannot move, please report your usecase to damon@lists.linux.dev and linux-mm@kvack.org.\n");
+	pr_warn_once("DAMON debugfs interface is deprecated, "
+		     "so users should move to DAMON_SYSFS. If you cannot, "
+		     "please report your usecase to damon@lists.linux.dev and "
+		     "linux-mm@kvack.org.\n");
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch
mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message-fix.patch

