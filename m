Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F4717C9FA
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 23:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719356780; cv=none; b=mQAYfMF++YmybMDbzZoxuMQBjwbaBoVhoCx/fWddKCuB2K3uM4r4gojy3Ye+4jP3xyrtiNJDd5nqmtcl3QW+gBMCwm+qBhJV0TUkCznvPQVFLGG1pEzMoJz28hf6laA3qglOVOfVAwl1o/MjxDg88HwWmzEOXY4q3/K4HJS50gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719356780; c=relaxed/simple;
	bh=pjWHeFbITlOIxYRm8xkLnGHY6EIv3z1+yuTz5TFTGnk=;
	h=Date:To:From:Subject:Message-Id; b=FCH3WAEmXs9YQQlpjUPyV+xyw0h4K29Vo263KEQom1455UyfXL/b9FWvA2Yco7AEREAUZyVwbgDpCFnP4sMe3FQTrvzJJs6B9nkXWF6PQQ7JHf5f2gclFSTuk+hrGek27Ft2LBqF3U1mmQd5OpkKuMwV0qcbGDSRfEQg9iTNSLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ay42LmdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ay42LmdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7707C32781;
	Tue, 25 Jun 2024 23:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719356779;
	bh=pjWHeFbITlOIxYRm8xkLnGHY6EIv3z1+yuTz5TFTGnk=;
	h=Date:To:From:Subject:From;
	b=Ay42LmdKsrHDHsl7cRBHjgsFQDkz5VkE+8b9CkvO1uthdk0axO0kJbtW7E2uim56j
	 tzzfDRAnNflmgMiMq6FJ2zOCRZw/U769yqIv8KImDT6Lq5FTtzlt3NsPkQQihvkIpV
	 MW3slddQBbuM2X8I76VZkXtKhf7JhrJQNLT9XdwE=
Date: Tue, 25 Jun 2024 16:06:19 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,shuah@kernel.org,shli@fb.com,rppt@linux.vnet.ibm.com,raquini@redhat.com,peterx@redhat.com,jack@suse.cz,brauner@kernel.org,aarcange@redhat.com,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch removed from -mm tree
Message-Id: <20240625230619.D7707C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
has been removed from the -mm tree.  Its filename was
     turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: turn off test_uffdio_wp if CONFIG_PTE_MARKER_UFFD_WP is not configured.
Date: Fri, 21 Jun 2024 14:12:24 -0400

If CONFIG_PTE_MARKER_UFFD_WP is disabled, then testing with test_uffdio_up
enables calling uffdio_regsiter with the flag UFFDIO_REGISTER_MODE_WP. 
The kernel ensures in vma_can_userfault() that if
CONFIG_PTE_MARKER_UFFD_WP is disabled, only allow the VM_UFFD_WP on
anonymous vmas.

Link: https://lkml.kernel.org/r/20240621181224.3881179-3-audra@redhat.com
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

 tools/testing/selftests/mm/uffd-stress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/uffd-stress.c~turn-off-test_uffdio_wp-if-config_pte_marker_uffd_wp-is-not-configured
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -417,6 +417,9 @@ static void parse_test_type_arg(const ch
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
+	if (test_type != TEST_ANON && !(features & UFFD_FEATURE_WP_UNPOPULATED))
+		test_uffdio_wp = false;
+
 	close(uffd);
 	uffd = -1;
 }
_

Patches currently in -mm which might be from audra@redhat.com are

fix-userfaultfd_api-to-return-einval-as-expected.patch

