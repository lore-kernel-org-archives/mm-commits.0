Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0D2C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjDRXhi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDRXfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970A9CC0B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2775463A0B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C9C433D2;
        Tue, 18 Apr 2023 23:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860909;
        bh=nybcGLEDvCtqmF7vLbuVQoWg6tAZ096OKuqC5a6tNfM=;
        h=Date:To:From:Subject:From;
        b=Zj4imVqU0CNr0fEVQOsj1UbGaDuipb7WwK7BByNKGtEA90KKqKxK3gsL7hHtgZsqf
         ynLRI2spfDJOORwc/pSkpTfCRyKqhcAZvi+/3iqztMQiGyqit/T4xfRPr1sPxcglGx
         oPtxd3GZS2uFTqrEms0ZgR6ZjvmFWvVJduqIbWH0=
Date:   Tue, 18 Apr 2023 16:35:08 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-update-gitignore-with-two-missing-tests.patch removed from -mm tree
Message-Id: <20230418233509.7A9C9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: update .gitignore with two missing tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-update-gitignore-with-two-missing-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: update .gitignore with two missing tests
Date: Wed, 12 Apr 2023 12:41:14 -0400

Patch series "selftests/mm: Split / Refactor userfault test", v2.

This patchset splits userfaultfd.c into two tests:

  - uffd-stress: the "vanilla", old and powerful stress test
  - uffd-unit-tests: all the unit tests will be moved here

This is on my todo list for a long time but I never did it for real.  The
uffd test is growing into a small and cute monster.  I start to notice it's
going harder to maintain such a test and make it useful.

A few issues I found when looking at userfaultfd test:

  - We have a bunch of unit tests in userfaultfd.c, but they always need to
    be run only after a stress type.  No way to not do it.

  - We can only run an unit test for one memory type only, if we want to
    do a quick smoke test to check regressions, there's no good way.  The
    best to come currently is "bash ./run_vmtests.sh -t userfaultfd" thanks
    to the most recent changes to run_vmtests.sh on tagging.  Still, that
    needs to run the stress tests always and hard to see what's wrong.

  - It's hard to add a new unit test to userfaultfd.c, we don't really know
    what's happening, not until we mostly read the whole file.

  - We did a bunch of useless tests, e.g. we run twice the whole suite of
    stress test just to verify both syscall and /dev/userfaultfd.  They're
    all using userfaultfd_new() to create the handle, everything should
    really be the same underneath.  One simple unit test should cover that!

  - We have tens of global variables in one file but shared with all the
    tests.  Some of them are not suitable to be a global var from
    maintainance pov.  It enforces every unit test to consider how these
    vars affects the stress test and vice versa, but that's logically not
    necessary.

  - Userfaultfd test is not friendly to old kernels.  Mostly it only works
    on the latest kernel tree.  It's preferrable to be run on all kernels
    and properly report what's missing.

I'll stop here, I feel like I can still list some..

This patchset should resolve all issues above, and actually we can do even
more on top.  I stopped doing that until I found I already got 29 patches
and 2000+ LOC changes.  That's already a patchset terrible enough so we
should move in small steps.

After the whole set applied, "./run_vmtests.sh -t userfaultfd" looks like
this:

