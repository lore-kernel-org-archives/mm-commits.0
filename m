Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243A6C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbjHKW7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbjHKW6w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3789C30DE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2330671E7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170E8C433C8;
        Fri, 11 Aug 2023 22:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794730;
        bh=O6WdM+dOR3uAxxOB4mWrF6mPdXkqd/L8t+56ryLwJLY=;
        h=Date:To:From:Subject:From;
        b=u17qNZEim7ssmUHIxrzBV5Ao6cw63i4D/62PI37r9RTkub6ehYlLaxQS+7VsaxXHY
         jRxYYvr/KPDM0LarNuUzbivQGZ3QO7N7/hgm7RVh0MK4h5GRa21EJ3QWYPW9C2fAC7
         C+4q0TDi2KmJ/kpduPe+rx7L/vwJetjMUxspVaCg=
Date:   Fri, 11 Aug 2023 15:58:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch removed from -mm tree
Message-Id: <20230811225850.170E8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add gup test matrix in run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: add gup test matrix in run_vmtests.sh
Date: Wed, 28 Jun 2023 17:53:10 -0400

Add a matrix for testing gup based on the current gup_test.  Only run the
matrix when -a is specified because it's a bit slow.

It covers:

  - Different types of huge pages: thp, hugetlb, or no huge page
  - Permissions: Write / Read-only
  - Fast-gup, with/without
  - Types of the GUP: pin / gup / longterm pins
  - Shared / Private memories
  - GUP size: 1 / 512 / random page sizes

Link: https://lkml.kernel.org/r/20230628215310.73782-9-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   37 +++++++++++++++++---
 1 file changed, 32 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-gup-test-matrix-in-run_vmtestssh
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -90,6 +90,30 @@ test_selected() {
 	fi
 }
 
+run_gup_matrix() {
+    # -t: thp=on, -T: thp=off, -H: hugetlb=on
+    local hugetlb_mb=$(( needmem_KB / 1024 ))
+
+    for huge in -t -T "-H -m $hugetlb_mb"; do
+        # -u: gup-fast, -U: gup-basic, -a: pin-fast, -b: pin-basic, -L: pin-longterm
+        for test_cmd in -u -U -a -b -L; do
+            # -w: write=1, -W: write=0
+            for write in -w -W; do
+                # -S: shared
+                for share in -S " "; do
+                    # -n: How many pages to fetch together?  512 is special
+                    # because it's default thp size (or 2M on x86), 123 to
+                    # just test partial gup when hit a huge in whatever form
+                    for num in "-n 1" "-n 512" "-n 123"; do
+                        CATEGORY="gup_test" run_test ./gup_test \
+                                $huge $test_cmd $write $share $num
+                    done
+                done
+            done
+        done
+    done
+}
+
 # get huge pagesize and freepages from /proc/meminfo
 while read -r name size unit; do
 	if [ "$name" = "HugePages_Free:" ]; then
@@ -194,13 +218,16 @@ fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
 
-# get_user_pages_fast() benchmark
-CATEGORY="gup_test" run_test ./gup_test -u
-# pin_user_pages_fast() benchmark
-CATEGORY="gup_test" run_test ./gup_test -a
+if $RUN_ALL; then
+    run_gup_matrix
+else
+    # get_user_pages_fast() benchmark
+    CATEGORY="gup_test" run_test ./gup_test -u
+    # pin_user_pages_fast() benchmark
+    CATEGORY="gup_test" run_test ./gup_test -a
+fi
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
-
 CATEGORY="gup_test" run_test ./gup_longterm
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
_

Patches currently in -mm which might be from peterx@redhat.com are


