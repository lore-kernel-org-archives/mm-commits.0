Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BDBC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbjHKXNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbjHKXNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0C0449A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01872679F8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AABC433C7;
        Fri, 11 Aug 2023 23:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794937;
        bh=dLoj7V+FYFeQqb1BpOf4mvQg0Z63IKUpw3AQ5QVjZHk=;
        h=Date:To:From:Subject:From;
        b=VnKyn1D7TYSg2LocBBVO2qFUoxhiHnR760VBc9DBfL2wsGqWHaiFE+Wi/zhEGsxK2
         SZJ2l2vEG137/E7aw9LTRsEoKcXr8CLRpLGJt4NB2xkWFxWya1ByxLYIQyIS1IVxGC
         gSAHbBeQs7o6NGex82BLPQ/bxm2V8MNYh+okFQxM=
Date:   Fri, 11 Aug 2023 16:02:16 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-thuge-gen-test-bugs.patch removed from -mm tree
Message-Id: <20230811230217.57AABC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix thuge-gen test bugs
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-thuge-gen-test-bugs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: fix thuge-gen test bugs
Date: Mon, 24 Jul 2023 09:25:18 +0100

thuge-gen was previously only munmapping part of the mmapped buffer, which
caused us to run out of 1G huge pages for a later part of the test.  Fix
this by munmapping the whole buffer.  Based on the code, it looks like a
typo rather than an intention to keep some of the buffer mapped.

thuge-gen was also calling mmap with SHM_HUGETLB flag (bit 11 set), which
is actually MAP_DENYWRITE in mmap context.  The man page says this flag is
ignored in modern kernels.  I'm pretty sure from the context that the
author intended to pass the MAP_HUGETLB flag so I've fixed that up too.

Link: https://lkml.kernel.org/r/20230724082522.1202616-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-fix-thuge-gen-test-bugs
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -139,7 +139,7 @@ void test_mmap(unsigned long size, unsig
 		before, after, before - after, size);
 	assert(size == getpagesize() || (before - after) == NUM_PAGES);
 	show(size);
-	err = munmap(map, size);
+	err = munmap(map, size * NUM_PAGES);
 	assert(!err);
 }
 
@@ -222,7 +222,7 @@ int main(void)
 		test_mmap(ps, MAP_HUGETLB | arg);
 	}
 	printf("Testing default huge mmap\n");
-	test_mmap(default_hps, SHM_HUGETLB);
+	test_mmap(default_hps, MAP_HUGETLB);
 
 	puts("Testing non-huge shmget");
 	test_shmget(getpagesize(), 0);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