===8<===
vm.nr_hugepages = 1024
-------------------------
running ./uffd-unit-tests
-------------------------
Testing UFFDIO_API (with syscall)... done
Testing UFFDIO_API (with /dev/userfaultfd)... done
Testing register-ioctls on anon... done
Testing register-ioctls on shmem... done
Testing register-ioctls on shmem-private... done
Testing register-ioctls on hugetlb... done
Testing register-ioctls on hugetlb-private... done
Testing zeropage on anon... done
Testing zeropage on shmem... done
Testing zeropage on shmem-private... done
Testing zeropage on hugetlb... done
Testing zeropage on hugetlb-private... done
Testing pagemap on anon... done
Testing wp-unpopulated on anon... done
Testing minor on shmem... done
Testing minor on hugetlb... done
Testing minor-wp on shmem... done
Testing minor-wp on hugetlb... done
Testing minor-collapse on shmem... done
Testing sigbus on anon... done
Testing sigbus on shmem... done
Testing sigbus on shmem-private... done
Testing sigbus on hugetlb... done
Testing sigbus on hugetlb-private... done
Testing sigbus-wp on anon... done
Testing sigbus-wp on shmem... done
Testing sigbus-wp on shmem-private... done
Testing sigbus-wp on hugetlb... done
Testing sigbus-wp on hugetlb-private... done
Testing events on anon... done
Testing events on shmem... done
Testing events on shmem-private... done
Testing events on hugetlb... done
Testing events on hugetlb-private... done
Testing events-wp on anon... done
Testing events-wp on shmem... done
Testing events-wp on shmem-private... done
Testing events-wp on hugetlb... done
Testing events-wp on hugetlb-private... done
Userfaults unit tests: pass=39, skip=0, fail=0 (total=39)
[PASS]
--------------------------------
running ./uffd-stress anon 20 16
--------------------------------
nr_pages: 5120, nr_pages_per_cpu: 640
bounces: 15, mode: rnd racing ver poll, userfaults: 345 missing (26+48+61+102+30+12+59+7) 1596 wp (120+139+317+346+215+67+306+86)
[...]
[PASS]
------------------------------------
running ./uffd-stress hugetlb 128 32
------------------------------------
nr_pages: 64, nr_pages_per_cpu: 8
bounces: 31, mode: rnd racing ver poll, userfaults: 29 missing (6+6+6+5+4+2+0+0) 104 wp (20+19+22+18+7+12+5+1)
[...]
[PASS]
--------------------------------------------
running ./uffd-stress hugetlb-private 128 32
--------------------------------------------
nr_pages: 64, nr_pages_per_cpu: 8
bounces: 31, mode: rnd racing ver poll, userfaults: 33 missing (12+9+7+0+5+0+0+0) 111 wp (24+25+14+14+11+17+5+1)
[...]
[PASS]
---------------------------------
running ./uffd-stress shmem 20 16
---------------------------------
nr_pages: 5120, nr_pages_per_cpu: 640
bounces: 15, mode: rnd racing ver poll, userfaults: 247 missing (15+17+34+60+81+37+3+0) 2038 wp (180+114+276+400+381+318+165+204)
[...]
[PASS]
-----------------------------------------
running ./uffd-stress shmem-private 20 16
-----------------------------------------
nr_pages: 5120, nr_pages_per_cpu: 640
bounces: 15, mode: rnd racing ver poll, userfaults: 235 missing (52+29+55+56+13+9+16+5) 2849 wp (218+406+461+531+328+284+430+191)
[...]
[PASS]
SUMMARY: PASS=6 SKIP=0 FAIL=0
===8<===

The output may be different if we miss some features (e.g., hugetlb not
allocated, old kernel, less privilege of uffd handle), but they should show
up with good reasons.  E.g., I tried to run the unit test on my Fedora
kernel and it gives me:

