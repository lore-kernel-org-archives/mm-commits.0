Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C526D1411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756838; cv=none; b=TNjpbbTCACrJxaLVR1OxoydOctnrirMogqpLCs5rJ/IyoCOz7wvKr0BYWMMKcgmgZ22rjdVXBKj6MPJX++8O50w8uWvRi5FNo9gm6U8BUPsaL/CWxBOuTzFYs4JvgUzkXkMT5gHoioNWB+RCFkjOutWnah5oXyqjB8NY7GCdjXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756838; c=relaxed/simple;
	bh=Eo6tPrCNMZuzkaYDl9vNdk57HhklDDXhMlUcTDhKijs=;
	h=Date:To:From:Subject:Message-Id; b=D+6PR6c97Cy3nPxpZWbPknnlVokXAj9v2Jtw1DGACgy2jLmBwie4qZlyo3WTxLHCzbPt/n6gNdnFo9z1jdT1oHmQrIASm+96SpL1Fw+bjp3ea9OUMKg0WhJx/adobc9Fj9H8nlUmM4hJqLaDOk+GCvRq2pBA8IbIlmWohWDCebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dwbg/rs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dwbg/rs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB2C4CEED;
	Sun,  1 Jun 2025 05:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756838;
	bh=Eo6tPrCNMZuzkaYDl9vNdk57HhklDDXhMlUcTDhKijs=;
	h=Date:To:From:Subject:From;
	b=dwbg/rs46K5jrf/RCS5iVVimnYvh9vrc+I4xbhEEeePblZhhrllUNhD/3NWgrR8Km
	 h8HuHqurzzB7uQK/yXPwN7JhIoI36m+IbdaCH4Dm8if/TD2V8+OvBh2WAL6JROj0Vf
	 DXwhaOCsAwd79cA31VW9WIFAFinb4zuiO7IMyz9A=
Date: Sat, 31 May 2025 22:47:18 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,adam@wowsignal.io,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch removed from -mm tree
Message-Id: <20250601054718.8FDB2C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip guard_regions.uffd tests when uffd is not present
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: skip guard_regions.uffd tests when uffd is not present
Date: Fri, 16 May 2025 09:29:37 -0400

Patch series "Skip mm selftests instead when kernel features are not
present", v2.

Two guard_regions tests on userfaultfd fail when userfaultfd is not
present.  Skip them instead.

hugevm test reads kernel config to get page table level information and
fails when neither /proc/config.gz nor /boot/config-* is present.  Skip it
instead.


This patch (of 2):

When userfaultfd is not compiled into kernel, userfaultfd() returns -1,
causing guard_regions.uffd tests to fail.  Skip the tests instead.

Link: https://lkml.kernel.org/r/20250516132938.356627-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250516132938.356627-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Adam Sindelar <adam@wowsignal.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -1453,8 +1453,21 @@ TEST_F(guard_regions, uffd)
 
 	/* Set up uffd. */
 	uffd = userfaultfd(0);
-	if (uffd == -1 && errno == EPERM)
-		ksft_exit_skip("No userfaultfd permissions, try running as root.\n");
+	if (uffd == -1) {
+		switch (errno) {
+		case EPERM:
+			SKIP(return, "No userfaultfd permissions, try running as root.");
+			break;
+		case ENOSYS:
+			SKIP(return, "userfaultfd is not supported/not enabled.");
+			break;
+		default:
+			ksft_exit_fail_msg("userfaultfd failed with %s\n",
+					   strerror(errno));
+			break;
+		}
+	}
+
 	ASSERT_NE(uffd, -1);
 
 	ASSERT_EQ(ioctl(uffd, UFFDIO_API, &api), 0);
_

Patches currently in -mm which might be from ziy@nvidia.com are


