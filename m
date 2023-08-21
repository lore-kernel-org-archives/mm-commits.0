Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF13FEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjHUUko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjHUUkV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A22E53
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 418EA64526
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923B6C433C9;
        Mon, 21 Aug 2023 20:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650392;
        bh=St9E5l5kTdBpmWMW4NZfX0/nSSXCNyvMw7NdM2fBuLA=;
        h=Date:To:From:Subject:From;
        b=wFDmr08wYKWfVczBQBKyU0Hf1/ZWdj8lPgjwKAQgQjNjxDIJZJWk69iQkVhQhJwb4
         2fIloCM6b68/ILN4TKJP9cf1YHbKD/jU8l68xDzB38AA9dl15DH1MNKKZSSmGNSfK0
         LzKpVgwHkGOgqj0c9SOhu2VEO3sn8fp9hiZP5kF4=
Date:   Mon, 21 Aug 2023 13:39:52 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs-test-damon_target-filter.patch removed from -mm tree
Message-Id: <20230821203952.923B6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/sysfs: test damon_target filter
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs-test-damon_target-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs: test damon_target filter
Date: Wed, 2 Aug 2023 21:43:09 +0000

Test existence of files and validity of input keyword for DAMON monitoring
target based DAMOS filter on DAMON sysfs interface.

Link: https://lkml.kernel.org/r/20230802214312.110532-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-test-damon_target-filter
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -104,11 +104,13 @@ test_filter()
 	ensure_write_succ "$filter_dir/type" "anon" "valid input"
 	ensure_write_succ "$filter_dir/type" "memcg" "valid input"
 	ensure_write_succ "$filter_dir/type" "addr" "valid input"
+	ensure_write_succ "$filter_dir/type" "target" "valid input"
 	ensure_write_fail "$filter_dir/type" "foo" "invalid input"
 	ensure_file "$filter_dir/matching" "exist" "600"
 	ensure_file "$filter_dir/memcg_path" "exist" "600"
 	ensure_file "$filter_dir/addr_start" "exist" "600"
 	ensure_file "$filter_dir/addr_end" "exist" "600"
+	ensure_file "$filter_dir/damon_target_idx" "exist" "600"
 }
 
 test_filters()
_

Patches currently in -mm which might be from sj@kernel.org are


