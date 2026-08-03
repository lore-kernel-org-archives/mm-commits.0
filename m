Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6707E286A7
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 23:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798496; cv=none; b=FXdy1u92hiY7TLAfLb7SKA33IbWCvwPHPHkeLtNPzVsU4+HM7myNsOzYU4o/4oyY7bie6Ppvi9+io2EaLBN11B1IopBAyXXsgHs0V4B3PqTbSK5CMGQqF4iP4RcA2mHEmCKRNgZpS8QbH0VbsyCt6XNsLDQdIWTv3MAGVZ4tOIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798496; c=relaxed/simple;
	bh=IUiypru4ePVEPgZDH35czLxnNZ4Lg0nm6QkRDcl7Acg=;
	h=Date:To:From:Subject:Message-Id; b=qMfj47QsrEpdYAwRZWOERav6/6tPJTjxmWHGPvF+cox1+LyxSY4NLe6D3PfjgYfhuOdvRWk5nDrzzbsPRZw3ubM8goimgB5XZjd1Qofv/gAzyr2NTiRRzVZoog77GGaFm+7JttoNGG0qWcOHCZlfvFJSC5gL6YDOZYOEALZGqoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axgToMVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axgToMVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D537B1F000E9;
	Mon,  3 Aug 2026 23:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785798494;
	bh=/ceBerk85I08dfubKWUFZ583AkupAAESUYTD67+dyP4=;
	h=Date:To:From:Subject;
	b=axgToMVmoGABy3kaH5vq0hZIainoMSqiclq4Xbt5pXAlzwJfRcvzwMJ22E2n5K2JM
	 o09+LV2PIQU6zYzNUphc59Rh517QmieKOpJVNabIqoAdRXQ6LyIXJuq962jzpXQ3fM
	 JD4dAJcgTF68J+Uxo8b8QRo8mU78HalrPXL1IlJE=
Date: Mon, 03 Aug 2026 16:08:14 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,pratmal@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-rename-local_configh-to-local_configh_gen.patch added to mm-new branch
Message-Id: <20260803230814.D537B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: rename local_config.h to local_config.h_gen
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-rename-local_configh-to-local_configh_gen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-rename-local_configh-to-local_configh_gen.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pratyush Mallick <pratmal@google.com>
Subject: selftests/mm: rename local_config.h to local_config.h_gen
Date: Mon, 3 Aug 2026 22:17:31 +0000

Patch series "selftests/mm: use pattern matching in .gitignore", v4.

The current selftests/mm/.gitignore hardcodes each generated test binary
by name, which requires manual updates every time a new test is added.

This series switches to a pattern-matching approach (similar to KVM
selftests), ignoring everything by default and allowing specific source
extensions.  To accommodate this without tracking generated headers,
local_config.h is renamed to local_config.h_gen.


This patch (of 2):

Because local_config.h is a generated build artifact, un-ignoring all .h
files in .gitignore causes it to incorrectly show up as an untracked file
in git status.

Rename it to local_config.h_gen so it no longer matches the !*.h inclusion
rule, preparing for a subsequent patch that switches .gitignore to a
pattern-matching approach.

Update Makefile, check_config.sh, and affected test sources (cow.c,
gup_longterm.c) accordingly.

Link: https://lore.kernel.org/20260803221732.3651981-1-pratmal@google.com
Link: https://lore.kernel.org/20260803221732.3651981-2-pratmal@google.com
Signed-off-by: Pratyush Mallick <pratmal@google.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    6 +++---
 tools/testing/selftests/mm/check_config.sh |    2 +-
 tools/testing/selftests/mm/cow.c           |    2 +-
 tools/testing/selftests/mm/gup_longterm.c  |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/check_config.sh~selftests-mm-rename-local_configh-to-local_configh_gen
+++ a/tools/testing/selftests/mm/check_config.sh
@@ -4,7 +4,7 @@
 # Probe for libraries and create header files to record the results. Both C
 # header files and Makefile include fragments are created.
 
-OUTPUT_H_FILE=local_config.h
+OUTPUT_H_FILE=local_config.h_gen
 OUTPUT_MKFILE=local_config.mk
 
 tmpname=$(mktemp)
--- a/tools/testing/selftests/mm/cow.c~selftests-mm-rename-local_configh-to-local_configh_gen
+++ a/tools/testing/selftests/mm/cow.c
@@ -21,7 +21,7 @@
 #include <sys/wait.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-rename-local_configh-to-local_configh_gen
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -21,7 +21,7 @@
 #include <linux/magic.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-rename-local_configh-to-local_configh_gen
+++ a/tools/testing/selftests/mm/Makefile
@@ -5,7 +5,7 @@
 # script so kunit knows to run it, and add it to the list below.
 # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
 
-LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/local_config.h_gen $(top_srcdir)/mm/gup_test.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
@@ -262,11 +262,11 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
-local_config.mk local_config.h: check_config.sh
+local_config.mk local_config.h_gen: check_config.sh
 	$(call msg,CHK,config,$@)
 	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
-EXTRA_CLEAN += local_config.mk local_config.h
+EXTRA_CLEAN += local_config.mk local_config.h_gen
 
 ifeq ($(IOURING_EXTRA_LIBS),)
 all: warn_missing_liburing
_

Patches currently in -mm which might be from pratmal@google.com are

mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch
selftests-mm-rename-local_configh-to-local_configh_gen.patch
selftests-mm-use-pattern-matching-in-gitignore.patch

