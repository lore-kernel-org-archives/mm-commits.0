Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65332C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbjHKW7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjHKW6u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7F330D2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA0567657
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3135C433C8;
        Fri, 11 Aug 2023 22:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794728;
        bh=Q/FaROCewy0ZPVlHacw22n7I5QU3N/DT2e04mmjtTbs=;
        h=Date:To:From:Subject:From;
        b=mZDYbgRdrD/VXXiS6wKl2jzUkeGhQ3SsCpQUZTuxpjCeiKcC7Gid4p5hmyZW+7upX
         GizDcs2YS5fXgRXiEu5IdOgKSbXjhL9lu+stvWI8C5JQpskl3z+aJfEAu+gzeL9/SX
         HWvfoP2kFvHUin0lcBgQVtH0Q+bog2EJFu+KcwAw=
Date:   Fri, 11 Aug 2023 15:58:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-a-to-run_vmtestssh.patch removed from -mm tree
Message-Id: <20230811225848.D3135C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add -a to run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-a-to-run_vmtestssh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


