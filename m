Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68B41C84CB
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622826; cv=none; b=XrJywfFT3kEL1BWloWISC4YkfoZCq5eUqW3zPLgS5Jcup9Q7vGKHkb3VDCFgu9fTfhCZyieDGVuIHnKE9cuQ+Mm6AvvpHVjSDtRndKGH2hsYa/bed4OfbPJ3gBgbdrFawyOvMYH5lhl1bVcpW+yHqWZH1c+sN9GER+AlcECp//Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622826; c=relaxed/simple;
	bh=c6pERmJWAfuK3n56x61LilwgvOrd824nQymGn5AMsUw=;
	h=Date:To:From:Subject:Message-Id; b=UNzM96eX/DpQZVNFalyxDHaKApGaM7BvNEedvhEnAw2iDr4HzSqgJf8k4Ca4Jjm7imQHQEkdzb/qywsOy9lPX6rWNmpQY8Mupf62/Qp/8B/6xDm8nqt10ITbvFG3OzGH6QDQrFR80GBCx0mKAs5fpLUqmlEJZPZmIXKwKjt+Hok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXQYz34w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXQYz34w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8173F1F00A3A;
	Tue, 25 Aug 2026 01:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622824;
	bh=BINYh6vqfhsndSicph1R6is9xPaihbKRVNLvhJDP4h4=;
	h=Date:To:From:Subject;
	b=lXQYz34w6/TA4KcHYelioBXoPyeRSfDeaImzXhI/r5gWrTQT8jvCqoUjrE1N3Q6HH
	 RKwIm+hhhjzZtnzAIpw6CnpF/PY51vqXji4kijvEv1UTWmqd0iv86m6ut4cimRQDbB
	 Rphtw8uQfWGtQzy/LoiNJvi8OgNwZ1H/JJJSkP5U=
Date: Mon, 24 Aug 2026 18:53:44 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,pratmal@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-rename-local_configh-to-local_configh_gen.patch removed from -mm tree
Message-Id: <20260825015344.8173F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: rename local_config.h to local_config.h_gen
has been removed from the -mm tree.  Its filename was
     selftests-mm-rename-local_configh-to-local_configh_gen.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: "Liam R. Howlett" <liam@infradead.org>
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
@@ -261,11 +261,11 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
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


