Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC3FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 01:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiA0Bdl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiA0Bdl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 20:33:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D201EC06161C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 17:33:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 703D261BDF
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 01:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CA1C340E3;
        Thu, 27 Jan 2022 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643247219;
        bh=fVI/jY2jpnO9gwfozu9B1fXcsAm+n0ewcouQQpJ+weM=;
        h=Date:From:To:Subject:From;
        b=kGlvFw4pz9JiYHuSg6ODBmxKSQQhWMaYs8/kbAmtkfhgQFZsKWTNvoyp4s/SI49c1
         bRLtLbKBwvBsrI0gtSiuKJT5gM8M/q1bP0O4leYBZpFeTF0GhrUwROtjPRxC0StCm3
         vaMedpjTwmVxY3tVnkdzRyzGmxTFpFvEY2eWtK5A=
Date:   Wed, 26 Jan 2022 17:33:39 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 =?US-ASCII?Q?docs-admin-guide-mm-damon-usage-update-for-changed-init?=
 =?US-ASCII?Q?ail=5Fregions-file-input.patch?= added to -mm tree
Message-ID: <20220127013339.J9Fqi2hz_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for changed initail_regions file input
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch

