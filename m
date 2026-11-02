Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793646008;
	b=1HvSXPmvjOW5EPGfXS5+OhdO+1v2jXvgarVjgjgWZHNcDXwbDWoe1twREAjzOMuYj/dM
	 QLtbjJLZ4sMwcaOmR/c2Map+VVSv+5TzWDLjA3be352jP3GkNB4M8Gw4IXCINeSDiROjB
	 +RMGkI0D51Bq7ZBZ7eckklM1Oz7TFgcSi5Ik0ETZlRBHpv2CAbNzdsXN19Bw+cp6rlPYG
	 4er2yM3drz7Ofzi1h5Wle+VFrBzRU+sIL7Q3jKctxExYE7/qtL0lTrw8ez4mXSg5wsgbM
	 NQxMnkhMM7DxwB7vpG7RsRJJ48hRjOqTIFxAx0Lx/lQ/MH6/nlNB8miRJRa/3Z+cizw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793646008;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bqMpyzuPyICDtSav4owPaTQB8zjioPQrXnEoMVHbcUE=;
	b=sGqoTyWJ53rI3f3H3hTiUI88+Det5zBYcKRVY0bfNZvNsDjXj1aknX96ft5J9bWvUkRo
	 /E/xyQzUhrqcylJ/6ZNuIrB3w5N5QSR0EQjLuwCXZiJkE4UWcEW/nymamX7rY/dDBQkLp
	 D8Vh00f4DnKleJ5j4WK+OJA+D1tuZ+pkbI3XH6SBsE/Ygl+MlITJzVIJRvf+8C17tMjJH
	 YxTUWq4CcBMVGs0Cmbf3kIckdbCKQTFKBFg2+3gqFeCXGMFeQtLlza7CoKi/EUsXu679t
	 FjBlt+/69pK+dtn09CKCnwvZ77PkNviRw1blr9ao+UJcKEAzXmVGIs9OI13dfOJNQqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZAas+4hZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7670606D81B;
	Mon,  2 Nov 2026 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZAas+4hZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966911F00A18;
	Mon,  2 Nov 2026 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793646007;
	bh=bqMpyzuPyICDtSav4owPaTQB8zjioPQrXnEoMVHbcUE=;
	h=Date:To:From:Subject;
	b=ZAas+4hZa3DNa4TH3eG5BdyC1KFAfKC+CZ0/e4jkSB036unzDMtPLdndC3zW6VkCe
	 SLnjjZP/3myASuJNZfoeoLJ4T+4dJyFyB7mOlHEzS50p7kzXxbZHJ9Zlk/ksYLXG6Z
	 eJOF1hfMgmsnzL7Q1qxz6VNvEXERDBOSAYte/xq4=
Date: Mon, 02 Nov 2026 11:00:07 -0800
To: mm-commits@vger.kernel.org,xiaoleiwangxiaolei@gmail.com,
	stable@vger.kernel.org,shuah@kernel.org,jm5905938@gmail.com,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch added to mm-hotfixes-unstable branch
Message-Id: <20261102190007.966911F00A18@smtp.kernel.org>
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
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

