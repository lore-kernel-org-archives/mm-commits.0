Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4DFC77B78
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjDUVwm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjDUVwi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF30F10E6
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D8765327
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C91C433D2;
        Fri, 21 Apr 2023 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113957;
        bh=lRPjgaq1xn11rVWuY9GogL9ZGxt8iWrBVVb65q3Qffc=;
        h=Date:To:From:Subject:From;
        b=W/GySoF/j2lVKJ7uo0We4eGw6EgGbYIpm4OrpHEhzeoV6WLW6mCqkxVVUtR3ebnvI
         koHuaLNlJi1dUE5FwoNV2dX3rSzKggTrEHBzRVzRlLTBvAOImzJBQY2d0OSF12KIfp
         fDC5WP7EGhPRvOpTppS3exolp3qfZ11FO9XzBnwY=
Date:   Fri, 21 Apr 2023 14:52:36 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch removed from -mm tree
Message-Id: <20230421215236.E0C91C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: rename COW_EXTRA_LIBS to IOURING_EXTRA_LIBS
has been removed from the -mm tree.  Its filename was
     selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


