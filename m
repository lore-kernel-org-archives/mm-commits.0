Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73670C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344414AbiC1UUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbiC1UUV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CD926AC6
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 559B161213
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA27FC340ED;
        Mon, 28 Mar 2022 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498718;
        bh=E9tItWps3MK6ZLd3bB2PKXC2aECxGzEhihUcPd2fd2Y=;
        h=Date:To:From:Subject:From;
        b=Rl+4origDG/TxNbVt2cdR/y0moFPqUkzpDHZGGZ0PILDLw8S4TQRl+V7ue86E8np3
         lVRu+BX9n3T2YnjDxmzIfw/e2qlVaeyZcFb18xVnBCYbe8dBExci54wlVUhq+4X6Z1
         ysRDrTuyAA2BSEE7IfU/T5H6PqlDt84cTxTx1EkI=
Date:   Mon, 28 Mar 2022 13:18:38 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xiam0nd.tong@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch added to -mm tree
Message-Id: <20220328201838.AA27FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: damon: vaddr-test: tweak code to make the logic clearer
has been added to the -mm tree.  Its filename is
     damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: damon: vaddr-test: tweak code to make the logic clearer

Move these two lines into the damon_for_each_region loop, it is always for
testing the last region.  And also avoid to use a list iterator 'r'
outside the loop which is considered harmful[1].

[1]:  https://lkml.org/lkml/2022/2/17/1032

Link: https://lkml.kernel.org/r/20220328115252.31675-1-xiam0nd.tong@gmail.com
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/damon/vaddr-test.h~damon-vaddr-test-tweak-code-to-make-the-logic-clearer
+++ a/mm/damon/vaddr-test.h
@@ -281,14 +281,16 @@ static void damon_test_split_evenly_succ
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
 
 	damon_for_each_region(r, t) {
-		if (i == nr_pieces - 1)
+		if (i == nr_pieces - 1) {
+			KUNIT_EXPECT_EQ(test,
+				r->ar.start, start + i * expected_width);
+			KUNIT_EXPECT_EQ(test, r->ar.end, end);
 			break;
+		}
 		KUNIT_EXPECT_EQ(test,
 				r->ar.start, start + i++ * expected_width);
 		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
 	}
-	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
-	KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	damon_free_target(t);
 }
 
_

Patches currently in -mm which might be from xiam0nd.tong@gmail.com are

damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch

