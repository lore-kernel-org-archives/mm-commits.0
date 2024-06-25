Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2F217F362
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719356779; cv=none; b=h2dkK9JsMmqEQY/DmnbEgM+N6qT4oq1eXMwcvoJH1whSd2KeKYIZVRWIboaGZRLbx8voeSc/W1IjU3h+sliQmOA9JJ4TMbtTkUpZULJTDn9l36TttUOfyk4K/UFKyOVV/gVkuIV3eqDpRHRxvitj4lKARx4Wf25lNDPzcfI42RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719356779; c=relaxed/simple;
	bh=NO7u17flhMHE1eknJ70JkiFOMfU+kcdx/NTsFAwIOfY=;
	h=Date:To:From:Subject:Message-Id; b=IzK08xegKUGO5zYFXdSHOEdgBPxOfKdahB9dRudBktTv1vdi5gGWnMw/aXBqyzU1N0FBurx6H6uunwTqXQKQUVNFMPR/aWyDITbZbgq/3scRJLw7FI4h3iR5Mn4gZFXWj58zHXjSf7mUofXD8hTdoeG1rnmscpmzqaL172RWD9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gF/Qr6Jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gF/Qr6Jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8835EC32781;
	Tue, 25 Jun 2024 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719356778;
	bh=NO7u17flhMHE1eknJ70JkiFOMfU+kcdx/NTsFAwIOfY=;
	h=Date:To:From:Subject:From;
	b=gF/Qr6Jf6O7Eah+I0dpqZi9yrmEg+UytEUPcpUT2sXfXi7B/ydowVfMMaekhP8IY8
	 EmGl611NI7x+U83rqGZCG17on+2VVdt3ukRpqr9kmNSZDm+MdVEW4660CefKMvNm1V
	 ytFQ+NG3tdB6kPsRJf4aE+eSJ4z5pp6cjLsF/y64=
Date: Tue, 25 Jun 2024 16:06:17 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] update-uffd-stress-to-handle-einval-for-unset-config-features.patch removed from -mm tree
Message-Id: <20240625230618.8835EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: update uffd-stress to handle EINVAL for unset config features
has been removed from the -mm tree.  Its filename was
     update-uffd-stress-to-handle-einval-for-unset-config-features.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: update uffd-stress to handle EINVAL for unset config features
Date: Fri, 21 Jun 2024 14:12:23 -0400

Now that we have updated userfaultfd_api to correctly return EIVAL when a
feature is requested but not available, let's fix the uffd-stress test to
only set the UFFD_FEATURE_WP_UNPOPULATED feature when the config is set. 
In addition, still run the test if the CONFIG_PTE_MARKER_UFFD_WP is not
set, just dont use the corresponding UFFD_FEATURE_WP_UNPOPULATED feature.

Link: https://lkml.kernel.org/r/20240621181224.3881179-2-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
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

turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch
fix-userfaultfd_api-to-return-einval-as-expected.patch

