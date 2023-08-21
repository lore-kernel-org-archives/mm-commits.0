Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1EBEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjHUUkS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjHUUkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFEDCD0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B2F64B17
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3975C433C7;
        Mon, 21 Aug 2023 20:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650380;
        bh=7zDuxcukAY97kBtSH8WuHOSNYJrguMaNPnU1ITmfC3s=;
        h=Date:To:From:Subject:From;
        b=0NHHYyyDeOED2EXPXsat7DZoLCFH42uebRj4Nb4bAYMTXaefOGEblxvURSTnpY1z6
         SLMLnCi1YudRIntAZ4GXE93+ul8pvaCRHBPaYqrFeNGT5RBK9K9+v0VXtVnZye/AUl
         Rq84H6n5WdHdpDUYfQ08YykbBKfao3kbKt/5FX9g=
Date:   Mon, 21 Aug 2023 13:39:39 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch removed from -mm tree
Message-Id: <20230821203939.E3975C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/sysfs: test tried_regions/total_bytes file
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


