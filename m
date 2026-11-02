Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645965;
	b=o0nbm92ikRCKZcbVTJ7Ow09ThBcnNOEiNXp9hysHO+PlbSQwUo7RvipwWpM1MniB0GzK
	 zedZy2C4txbQoMLHTUaZCaLheCQZEXTk7LW2qKMhesb3nCj36ipdg6fOKjKQSzrGoZEOX
	 Vd6amcGgCfcNtbhOmXFrTK9lZyeYWzP0xSrKLO20FOln4FAo/dE/DoEnzVXGVP5bgNYAa
	 JM56dOHI0KJJa3aCGIdhvy+DKg0srHIeGEZucHEh2QnhnfJe//V+KvK0uNpDs97+VDKsI
	 vf6A9RfrOuk4NGLVUX4vOFN2RVQLBerPHAgJw2nUrzqyAosEJYX8HRgetaBJnDf+7Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645965;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=l09uUE5m4Jt1XwhdIwNFNVPKCvijrWu8aYo7W5B2k58=;
	b=O0LMJ8NzW2Inn4p17bTljGmQtvtdCWgk1oyQCOv7RqJtWMQHtY3sN9b/h2/KV45Xn/Ex
	 UuvjV6+YH88YbjWBkrpvEmqfZ90vOJTiQG+PJMS7nfT7OpIqi3OmrGzAxIY4i6vFQYyA7
	 rxUYhuyevK3wKKEQ1c25Zl/Uq0EBQjeyLFiOgJR37demDx8V0iUUD0ROVhxyhMeYM4JFy
	 i9+ICqFZ+/ZjcyGnu/F9P+d67n29Mdh/muShwEtAjScbapuLCUrlIJZgl35CF/y6JM0uu
	 GX2Y4n1OUBAQ3aIZJW0u0gHqX8nTtiW2IaoSQ2FXyPr0zDf3GtgfTLp+jzUl4grqcrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="wB9wq0l/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE93606A327;
	Mon,  2 Nov 2026 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wB9wq0l/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D7F1F00A17;
	Mon,  2 Nov 2026 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793645964;
	bh=l09uUE5m4Jt1XwhdIwNFNVPKCvijrWu8aYo7W5B2k58=;
	h=Date:To:From:Subject;
	b=wB9wq0l/gGU+NjrT8+2OAVPvZ2qmxleMwaQApmQUBGeHIpklmqTIdl2TaBsfJcS8e
	 LkdKRkgIhUdHNU3NHfo0aZqYYfl0JxvG+sa76FRRGN3c8u7w/GA76VwSemevTWSdLf
	 HGUPLR9Sfrtfb4IciVB8JfC7biPkA3tMWRP02OPM=
Date: Mon, 02 Nov 2026 10:59:24 -0800
To: mm-commits@vger.kernel.org,xiaoleiwangxiaolei@gmail.com,
	stable@vger.kernel.org,shuah@kernel.org,jm5905938@gmail.com,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch added to mm-new branch
Message-Id: <20261102185924.A5D7F1F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/damon/sysfs_memcg_path_leak: define ksft_skip
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch

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
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/sysfs_memcg_path_leak: define ksft_skip
Date: Mon, 02 Nov 2026 06:46:26 -0800

sysfs_memcg_path_leak test uses $ksft_skip without defining it.  As a
result, the test is marked as passed while it was skipped, like below.

    $ ./sysfs_memcg_path_leak.sh
    Run as root
    $ echo $?
    0

Users who run the test could therefore wrongly believe the test was run
and passed while it was skipped.

Define the value at the beginning of the test.  After this patch, the
exit code reflects the skip.

    $ ./sysfs_memcg_path_leak.sh
    Run as root
    $ echo $?
    4

Link: https://lore.kernel.org/20261102144627.88843-4-sj@kernel.org
Fixes: dfa3cf0bc018 ("selftets/damon: add a test for memcg_path leak")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-a0456336-0608-4fec-ac22-0ee61d1d6a91
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
Cc: <stable@vger.kernel.org> # 6.17.x
---

 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh~selftests-damon-sysfs_memcg_path_leak-define-ksft_skip
+++ a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 if [ $EUID -ne 0 ]
 then
 	echo "Run as root"
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch
mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch
mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch

