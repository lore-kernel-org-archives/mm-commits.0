Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88757C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiEJEUk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbiEJETY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114F1285EFA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9187661743
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8827C385C2;
        Tue, 10 May 2022 04:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156067;
        bh=Db2rK7+JiVWlN52fFya55tpuwQn1bbY7yp5URqgVBQ0=;
        h=Date:To:From:Subject:From;
        b=CeAZPIMBUfhpjwPc5glIZMeejMZyU1V7us0XNOClTkZ1StfuXx+TuWwWBOSsjLPPC
         t8+CeChwoQtMZQJ+IxICAB2VFk8IPFDQDjfkDP2IbYqTCOk6O2z81vXpWmdmgnSB4I
         +pl4e3H7YHoyz6amfCh+fuDIUeMkNMeJi64o7vR8=
Date:   Mon, 09 May 2022 21:14:26 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xiam0nd.tong@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch removed from -mm tree
Message-Id: <20220510041426.E8827C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: damon: vaddr-test: tweak code to make the logic clearer
has been removed from the -mm tree.  Its filename was
     damon-vaddr-test-tweak-code-to-make-the-logic-clearer.patch

This patch was dropped because it was merged into mm-stable

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


