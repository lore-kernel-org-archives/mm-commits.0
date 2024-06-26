Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EE319149E
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719431710; cv=none; b=kl6nJWjAUddc/hx6VhMDQc1H7LdT6OkKatdypBnZHTi6wTLwf1HzvOqMl0G7apM7WTygwbD6jpbD4zCv7sE8qcRZP5a5/AQg0XyAcaXqxfMioSrz6oObJ79ZyrI7kj+Thw/e+lqLE4P42JMX+5GiXtASfaRlDVG0Heuml18/4OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719431710; c=relaxed/simple;
	bh=7bEOob7exTqzoyVIZ0zkboGStfEqjJgNHB1rVWXBNhc=;
	h=Date:To:From:Subject:Message-Id; b=eJc5u/WGScSMCMQYQV76z+czmXAW5WnPb9aYqHDwpmhQqMaS1ZHZJPKO7FSOLPwTiWUMwPhfKFNSGydn0kTTyskserZ2KVgpaF1TR50pmF9DIDeC1GUrwlZ64+b/6dxoOFYEg/cIxJMEvs7fOu9zc+E5O5bOoArlJ0bO3wjMZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IRE1gTMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IRE1gTMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992EFC116B1;
	Wed, 26 Jun 2024 19:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719431709;
	bh=7bEOob7exTqzoyVIZ0zkboGStfEqjJgNHB1rVWXBNhc=;
	h=Date:To:From:Subject:From;
	b=IRE1gTMNTbUfI0cyf/3jALGuKNr4wXFqhsUJ8wJ24p0CcZhaMX6fvH3mT/8p/jni7
	 DFliHMt6HvqLD8FFSU5Ne0zW9Adi1bBKHBG8lVY6G7+qem1Phw2ErXy6vavE0sS0fp
	 QfrKfeFtdp3vZbfssoyE5DQY2UssOfCE8owfbY3M=
Date: Wed, 26 Jun 2024 12:55:09 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + update-uffd-stress-to-handle-einval-for-unset-config-features.patch added to mm-unstable branch
Message-Id: <20240626195509.992EFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update uffd-stress to handle EINVAL for unset config features
has been added to the -mm mm-unstable branch.  Its filename is
     update-uffd-stress-to-handle-einval-for-unset-config-features.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/update-uffd-stress-to-handle-einval-for-unset-config-features.patch

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

fix-userfaultfd_api-to-return-einval-as-expected.patch
update-uffd-stress-to-handle-einval-for-unset-config-features.patch
turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

