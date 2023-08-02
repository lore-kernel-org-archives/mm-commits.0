Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03167C41513
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjHBVsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjHBVro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C753B2D6A
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A859E61B49
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00443C433C7;
        Wed,  2 Aug 2023 21:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691012812;
        bh=Lafo8TebK5fV3K+XzTcKpTHGehfnETwJOpU+VnLv4mQ=;
        h=Date:To:From:Subject:From;
        b=ZLCzDDIEEl62fpc7JNr5jaJJfazT6VUSQzUkFLxGem/MgNmDDHRX0rzDw/Qe2oYBM
         eZNX2MlodKfnjagttMg6auq9VPrUh4mtucSCZUaT6FA0ASQVQtYogyAIrvVxL4MbSi
         kZkiHHpW32g0oT4zBsB1pnJ821/uJ6whd1pBx0BA=
Date:   Wed, 02 Aug 2023 14:46:51 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-update-for-tried_regions-total_bytes.patch added to mm-unstable branch
Message-Id: <20230802214652.00443C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/ABI/damon: update for tried_regions/total_bytes
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-update-for-tried_regions-total_bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-tried_regions-total_bytes.patch

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
Subject: Docs/ABI/damon: update for tried_regions/total_bytes
Date: Wed, 2 Aug 2023 21:32:20 +0000

Update the DAMON ABI document for newly added
schemes/.../tried_regions/total_bytes file and the
update_schemes_tried_bytes command.

Link: https://lkml.kernel.org/r/20230802213222.109841-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-tried_regions-total_bytes
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -29,8 +29,10 @@ Description:	Writing 'on' or 'off' to th
 		file updates contents of schemes stats files of the kdamond.
 		Writing 'update_schemes_tried_regions' to the file updates
 		contents of 'tried_regions' directory of every scheme directory
-		of this kdamond.  Writing 'clear_schemes_tried_regions' to the
-		file removes contents of the 'tried_regions' directory.
+		of this kdamond.  Writing 'update_schemes_tried_bytes' to the
+		file updates only '.../tried_regions/total_bytes' files of this
+		kdamond.  Writing 'clear_schemes_tried_regions' to the file
+		removes contents of the 'tried_regions' directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
@@ -317,6 +319,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the number of the exceed events of
 		the scheme's quotas.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
+Date:		Jul 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total amount of memory that
+		corresponding DAMON-based Operation Scheme's action has tried
+		to be applied.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/start
 Date:		Oct 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch

