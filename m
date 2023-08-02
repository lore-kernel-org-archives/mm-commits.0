Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA42C04A94
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjHBVr4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjHBVr3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C334481
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0127B61B48
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56577C433C8;
        Wed,  2 Aug 2023 21:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691012809;
        bh=4RSA61GC/kzFMNIgiddlXQtwVM8l8LqUr6VvTxqd37g=;
        h=Date:To:From:Subject:From;
        b=uv6ss4TiW2rvpKYiTnPHy/B3kJ+arhY025Qtvj/5QGfXh25G7Wtl1MWHGVyYhUdfK
         nxW2Ed83An/Wr3A7IOZrntd4jS49LJge8dOQ/i4QAOP2d0q1jOHEqDgWPVZ+CgWU4T
         AI/LSWx8ctUw15J0QjzSelRaVgMIa8+6/fln5bY8=
Date:   Wed, 02 Aug 2023 14:46:48 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch added to mm-unstable branch
Message-Id: <20230802214649.56577C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon/sysfs: test tried_regions/total_bytes file
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs: test tried_regions/total_bytes file
Date: Wed, 2 Aug 2023 21:32:19 +0000

Update sysfs.sh DAMON selftest for checking existence of 'total_bytes'
file under the 'tried_regions' directory of DAMON sysfs interface.

Link: https://lkml.kernel.org/r/20230802213222.109841-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-test-tried_regions-total_bytes-file
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -84,6 +84,7 @@ test_tried_regions()
 {
 	tried_regions_dir=$1
 	ensure_dir "$tried_regions_dir" "exist"
+	ensure_file "$tried_regions_dir/total_bytes" "exist" "400"
 }
 
 test_stats()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch

