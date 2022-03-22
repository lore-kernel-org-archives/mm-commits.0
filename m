Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAC2C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbiCVVu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiCVVuT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5D02C64C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54274B81D59
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1030EC340EE;
        Tue, 22 Mar 2022 21:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985715;
        bh=ayXBwIwhumzWY9c4wWb4oEyiB3je2vpZD8X2Qsn4eDI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Ykfsv2pm5JNWiwv/Cn4GWP6rJ9QDfTiQiDSceCXBjbWnBaHlWVO3swiGy/hy6y27U
         RzcRTFcpnFskXNkMg4F52q/mFjy7p2uSQET0WL91oNG1frCekVEhirDffHFmu50w6c
         QZM6LhDwstf1s1BfqmnQ2AS05vovZyVH+j67ORdE=
Date:   Tue, 22 Mar 2022 14:48:34 -0700
To:     sj@kernel.org, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 198/227] Docs/admin-guide/mm/damon/usage: update for changed initail_regions file input
Message-Id: <20220322214835.1030EC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
