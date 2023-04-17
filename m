Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38981C77B75
	for <mm-commits@archiver.kernel.org>; Mon, 17 Apr 2023 23:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjDQXwq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDQXwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 19:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB76944B1
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 16:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C3661245
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 23:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C4CC4339B;
        Mon, 17 Apr 2023 23:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681775558;
        bh=IhFt+zjtlCe0wxZnrRKDy1NfUsFILDfmfaUqyKOvvFM=;
        h=Date:To:From:Subject:From;
        b=cEzfJOC32vs0aZuFNsCaM2VeuJa0ueYHTPF4s2C5hR/vnNGTryourOBjLE2VlVsxW
         Srcu3O0iCO2o7F4lX/9oaX+2nsUURbwF3JH2ccDtVDklAc92fU90yAAmX40Hky660B
         SmXZHzo4J5lYHEFGYTVZFY53TdWuaDL4S2IYOLfc=
Date:   Mon, 17 Apr 2023 16:52:37 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch added to mm-unstable branch
Message-Id: <20230417235237.D9C4CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: rename COW_EXTRA_LIBS to IOURING_EXTRA_LIBS
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch

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
Subject: selftests/mm: rename COW_EXTRA_LIBS to IOURING_EXTRA_LIBS
Date: Mon, 17 Apr 2023 15:53:16 -0400

The macro and facility can be reused in other tests too.  Make it general.

Link: https://lkml.kernel.org/r/20230417195317.898696-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    8 ++++----
 tools/testing/selftests/mm/check_config.sh |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/check_config.sh~selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs
+++ a/tools/testing/selftests/mm/check_config.sh
@@ -21,11 +21,11 @@ $CC -c $tmpfile_c -o $tmpfile_o >/dev/nu
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
-    echo "COW_EXTRA_LIBS = -luring"              > $OUTPUT_MKFILE
+    echo "IOURING_EXTRA_LIBS = -luring"          > $OUTPUT_MKFILE
 else
     echo "// No liburing support found"          > $OUTPUT_H_FILE
     echo "# No liburing support found, so:"      > $OUTPUT_MKFILE
-    echo "COW_EXTRA_LIBS = "                    >> $OUTPUT_MKFILE
+    echo "IOURING_EXTRA_LIBS = "                >> $OUTPUT_MKFILE
 fi
 
 rm ${tmpname}.*
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs
+++ a/tools/testing/selftests/mm/Makefile
@@ -161,8 +161,8 @@ warn_32bit_failure:
 endif
 endif
 
-# cow_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
-$(OUTPUT)/cow: LDLIBS += $(COW_EXTRA_LIBS)
+# IOURING_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
+$(OUTPUT)/cow: LDLIBS += $(IOURING_EXTRA_LIBS)
 
 $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
@@ -175,11 +175,11 @@ local_config.mk local_config.h: check_co
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
-ifeq ($(COW_EXTRA_LIBS),)
+ifeq ($(IOURING_EXTRA_LIBS),)
 all: warn_missing_liburing
 
 warn_missing_liburing:
 	@echo ; \
-	echo "Warning: missing liburing support. Some COW tests will be skipped." ; \
+	echo "Warning: missing liburing support. Some tests will be skipped." ; \
 	echo
 endif
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-update-gitignore-with-two-missing-tests.patch
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

