Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA1EC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357436AbiCYBgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355736AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C3417E2C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88EE9B82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EB5C340EC;
        Fri, 25 Mar 2022 01:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171989;
        bh=i2PW6vdn8MaPO2dP9y4lHqQBkH25kTTi/iWZbrnv0h0=;
        h=Date:To:From:Subject:From;
        b=1LqDG2oadyZPAP1Q9IFLu57aVSf1tAz3m37Mh4id1xkSkTKI4dABTZ9QMyfn39OKb
         KvDqdX9tOVaMArxSM0XyVFe1FI7TLBiSQPPnqr6TSlUYBpaDlO2L8e+LMMLmzMKe31
         ybBg+9rDaBsu4rTcyVqgiyiWdMEPaKsM3txx1CXY=
Date:   Thu, 24 Mar 2022 18:33:08 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch removed from -mm tree
Message-Id: <20220325013309.47EB5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for changed initail_regions file input
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for changed initail_regions file input

A previous commit made init_regions debugfs file to use target index
instead of target id for specifying the target of the init regions.  This
commit updates the usage document to reflect the change.

Link: https://lkml.kernel.org/r/20211230100723.2238-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   24 +++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -108,19 +108,23 @@ In such cases, users can explicitly set
 as they want, by writing proper values to the ``init_regions`` file.  Each line
 of the input should represent one region in below form.::
 
-    <target id> <start address> <end address>
+    <target idx> <start address> <end address>
 
-The ``target id`` should already in ``target_ids`` file, and the regions should
-be passed in address order.  For example, below commands will set a couple of
-address ranges, ``1-100`` and ``100-200`` as the initial monitoring target
-region of process 42, and another couple of address ranges, ``20-40`` and
-``50-100`` as that of process 4242.::
+The ``target idx`` should be the index of the target in ``target_ids`` file,
+starting from ``0``, and the regions should be passed in address order.  For
+example, below commands will set a couple of address ranges, ``1-100`` and
+``100-200`` as the initial monitoring target region of pid 42, which is the
+first one (index ``0``) in ``target_ids``, and another couple of address
+ranges, ``20-40`` and ``50-100`` as that of pid 4242, which is the second one
+(index ``1``) in ``target_ids``.::
 
     # cd <debugfs>/damon
-    # echo "42   1       100
-            42   100     200
-            4242 20      40
-            4242 50      100" > init_regions
+    # cat target_ids
+    42 4242
+    # echo "0   1       100
+            0   100     200
+            1   20      40
+            1   50      100" > init_regions
 
 Note that this sets the initial monitoring target regions only.  In case of
 virtual memory monitoring, DAMON will automatically updates the boundary of the
_

Patches currently in -mm which might be from sj@kernel.org are


