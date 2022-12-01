Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80834C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiLAABY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiLAAAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F9659852
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA886B81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60419C433D6;
        Thu,  1 Dec 2022 00:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852844;
        bh=hMVpBHj+r1WsUkwTvAIbq9vSaWljHZrmEau+Gu1ag94=;
        h=Date:To:From:Subject:From;
        b=fARTP+qwzsRgOyAhUAbxIUzyfiVeygTFKXRopqfrhhKyT/dbRg+Lryc/hhmfiuxUb
         0tl7cXwwsLjCpUPhrsEDcy7RC8m/zAANxXBU1isShmXV2TZw5+UJb3v8EMfKmnMt66
         2uJXV0BQs+iM0a6WAOmQ+G9W/CsuRVXR2GroaANI=
Date:   Wed, 30 Nov 2022 16:00:43 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch removed from -mm tree
Message-Id: <20221201000044.60419C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/ABI/damon: document 'schemes/<s>/tried_regions' sysfs directory
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document 'schemes/<s>/tried_regions' sysfs directory
Date: Tue, 1 Nov 2022 22:03:28 +0000

Update DAMON ABI document for the 'tried_regions' directory of DAMON
sysfs interface.

Link: https://lkml.kernel.org/r/20221101220328.95765-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   32 ++++++++++++++
 1 file changed, 32 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -27,6 +27,10 @@ Description:	Writing 'on' or 'off' to th
 		makes the kdamond reads the user inputs in the sysfs files
 		except 'state' again.  Writing 'update_schemes_stats' to the
 		file updates contents of schemes stats files of the kdamond.
+		Writing 'update_schemes_tried_regions' to the file updates
+		contents of 'tried_regions' directory of every scheme directory
+		of this kdamond.  Writing 'clear_schemes_tried_regions' to the
+		file removes contents of the 'tried_regions' directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
@@ -283,3 +287,31 @@ Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the number of the exceed events of
 		the scheme's quotas.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/start
+Date:		Oct 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the start address of a memory region
+		that corresponding DAMON-based Operation Scheme's action has
+		tried to be applied.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/end
+Date:		Oct 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the end address of a memory region
+		that corresponding DAMON-based Operation Scheme's action has
+		tried to be applied.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/nr_accesses
+Date:		Oct 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the 'nr_accesses' of a memory region
+		that corresponding DAMON-based Operation Scheme's action has
+		tried to be applied.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/age
+Date:		Oct 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the 'age' of a memory region that
+		corresponding DAMON-based Operation Scheme's action has tried
+		to be applied.
_

Patches currently in -mm which might be from sj@kernel.org are


