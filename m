Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622D6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiEJEW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ED03DA55
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E1506176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F654C385C2;
        Tue, 10 May 2022 04:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156159;
        bh=HMluL/vqm7SPH2a0y2xmbMWwmAL1WPoYscq6sNRsTd4=;
        h=Date:To:From:Subject:From;
        b=uHyC8m5K9Xqd8iaR76hcYAg7sZGIZ6hwroQhHMgMu5hDoMYvDBJDVhIK+Ri4H2cTn
         Pn52tGgPl+cix0QQ9NH1mOdx0DsgQpRtLwzFlnMWWXeL1A5YeNcPsWOlfULAaJ28Nh
         bmuDx/0IWkgJkA3Cea7TGgJEfMkgmssWv+cL50no=
Date:   Mon, 09 May 2022 21:15:58 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch removed from -mm tree
Message-Id: <20220510041559.5F654C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter

This commit documents the new DAMON_RECLAIM parameter, 'commit_inputs' in
its usage document.

Link: https://lkml.kernel.org/r/20220429160606.127307-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -66,6 +66,17 @@ Setting it as ``N`` disables DAMON_RECLA
 no real monitoring and reclamation due to the watermarks-based activation
 condition.  Refer to below descriptions for the watermarks parameter for this.
 
+commit_inputs
+-------------
+
+Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
+
+Input parameters that updated while DAMON_RECLAIM is running are not applied
+by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+of parametrs except ``enabled`` again.  Once the re-reading is done, this
+parameter is set as ``N``.  If invalid parameters are found while the
+re-reading, DAMON_RECLAIM will be disabled.
+
 min_age
 -------
 
_

Patches currently in -mm which might be from sj@kernel.org are


