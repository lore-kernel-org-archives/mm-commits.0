Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFDDE94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjJFVr7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjJFVrn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608DE100
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8054BC433C8;
        Fri,  6 Oct 2023 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628862;
        bh=y/K3BI7sGKecW86T6GkjFvuzXnMiuKXPatA3SqwmGp0=;
        h=Date:To:From:Subject:From;
        b=ifvceL4WsHHQ9zdZuRqCxBdtnbUwK5GDwx8pQBeINLNP3i1C52Gpj5pXDro4YOLHI
         nQehjzUfo+WhRqaY6AAxgURELjQh6q8r2MLJ4NRyJKD/qIRRc9G4gHw2vduh1fqcPV
         jHQo6WGwDZJXOfe5SUY5zrvzb0LZ80myNmP1TJRo=
Date:   Fri, 06 Oct 2023 14:47:39 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-vm-check-errnos-in-mdwe_test.patch removed from -mm tree
Message-Id: <20231006214741.8054BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftest: vm: check errnos in mdwe_test
has been removed from the -mm tree.  Its filename was
     kselftest-vm-check-errnos-in-mdwe_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florent Revest <revest@chromium.org>
Subject: kselftest: vm: check errnos in mdwe_test
Date: Mon, 28 Aug 2023 17:08:55 +0200

Invalid prctls return a negative code and set errno.  It's good practice
to check that errno is set as expected.

Link: https://lkml.kernel.org/r/20230828150858.393570-4-revest@chromium.org
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/mdwe_test.c~kselftest-vm-check-errnos-in-mdwe_test
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -23,14 +23,22 @@
 TEST(prctl_flags)
 {
 	EXPECT_LT(prctl(PR_SET_MDWE, 7L, 0L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 7L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 0L, 7L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 0L, 0L, 7L), 0);
+	EXPECT_EQ(errno, EINVAL);
 
 	EXPECT_LT(prctl(PR_GET_MDWE, 7L, 0L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 7L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 0L, 7L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 0L, 0L, 7L), 0);
+	EXPECT_EQ(errno, EINVAL);
 }
 
 FIXTURE(mdwe)
_

Patches currently in -mm which might be from revest@chromium.org are