===8<===
UFFDIO_API (with syscall)... failed [reason: UFFDIO_API should fail with wrong api but didn't]
UFFDIO_API (with /dev/userfaultfd)... skipped [reason: cannot open userfaultfd handle]
zeropage on anon... done
zeropage on shmem... done
zeropage on shmem-private... done
zeropage-hugetlb on hugetlb... done
zeropage-hugetlb on hugetlb-private... done
pagemap on anon... pagemap on anon... pagemap on anon... done
wp-unpopulated on anon... skipped [reason: feature missing]
minor on shmem... done
minor on hugetlb... done
minor-wp on shmem... skipped [reason: feature missing]
minor-wp on hugetlb... skipped [reason: feature missing]
minor-collapse on shmem... done
sigbus on anon... skipped [reason: possible lack of priviledge]
sigbus on shmem... skipped [reason: possible lack of priviledge]
sigbus on shmem-private... skipped [reason: possible lack of priviledge]
sigbus on hugetlb... skipped [reason: possible lack of priviledge]
sigbus on hugetlb-private... skipped [reason: possible lack of priviledge]
sigbus-wp on anon... skipped [reason: possible lack of priviledge]
sigbus-wp on shmem... skipped [reason: possible lack of priviledge]
sigbus-wp on shmem-private... skipped [reason: possible lack of priviledge]
sigbus-wp on hugetlb... skipped [reason: possible lack of priviledge]
sigbus-wp on hugetlb-private... skipped [reason: possible lack of priviledge]
events on anon... skipped [reason: possible lack of priviledge]
events on shmem... skipped [reason: possible lack of priviledge]
events on shmem-private... skipped [reason: possible lack of priviledge]
events on hugetlb... skipped [reason: possible lack of priviledge]
events on hugetlb-private... skipped [reason: possible lack of priviledge]
events-wp on anon... skipped [reason: possible lack of priviledge]
events-wp on shmem... skipped [reason: possible lack of priviledge]
events-wp on shmem-private... skipped [reason: possible lack of priviledge]
events-wp on hugetlb... skipped [reason: possible lack of priviledge]
events-wp on hugetlb-private... skipped [reason: possible lack of priviledge]
Userfaults unit tests: pass=9, skip=24, fail=1 (total=34)
===8<===

Patch layout:

- Revert "userfaultfd: don't fail on unrecognized features"

  Something I found when I got the UFFDIO_API test below.  Axel, I still
  propose to revert it as a whole, but feel free to continue the discussion
  from the original patch thread.

- selftests/mm: Update .gitignore with two missing tests
- selftests/mm: Dump a summary in run_vmtests.sh
- selftests/mm: Merge util.h into vm_util.h
- selftests/mm: Use TEST_GEN_PROGS where proper
- selftests/mm: Link vm_util.c always
- selftests/mm: Merge default_huge_page_size() into one
- selftests/mm: Use PM_* macros in vm_utils.h
- selftests/mm: Reuse pagemap_get_entry() in vm_util.h
- selftests/mm: Test UFFDIO_ZEROPAGE only when !hugetlb
- selftests/mm: Drop test_uffdio_zeropage_eexist

  Until here, all cleanups here and there.  I wanted to keep going, but I
  found that maybe it'll take a few more days to split the test.  Hence I
  did a split starting from the next one, so we have a working thing first.

- selftests/mm: Create uffd-common.[ch]
- selftests/mm: Split uffd tests into uffd-stress and uffd-unit-tests

  This did the major brute force split of common codes into
  uffd-common.[ch].  That'll be the so far common base for stress and unit
  tests.  Then a new unit test is created.

- selftests/mm: uffd_[un]register()
- selftests/mm: uffd_open_{dev|sys}()
- selftests/mm: UFFDIO_API test

  This patch hides here to start writting the 1st unit test with
  UFFDIO_API, also detection of userfaultfd privileges.

- selftests/mm: Drop global mem_fd in uffd tests
- selftests/mm: Drop global hpage_size in uffd tests
- selftests/mm: Rename uffd_stats to uffd_args
- selftests/mm: Let uffd_handle_page_fault() takes wp parameter
- selftests/mm: Allow allocate_area() to fail properly

  Some further cleanup that I noticed otherwise hard to move the tests.

- selftests/mm: Add framework for uffd-unit-test

  The major patch provides the framework for most of the rest unit tests.

- selftests/mm: Move uffd pagemap test to unit test
- selftests/mm: Move uffd minor test to unit test
- selftests/mm: Move uffd sig/events tests into uffd unit tests
- selftests/mm: Move zeropage test into uffd unit tests

  Move unit tests and suite them into the new file.

- selftests/mm: Workaround no way to detect uffd-minor + wp
- selftests/mm: Allow uffd test to skip properly with no privilege
- selftests/mm: Drop sys/dev test in uffd-stress test
- selftests/mm: Add shmem-private test to uffd-stress

  A bunch of changes to do better on error reportings, and add
  shmem-private to the stress test which was long missing.

- selftests/mm: Add uffdio register ioctls test

  One more patch to test uffdio_register.ioctls.


This patch (of 30):

Update .gitignore with two missing tests.

Link: https://lkml.kernel.org/r/20230412163922.327282-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20230412164114.327709-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-update-gitignore-with-two-missing-tests
+++ a/tools/testing/selftests/mm/.gitignore
@@ -36,3 +36,5 @@ split_huge_page_test
 ksm_tests
 local_config.h
 local_config.mk
+ksm_functional_tests
+mdwe_test
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

