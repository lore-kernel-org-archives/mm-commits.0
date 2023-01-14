Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9B7C46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 21:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjANVpj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 16:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjANVpj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 16:45:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57D99ED2
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 13:45:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46BC4B80939
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 21:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E33CC433EF;
        Sat, 14 Jan 2023 21:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673732734;
        bh=R9GiUBmh9aa+vDpdNSNM2WzpB1cKE7qNa4KHQw/c4hY=;
        h=Date:To:From:Subject:From;
        b=lOTIx28yem6ZvL1hADLkMmKX4Qzj5JT77sUkqeRGQ/C2xBceSXGzKOBKS53Z5tAvN
         vUpm6B6QdwmBdp9JyH5q4R9iuP4EoNR5l5VFSPzp2KMWXLcVseTdNArzL9Kre9rxsR
         XDpQvcAEmwnGEju0+GGXv/tzBrprn+0F6YMhyXdI=
Date:   Sat, 14 Jan 2023 13:45:33 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        matenajakub@gmail.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-add-mremap-expand-merge-offset-test-v5.patch added to mm-unstable branch
Message-Id: <20230114214534.8E33CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest-vm-add-mremap-expand-merge-offset-test-v5
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-vm-add-mremap-expand-merge-offset-test-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-vm-add-mremap-expand-merge-offset-test-v5.patch

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
selftest-vm-add-mremap-expand-merge-offset-test-v5.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

