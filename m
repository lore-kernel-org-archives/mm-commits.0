Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293137;
	b=MvhACkdGRA1VLZvYAUjdA4fpcRSjYDdf/KdlV/GoMgFA8lM0B3rJ+yf5LRnv0x3MifNU
	 1iOHCI30vdy485gWgLJj8eh+cUi1cTc2bz19oZrA/T89TZPii8om0qPH/xSH/abg1JGBk
	 Z5Iod70wEBDch/KUQ6Z+z+2imE0AAOjAuTjaZujL+ZcQaJ39Ek6uOG8TYKxgsBl7wlSXM
	 CfINSvQ63d9HwlyVIsy87a+ATtnIP/wbl1/9eldEyr+rIH3to4MYSPNUiYUuEAqKkemWr
	 lhMWgxObhbYK4elBzDIcnzVwZh7+AEvFZNck4vproKquhpucLsw53etaxCmRTjpG1kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293137;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rcB4w2OeFL9QwrJnpScwYDFe02N+HdX+VjYuzdDMku8=;
	b=bpqgB8b3BozmpKkGjM+iYC6XSFAI84eilQyovfgsHc3qyNoZWsmYUYXnzBYwHH+vy541
	 Qn6B/ouyCO+8oRodiEpiHiPB4sUYXMBD6ueEpdt1EAtBvjkMzgpHu5uOWZAZ6ML7F5Rwx
	 4bbliLefOED4jIGcZMAIr4GOzG02T7HPMdS+s6dsa6+GqI+3Diunt7vfKjzXKEYidXo0L
	 vpP+nxaYIoSF0NHbdIC9EzpyNnbHaw+E0kCCK5OfsQzCDR6uQnWxyMWIaIC0qnI1PAJn8
	 5Amv7sdWu7X/J+EGxNF8cqK74fQQRPj9+uh+fwU8N1Ei0O1T0Bl5eNd9e1PV4B60jig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zXYyEGXW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355C46070341;
	Tue, 10 Nov 2026 06:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zXYyEGXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43AD1F0089F;
	Tue, 10 Nov 2026 06:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293137;
	bh=rcB4w2OeFL9QwrJnpScwYDFe02N+HdX+VjYuzdDMku8=;
	h=Date:To:From:Subject;
	b=zXYyEGXW/b/v+uERu7FGqetHmeqbvZjbeJn0h4U8sc87VpYtRmhOWngrlK11xiWrO
	 5qePesp6hr9ZlYG6UfylGJEkAXOYzV8xPbXy1S4gBZuHCBYYPBOVgFUVTUSg09ceAM
	 fa4KMW2z97oc7OzbCw6rsxvHeaHIL3gb5J15TUOg=
Date: Mon, 09 Nov 2026 22:45:36 -0800
To: mm-commits@vger.kernel.org,xiaoleiwangxiaolei@gmail.com,
	stable@vger.kernel.org,shuah@kernel.org,jm5905938@gmail.com,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch removed from -mm tree
Message-Id: <20261110064536.E43AD1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/damon/sysfs_memcg_path_leak: define ksft_skip
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

