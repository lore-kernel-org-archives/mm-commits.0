Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85987C001B0
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjGBT67 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbjGBT6B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:58:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4121FFF
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4BE60C87
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAC4C433C8;
        Sun,  2 Jul 2023 19:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327707;
        bh=mvukeAozsZW8LzzT/IADyhvZbN4TzvJuLQQ9awW/mXo=;
        h=Date:To:From:Subject:From;
        b=P4IG0XsABFwi4fxYho8Zh+CaCm9NMV/e0ze0gHG7HwIYnnhcImKDw+n77v+/SiF3Q
         9qBHMQJpcp7C7G31vL2oilIHPF7OBtPY/TqW2YGfd/TEBGhOuoi0Ohy2JNfriFwZL+
         cBxXYsooquTfbVZ00aXuvT6lHpwQtYwbTvi4Chb4=
Date:   Sun, 02 Jul 2023 12:55:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-to-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20230702195507.7FAC4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add -a to run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-a-to-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-to-run_vmtestssh.patch

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
Subject: selftests/mm: add -a to run_vmtests.sh
Date: Wed, 28 Jun 2023 17:53:09 -0400

Allows to specify optional tests in run_vmtests.sh, where we can run time
consuming test matrix only when user specified "-a".

Link: https://lkml.kernel.org/r/20230628215310.73782-8-peterx@redhat.com
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

 tools/testing/selftests/mm/run_vmtests.sh |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-a-to-run_vmtestssh
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -12,11 +12,14 @@ exitcode=0
 
 usage() {
 	cat <<EOF
-usage: ${BASH_SOURCE[0]:-$0} [ -h | -t "<categories>"]
+usage: ${BASH_SOURCE[0]:-$0} [ options ]
+
+  -a: run all tests, including extra ones
   -t: specify specific categories to tests to run
   -h: display this message
 
-The default behavior is to run all tests.
+The default behavior is to run required tests only.  If -a is specified,
+will run all tests.
 
 Alternatively, specific groups tests can be run by passing a string
 to the -t argument containing one or more of the following categories
@@ -60,9 +63,11 @@ EOF
 	exit 0
 }
 
+RUN_ALL=false
 
-while getopts "ht:" OPT; do
+while getopts "aht:" OPT; do
 	case ${OPT} in
+		"a") RUN_ALL=true ;;
 		"h") usage ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 	esac
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

