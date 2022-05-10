Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8777C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiEJEXB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D193D4B5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5785B81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81426C385C2;
        Tue, 10 May 2022 04:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156157;
        bh=ua8td5+AQcXm3EhFLO7JaC1uFetbLzBGMfTxED8q8Ao=;
        h=Date:To:From:Subject:From;
        b=lNPO/2bmJKnsyx952G4t1RdSLZQcJ1/nXdvwG3wMhb1mXl4rVSRvNtgHLBdXFP0EB
         xhbIeGk3Dj4TBVHSiVTsmkDF9w09NflEVPEWMPblw/cZEESEpta34xrplyDLkXRC0W
         V4yLUnlsyvHX8sRauzbjyK/g8zJBcZbadL6ES150=
Date:   Mon, 09 May 2022 21:15:56 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch removed from -mm tree
Message-Id: <20220510041557.81426C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/{ABI,admin-guide}/damon: Update for 'state' sysfs file input keyword, 'commit'
has been removed from the -mm tree.  Its filename was
     docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/{ABI,admin-guide}/damon: Update for 'state' sysfs file input keyword, 'commit'

This commit documents the newly added 'state' sysfs file input keyword,
'commit', which allows online tuning of DAMON contexts.

Link: https://lkml.kernel.org/r/20220429160606.127307-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 ++++---
 Documentation/admin-guide/mm/damon/usage.rst    |    9 +++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -23,9 +23,10 @@ Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		stops, respectively.  Reading the file returns the keywords
-		based on the current status.  Writing 'update_schemes_stats' to
-		the file updates contents of schemes stats files of the
-		kdamond.
+		based on the current status.  Writing 'commit' to this file
+		makes the kdamond reads the user inputs in the sysfs files
+		except 'state' again.  Writing 'update_schemes_stats' to the
+		file updates contents of schemes stats files of the kdamond.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -121,10 +121,11 @@ In each kdamond directory, two files (``
 
 Reading ``state`` returns ``on`` if the kdamond is currently running, or
 ``off`` if it is not running.  Writing ``on`` or ``off`` makes the kdamond be
-in the state.  Writing ``update_schemes_stats`` to ``state`` file updates the
-contents of stats files for each DAMON-based operation scheme of the kdamond.
-For details of the stats, please refer to :ref:`stats section
-<sysfs_schemes_stats>`.
+in the state.  Writing ``commit`` to the ``state`` file makes kdamond reads the
+user inputs in the sysfs files except ``state`` file again.  Writing
+``update_schemes_stats`` to ``state`` file updates the contents of stats files
+for each DAMON-based operation scheme of the kdamond.  For details of the
+stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
_

Patches currently in -mm which might be from sj@kernel.org are


