Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2EAC54EBE
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbjAIXgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbjAIXgQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:36:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F4178BF
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3506CE1234
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4082C433EF;
        Mon,  9 Jan 2023 23:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307361;
        bh=LkHK2Bs4S+SXFhd0g9J4NseBQiXF4Hl1I6H0uYah8VA=;
        h=Date:To:From:Subject:From;
        b=BKueurlHKyMJCvxAKhqHQetI/VT0ikTR1rp99OxlRrj7yTJRC0SKYCIailI5eYYnB
         YGkQnkf11ti37Brwh4Tg2/DNFEcl9FED76EdM1v8yWVWWEAyIAgAxpxFkeOrXrYSSa
         3BH7U5vhySK6ZB6M4HtKZDVUMiKRGf0DkzuVRVsw=
Date:   Mon, 09 Jan 2023 15:36:00 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        mirsad.todorovac@alu.unizg.hr, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to mm-unstable branch
Message-Id: <20230109233601.C4082C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
Date: Mon, 9 Jan 2023 18:12:55 +0100

If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
fail.  Let's fix that like khugepaged.c does by conditionally defining
MADV_PAGEOUT.

Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of anonymous memory")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
+++ a/tools/testing/selftests/mm/cow.c
@@ -30,6 +30,9 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
 #ifndef MADV_COLLAPSE
 #define MADV_COLLAPSE 25
 #endif
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch
selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch

