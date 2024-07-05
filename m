Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46EC15B
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141633; cv=none; b=jvBfa+rCV6QQIEzXOHyfsVpua1smzbKeo0fJfBNW6qEP8NPFsshOepNHIf8umGwdqFO+Orssf5E4lvGjC1h3AhFp+jmOYenvHmYJr3/xQjysnmaPhKN56F3Ab1lQFwqUBJntZDrTWjfa6XRdZ62N9pltI4Shz00gs3UsmRDVOkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141633; c=relaxed/simple;
	bh=e6md03KaHRhkVOcR7KS0OHyHPngrQd0TeD+M0qO0moo=;
	h=Date:To:From:Subject:Message-Id; b=gpHRhNGiek+30OehCiC8ypWs/27SAThsWJ7l7owXC7QyT+Xw7VR1LTRhFzOuBwTjNyh1mleHLFIhzKJ2p+NksyiEBxk7E/+aeNxuvFawI7L+dy55HcsL/td9MQfV9M+bQhyd21muTYTEF2ruTIQDWKMKFQi6QAGSpMeu2vurkOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFEQD2uD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFEQD2uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5502C3277B;
	Fri,  5 Jul 2024 01:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141632;
	bh=e6md03KaHRhkVOcR7KS0OHyHPngrQd0TeD+M0qO0moo=;
	h=Date:To:From:Subject:From;
	b=tFEQD2uDtPbNBJDwn2gG5ku1TetLbmSXdwUU7pH2Ee4bPdHXJGcb53bAr26SVH3to
	 XEUHdQR7GyypFg5tCJsDT1PbfRZbKCoMhqgfkQwTeQMzq4fzSpVwwinW/mEm7rVHTN
	 p9Hujqs7uRWgFRv9e/1y7ZnmZqo4C5KhHOhlQKoE=
Date: Thu, 04 Jul 2024 18:07:12 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] update-uffd-stress-to-handle-einval-for-unset-config-features.patch removed from -mm tree
Message-Id: <20240705010712.C5502C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update uffd-stress to handle EINVAL for unset config features
has been removed from the -mm tree.  Its filename was
     update-uffd-stress-to-handle-einval-for-unset-config-features.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: mm: update uffd-stress to handle EINVAL for unset config features
Date: Wed, 26 Jun 2024 09:05:12 -0400

Now that we have updated userfaultfd_api to correctly return EINVAL when a
feature is requested but not available, let's fix the uffd-stress test to
only set the UFFD_FEATURE_WP_UNPOPULATED feature when the config is set. 
In addition, still run the test if the CONFIG_PTE_MARKER_UFFD_WP is not
set, just dont use the corresponding UFFD_FEATURE_WP_UNPOPULATED feature.

Link: https://lkml.kernel.org/r/20240626130513.120193-2-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~update-uffd-stress-to-handle-einval-for-unset-config-features
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -36,6 +36,8 @@
 #include <asm-generic/unistd.h>
 #include "uffd-common.h"
 
+uint64_t features;
+
 #define BOUNCE_RANDOM		(1<<0)
 #define BOUNCE_RACINGFAULTS	(1<<1)
 #define BOUNCE_VERIFY		(1<<2)
@@ -245,10 +247,14 @@ static int userfaultfd_stress(void)
 	unsigned long nr;
 	struct uffd_args args[nr_cpus];
 	uint64_t mem_size = nr_pages * page_size;
+	int flags = 0;
 
 	memset(args, 0, sizeof(struct uffd_args) * nr_cpus);
 
-	if (uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED, NULL))
+	if (features & UFFD_FEATURE_WP_UNPOPULATED && test_type == TEST_ANON)
+		flags = UFFD_FEATURE_WP_UNPOPULATED;
+
+	if (uffd_test_ctx_init(flags, NULL))
 		err("context init failed");
 
 	if (posix_memalign(&area, page_size, page_size))
@@ -383,8 +389,6 @@ static void set_test_type(const char *ty
 
 static void parse_test_type_arg(const char *raw_type)
 {
-	uint64_t features = UFFD_API_FEATURES;
-
 	set_test_type(raw_type);
 
 	if (!test_type)
@@ -407,8 +411,8 @@ static void parse_test_type_arg(const ch
 	 * feature.
 	 */
 
-	if (userfaultfd_open(&features))
-		err("Userfaultfd open failed");
+	if (uffd_get_features(&features))
+		err("failed to get available features");
 
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
_

Patches currently in -mm which might be from audra@redhat.com are


