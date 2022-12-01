Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE0CC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiLAABU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiLAAAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C031C87C83
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6272DB81D86
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16042C43470;
        Thu,  1 Dec 2022 00:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852842;
        bh=UTqnsBfHfTGyqY+BKHD0ig6LZiQU5wYm0g3xEmq1dGs=;
        h=Date:To:From:Subject:From;
        b=yr9QBWqE0YC/YkjIFF8rQQ1Y/c+1+BSu4OgBSuFD9WtAaik4ktsdyVlsywUAKQi9w
         CASEUKn2+ERdrj2tgscNFgpTKcjdPHP6vE+lLHg/m+TrTtmsgiYL/WJHe1XFFny8vn
         2UDtMvy4D/Nu2/EC2PABpamlZgDn4emW62P4I26E=
Date:   Wed, 30 Nov 2022 16:00:41 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch removed from -mm tree
Message-Id: <20221201000042.16042C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/selftets/damon/sysfs: test tried_regions directory existence
has been removed from the -mm tree.  Its filename was
     tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: tools/selftets/damon/sysfs: test tried_regions directory existence
Date: Tue, 1 Nov 2022 22:03:26 +0000

Add a simple test case for ensuring tried_regions directory existence.

Link: https://lkml.kernel.org/r/20221101220328.95765-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~tools-selftets-damon-sysfs-test-tried_regions-directory-existence
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -80,6 +80,12 @@ test_range()
 	ensure_file "$range_dir/max" "exist" 600
 }
 
+test_tried_regions()
+{
+	tried_regions_dir=$1
+	ensure_dir "$tried_regions_dir" "exist"
+}
+
 test_stats()
 {
 	stats_dir=$1
@@ -138,6 +144,7 @@ test_scheme()
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
 	test_stats "$scheme_dir/stats"
+	test_tried_regions "$scheme_dir/tried_regions"
 }
 
 test_schemes()
_

Patches currently in -mm which might be from sj@kernel.org are


