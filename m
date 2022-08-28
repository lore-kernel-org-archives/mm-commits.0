Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF5AC54EE9
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiH1VFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiH1VDj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CB73120C;
        Sun, 28 Aug 2022 14:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CD9F60E96;
        Sun, 28 Aug 2022 21:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768BFC433C1;
        Sun, 28 Aug 2022 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720616;
        bh=r0PMKakWy5RBKt2gf4pcybO5cH02byXBhCaYbZj0d8U=;
        h=Date:To:From:Subject:From;
        b=J/8f3GVwfkWdWTTyoS6zNxkJIBWgIkGYuR/4/3R7EWD8x5dBbKrdYU2wJrO/58rE5
         LuB6k7CgiFfvGkvCkX60LojBoZnR1bvUi7sAR9IgHPqbIWmkNNIJtZkAM3QZObdobq
         S9oQPqh/oHDrVPuQkLReqXOI83Gp6hF8aYh8wwRg=
Date:   Sun, 28 Aug 2022 14:03:35 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        badari.pulavarty@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-avoid-duplicate-context-directory-creation.patch removed from -mm tree
Message-Id: <20220828210336.768BFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/dbgfs: avoid duplicate context directory creation
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-avoid-duplicate-context-directory-creation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Badari Pulavarty <badari.pulavarty@intel.com>
Subject: mm/damon/dbgfs: avoid duplicate context directory creation
Date: Sun, 21 Aug 2022 18:08:53 +0000

When user tries to create a DAMON context via the DAMON debugfs interface
with a name of an already existing context, the context directory creation
fails but a new context is created and added in the internal data
structure, due to absence of the directory creation success check.  As a
result, memory could leak and DAMON cannot be turned on.  An example test
case is as below:

    # cd /sys/kernel/debug/damon/
    # echo "off" >  monitor_on
    # echo paddr > target_ids
    # echo "abc" > mk_context
    # echo "abc" > mk_context
    # echo $$ > abc/target_ids
    # echo "on" > monitor_on  <<< fails

Return value of 'debugfs_create_dir()' is expected to be ignored in
general, but this is an exceptional case as DAMON feature is depending
on the debugfs functionality and it has the potential duplicate name
issue.  This commit therefore fixes the issue by checking the directory
creation failure and immediately return the error in the case.

Link: https://lkml.kernel.org/r/20220821180853.2400-1-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: Badari Pulavarty <badari.pulavarty@intel.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[ 5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-avoid-duplicate-context-directory-creation
+++ a/mm/damon/dbgfs.c
@@ -818,6 +818,9 @@ static int dbgfs_mk_context(char *name)
 		return -ENOENT;
 
 	new_dir = debugfs_create_dir(name, root);
+	/* Below check is required for a potential duplicated name case */
+	if (IS_ERR(new_dir))
+		return PTR_ERR(new_dir);
 	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
 
 	new_ctx = dbgfs_new_ctx();
_

Patches currently in -mm which might be from badari.pulavarty@intel.com are


