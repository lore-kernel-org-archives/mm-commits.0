Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B533AC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjBCGfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjBCGfW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2385E80F93
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1380B82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713A8C433D2;
        Fri,  3 Feb 2023 06:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406117;
        bh=bdpbmDOUy9DmCnEMA70cwM/+cuRhRkWY68uDS1WWLcY=;
        h=Date:To:From:Subject:From;
        b=VN48wq8N6GYkgeJwFqffNR56LI4Gw4lw+1wPakyksSO5/ZTHxpy1fzQF5CO7ZjMdT
         E7znipOJn39mzxxkrP1U/X322qAoa6g/hPFfgdofyyb7JAewbLJ5iv+EsLwneyKG/O
         NVcel+Ywz1q6JwPXRSZ2Su4+2mxOirHksXP7d3ec=
Date:   Thu, 02 Feb 2023 22:35:16 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch removed from -mm tree
Message-Id: <20230203063517.713A8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: update kernel-doc comments for DAMOS filters supports of each DAMON operations set
has been removed from the -mm tree.  Its filename was
     mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: update kernel-doc comments for DAMOS filters supports of each DAMON operations set
Date: Tue, 10 Jan 2023 19:03:54 +0000

Supports of each DAMOS filter type are up to DAMON operations set
implementation in use, but not well mentioned on the kernel-doc comments. 
Add the comment.

Link: https://lkml.kernel.org/r/20230110190400.119388-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/damon.h~mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set
+++ a/include/linux/damon.h
@@ -227,6 +227,11 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
+ *
+ * The support of each filter type is up to running &struct damon_operations.
+ * &enum DAMON_OPS_PADDR is supporting all filter types, while
+ * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR are not supporting any
+ * filter types.
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

