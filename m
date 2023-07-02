Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB1AEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjGBT7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjGBT6C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:58:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1282122
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2469A60C90
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF95C433B9;
        Sun,  2 Jul 2023 19:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327710;
        bh=H9tOZut4Wnleuc+Qvua/+Fd54SzeYJ/1To1PuYHe3KE=;
        h=Date:To:From:Subject:From;
        b=LKx46wtGYYX/0OaNVodt1DaGKpz/yf76tR+fksFboAF1eCn1SOZ/bz69RJCQ2Nbvd
         NySJAPz2COSLjKDylXTi1ZNrzy4vW6AuJYneWdhAbttKxbyBGiaphBq6uUeUMpbSHZ
         cofc04J+KWOJHob09HsjwlMuwRIGmyg1H+574g/0=
Date:   Sun, 02 Jul 2023 12:55:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20230702195510.7DF95C433B9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add gup test matrix in run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch

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

mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch
mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch
mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask.patch
mm-gup-cleanup-next_page-handling.patch
mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch
mm-gup-retire-follow_hugetlb_page.patch
selftests-mm-add-a-to-run_vmtestssh.patch
selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch

