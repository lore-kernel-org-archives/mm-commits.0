Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067FEC678D4
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjARX7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjARX65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:58:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4633B45F55
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5EF961AC3
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2DEC433D2;
        Wed, 18 Jan 2023 23:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086327;
        bh=F/zdwbTynvjFJskWz/URXJaQB3iOnTVUnbybsHzIfkk=;
        h=Date:To:From:Subject:From;
        b=ahZftgGHCYTDrEER9B7QTKNnHRpO9u42bnE7sjOEG6iITvT2b9K4miSFRp+Zm3+qc
         uXWTWV52j2SMJMnQtl4qJq7rK93QVqBdoLHq8UJU/XRyhW9KkS2Jup33h4CawKGRYi
         1DBsKqA5rwe8VyvzmEkAVsa8JCGWvbyNMgP0ePBc=
Date:   Wed, 18 Jan 2023 15:58:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        matenajakub@gmail.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-vm-add-mremap-expand-merge-offset-test-v5.patch removed from -mm tree
Message-Id: <20230118235847.3E2DEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest-vm-add-mremap-expand-merge-offset-test-v5
has been removed from the -mm tree.  Its filename was
     selftest-vm-add-mremap-expand-merge-offset-test-v5.patch

This patch was dropped because it was folded into selftest-vm-add-mremap-expand-merge-offset-test.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: selftest-vm-add-mremap-expand-merge-offset-test-v5
Date: Sat, 14 Jan 2023 13:16:46 +0000

increment num_expand_tests so test doesn't complain about unexpected tests
being run

Link: https://lkml.kernel.org/r/8ff3ba3cadc0b6c1b2688ae5c851bf73aa062d57.1673701836.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/mremap_test.c~selftest-vm-add-mremap-expand-merge-offset-test-v5
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -442,7 +442,7 @@ int main(int argc, char **argv)
 	int i, run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 	unsigned int pattern_seed;
-	int num_expand_tests = 1;
+	int num_expand_tests = 2;
 	struct test test_cases[MAX_TEST];
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

