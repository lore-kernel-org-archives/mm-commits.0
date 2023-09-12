Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4C8CA0EF1
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 16:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjILQC1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbjILQCR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 12:02:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E49D170B
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 09:02:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC525C433C9;
        Tue, 12 Sep 2023 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694534533;
        bh=eXTLyAH8AVDBbtMlYixUyNAZP8FDdsXcOP1KxKN54yE=;
        h=Date:To:From:Subject:From;
        b=Gnj/5pllgEmagyMZaoMV85Qa1cZILPuXtdOHbLKj76L8I65p5fjZJP/68bwiw5ghi
         RzBPVUBO1D4xUkC3ZGE46ryTLs6/4C2AXLNYEbNm/4EoNOByfxNNopofH5gQk76tqt
         26Fg/2TtsY8nkJMMZep1GFYqV+GRXFZpzJX+JY1I=
Date:   Tue, 12 Sep 2023 09:02:13 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, shuah@kernel.org,
        revest@chromium.org, peterx@redhat.com, oliver.sang@intel.com,
        jhubbard@nvidia.com, jglisse@redhat.com, david@redhat.com,
        broonie@kernel.org, ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-link-libasan-statically-for-tests-with-fsanitize=address.patch added to mm-hotfixes-unstable branch
Message-Id: <20230912160213.BC525C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: link libasan statically for tests with -fsanitize=address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-link-libasan-statically-for-tests-with-fsanitize=address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-link-libasan-statically-for-tests-with-fsanitize=address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests: link libasan statically for tests with -fsanitize=address
Date: Tue, 12 Sep 2023 14:50:48 +0100

When dynamically linking, Address Sanitizer requires its library to be the
first one to be loaded; this is apparently to ensure that every call to
malloc is intercepted.  If using LD_PRELOAD, those listed libraries will
be loaded before the libraries listed in the program's ELF and will
therefore violate this requirement, leading to the below failure and
output from ASan.

commit 58e2847ad2e6 ("selftests: line buffer test program's stdout")
modified the kselftest runner to force line buffering by forcing the test
programs to run through `stdbuf`.  It turns out that stdbuf implements
line buffering by injecting a library via LD_PRELOAD.  Therefore selftests
that use ASan started failing.

Fix this by statically linking libasan in the affected test programs,
using the `-static-libasan` option.  Note this is already the default for
Clang, but not got GCC.

Test output sample for failing case:

  TAP version 13
  1..3
  # timeout set to 300
  # selftests: openat2: openat2_test
  # ==4052==ASan runtime does not come first in initial library list;
  you should either link runtime to your application or manually preload
  it with LD_PRELOAD.
  not ok 1 selftests: openat2: openat2_test # exit=1
  # timeout set to 300
  # selftests: openat2: resolve_test
  # ==4070==ASan runtime does not come first in initial library list;
  you should either link runtime to your application or manually preload
  it with LD_PRELOAD.
  not ok 2 selftests: openat2: resolve_test # exit=1

Link: https://lkml.kernel.org/r/20230912135048.1755771-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: 58e2847ad2e6 ("selftests: line buffer test program's stdout")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202309121342.97e2f008-oliver.sang@intel.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/fchmodat2/Makefile |    2 +-
 tools/testing/selftests/openat2/Makefile   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/fchmodat2/Makefile~selftests-link-libasan-statically-for-tests-with-fsanitize=address
+++ a/tools/testing/selftests/fchmodat2/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-CFLAGS += -Wall -O2 -g -fsanitize=address -fsanitize=undefined $(KHDR_INCLUDES)
+CFLAGS += -Wall -O2 -g -fsanitize=address -fsanitize=undefined -static-libasan $(KHDR_INCLUDES)
 TEST_GEN_PROGS := fchmodat2_test
 
 include ../lib.mk
--- a/tools/testing/selftests/openat2/Makefile~selftests-link-libasan-statically-for-tests-with-fsanitize=address
+++ a/tools/testing/selftests/openat2/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
-CFLAGS += -Wall -O2 -g -fsanitize=address -fsanitize=undefined
+CFLAGS += -Wall -O2 -g -fsanitize=address -fsanitize=undefined -static-libasan
 TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test
 
 include ../lib.mk
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-link-libasan-statically-for-tests-with-fsanitize=address.patch

