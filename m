Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AFCC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjFSXU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFSXUZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1BCF9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFB560F51
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65391C433C0;
        Mon, 19 Jun 2023 23:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216823;
        bh=xqex7z1SxJ3RdguHvuZdA08azce19gF6Mm46SUasVaM=;
        h=Date:To:From:Subject:From;
        b=FLDqirasLKsUfW67A3zEKeCYlF/McCuGZ9eCBoAH5aVVAsx9K3+G6Ur0jJP7Cc/nj
         gDklNAzEbsyLL7FKDMCAFQiHBXciATxh2patceV51ikmaOpZi2Gf/qRz8DbOGdHIcg
         bkJwEDozrTVxEVoroI/AmVBP4o7YoTTIabIJtO8c=
Date:   Mon, 19 Jun 2023 16:20:22 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-uffd-stress-unused-function-warning.patch removed from -mm tree
Message-Id: <20230619232023.65391C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix uffd-stress unused function warning
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-uffd-stress-unused-function-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix uffd-stress unused function warning
Date: Tue, 6 Jun 2023 00:16:27 -0700

Patch series "A minor flurry of selftest/mm fixes", v3.

A series that fixes up build errors and warnings for at least the 64-bit
builds on x86 with clang.

The series also includes an optional "improvement" of moving some uffd
code into uffd-common.[ch], which is proving to be somewhat controversial,
and so if that doesn't get resolved, then patches 9 and 10 may just get
dropped.  They are not required in order to get a clean build, now that
"make headers" is happening.

[1]: https://lore.kernel.org/all/20230602013358.900637-1-jhubbard@nvidia.com/


This patch (of 11):

uffd_minor_feature() was unused.  Remove it in order to fix the associated
clang build warning.

Link: https://lkml.kernel.org/r/20230606071637.267103-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20230606071637.267103-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-fix-uffd-stress-unused-function-warning
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -88,16 +88,6 @@ static void uffd_stats_reset(struct uffd
 	}
 }
 
-static inline uint64_t uffd_minor_feature(void)
-{
-	if (test_type == TEST_HUGETLB && map_shared)
-		return UFFD_FEATURE_MINOR_HUGETLBFS;
-	else if (test_type == TEST_SHMEM)
-		return UFFD_FEATURE_MINOR_SHMEM;
-	else
-		return 0;
-}
-
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


