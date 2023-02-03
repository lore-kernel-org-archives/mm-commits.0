Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330FBC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjBCGfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBCGfW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F63323D9C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFBBBB82983
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AE8C4339C;
        Fri,  3 Feb 2023 06:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406116;
        bh=KYGUQzJHx3mcJYK3TAFsVR1BYb/aUF7FJat8W+1n3uI=;
        h=Date:To:From:Subject:From;
        b=2i+8/RoIdnflzCJkzLD1swSM8Y/A9D5n9GV5uxrgpPpnZ3H2BheyBIPKqntUfIIg4
         0DZJmlizSG7kLi0Blfw/NswxjoWs6XrBI6T9WP+xxS8aYEo1g/aSSyVgYJ/kcaxRSn
         R1p35WWV+An0GeUAB/MsYvplF+OfoI8ga2DS0voI=
Date:   Thu, 02 Feb 2023 22:35:15 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch removed from -mm tree
Message-Id: <20230203063516.76AE8C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: update kernel-doc comments for DAMOS action supports of each DAMON operations set
has been removed from the -mm tree.  Its filename was
     mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: update kernel-doc comments for DAMOS action supports of each DAMON operations set
Date: Tue, 10 Jan 2023 19:03:53 +0000

Patch series "mm/damon: trivial fixups".

This patchset contains patches for trivial fixups of DAMON's
documentation, MAINTAINERS section, and selftests.


This patch (of 8):

Supports of each DAMOS action are up to DAMON operations set
implementation in use, but not well mentioned on the kernel-doc comments. 
Add the comment.

Link: https://lkml.kernel.org/r/20230110190400.119388-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230110190400.119388-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/damon.h~mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set
+++ a/include/linux/damon.h
@@ -91,6 +91,12 @@ struct damon_target {
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_STAT:		Do nothing but count the stat.
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
+ *
+ * The support of each action is up to running &struct damon_operations.
+ * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
+ * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
+ * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
+ * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

