Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25593C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiEJEWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983F42AED8D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 787036176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF484C385C9;
        Tue, 10 May 2022 04:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156131;
        bh=2fK18tJ/boVe+SQmtt75DEX/9mYTE7MhZbs7RjJhLcs=;
        h=Date:To:From:Subject:From;
        b=LimaKug56natx2x0MWe3t2qU5fhOqLDiyysbbPsjXGqSyW3sQ6L/zOdTo72GPhW4a
         ZvLqJ6YcViOON50tTU4Kkp+LQcNaCmVrz2FLTUX8W8EOohoesN5JOeOsIyWQrXhdSi
         2l7tGg50aOhKTpTwc04zDd3UI/L4EVQuJnkarUiY=
Date:   Mon, 09 May 2022 21:15:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch removed from -mm tree
Message-Id: <20220510041531.CF484C385C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftets/damon/sysfs: test existence and permission of avail_operations
has been removed from the -mm tree.  Its filename was
     selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftets/damon/sysfs: test existence and permission of avail_operations

This commit adds a selftest test case for ensuring the existence and the
permission (read-only) of the 'avail_oprations' DAMON sysfs file.

Link: https://lkml.kernel.org/r/20220426203843.45238-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftets-damon-sysfs-test-existence-and-permission-of-avail_operations
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -231,6 +231,7 @@ test_context()
 {
 	context_dir=$1
 	ensure_dir "$context_dir" "exist"
+	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
_

Patches currently in -mm which might be from sj@kernel.org are


