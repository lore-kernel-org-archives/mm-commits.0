Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59B5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355192AbiDZVBd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355201AbiDZVBa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 17:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47214926B
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E1FF61602
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AB7C385A0;
        Tue, 26 Apr 2022 20:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651006699;
        bh=J3XJqZ2PcPrfnbj8HpQkTCUdw55Nx4/FnHImzQixhfw=;
        h=Date:To:From:Subject:From;
        b=Jt32FRjMV+KN1jEkM0+W3KZK5T9ZRRShUM8Nmn/xbw2c6wDmL+QlXNp4vy+c3LggF
         HmX56nIEs0xm5xC74HD5Akp/14bK3xA8H8WnFg9qaUOR/1gwkYmnP2gbOgaEHlftLk
         1IJkUk2dYDZnY6YuhP9krJJiI1x3L9T46uB6Q8Tw=
Date:   Tue, 26 Apr 2022 13:58:19 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch added to -mm tree
Message-Id: <20220426205819.A8AB7C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftets/damon/sysfs: test existence and permission of avail_operations
has been added to the -mm tree.  Its filename is
     selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch

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

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch

