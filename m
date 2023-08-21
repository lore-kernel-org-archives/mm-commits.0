Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED545EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjHUUkj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjHUUkP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52C5CFE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF8ED64B0F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1FBC433C7;
        Mon, 21 Aug 2023 20:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650386;
        bh=mAYgK9mQGvyx7M865Dp3Mzb6jeN2ia2GmgXjMGRmUdo=;
        h=Date:To:From:Subject:From;
        b=Qeb/5BwTm482jNcc3WKcu/KG+il7tWX21kEVoPfiwy4WIAkCPyJmsnirhLX2UBgyB
         O6k8ZQ0pYRh2ml3M0VJBWarR0ZtpzINNv4kPc8bFBj3I3MUhfdH/aYzI1/7OYbMBDY
         HQZWddtYWoio/Vs0XK73ZbnSNaywleJ3C+7Jk8+E=
Date:   Mon, 21 Aug 2023 13:39:45 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs-test-address-range-damos-filter.patch removed from -mm tree
Message-Id: <20230821203946.2F1FBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/sysfs: test address range damos filter
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs-test-address-range-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs: test address range damos filter
Date: Wed, 2 Aug 2023 21:43:03 +0000

Add a selftest for checking existence of addr_{start,end} files under
DAMOS filter directory, and 'addr' damos filter type input of DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20230802214312.110532-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-test-address-range-damos-filter
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -103,9 +103,12 @@ test_filter()
 	ensure_file "$filter_dir/type" "exist" "600"
 	ensure_write_succ "$filter_dir/type" "anon" "valid input"
 	ensure_write_succ "$filter_dir/type" "memcg" "valid input"
+	ensure_write_succ "$filter_dir/type" "addr" "valid input"
 	ensure_write_fail "$filter_dir/type" "foo" "invalid input"
 	ensure_file "$filter_dir/matching" "exist" "600"
 	ensure_file "$filter_dir/memcg_path" "exist" "600"
+	ensure_file "$filter_dir/addr_start" "exist" "600"
+	ensure_file "$filter_dir/addr_end" "exist" "600"
 }
 
 test_filters()
_

Patches currently in -mm which might be from sj@kernel.org are


