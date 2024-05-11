Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356361CD0C
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467330; cv=none; b=OZtNfGAbsas6Un9Jib4KjGrlVTGAocaBIBK7xsUvcnbA+AdApNOT86a4eyjs+0RnBsOrIfFAUYJymmvICrNYCoDkI73w/2Cfi6OKfBwBR0T0DSvjYxC+/1WmCVh/lpjbcMUAl5o36NgV0VmFi6mZ5/aXUtE9YNRGSyTCdBXX+EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467330; c=relaxed/simple;
	bh=+uP0gOk2SU37omZetUPHgVbFGHXv0u3FMQnR2cKel+4=;
	h=Date:To:From:Subject:Message-Id; b=B4morq1L0cogbf6ZShRdbqGnvW8qjtkLRpExSdQkG+Jkoxu5kxFBW/tFc5h5eyyUyjhzzYJy1Atz3yAAScJcYU7lK6Nb7x+HWuAe+L3dxYxHBrQvrEr01GaGRXlrlqg8azwlPtkpn38gHBkZsfHwG8jCRQkWeNXZPP3RS7ixlOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q1jnFxKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q1jnFxKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C810CC32782;
	Sat, 11 May 2024 22:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467328;
	bh=+uP0gOk2SU37omZetUPHgVbFGHXv0u3FMQnR2cKel+4=;
	h=Date:To:From:Subject:From;
	b=q1jnFxKE82fNR+jEk26rUhUfBn5q/aGQM5h9cOBMtQfPOmetiZGwEgIXI0SdmGK+h
	 gIAh8iRKHjo23E4C1y7VSNXM7Y8HBTxzUlMw9zQ1QqqFPvNoa/ykoSyIzB/6AAwcV5
	 FSqJ7fB7vx/RejI68CekdDaRPq/ZuBY316eLIMUg=
Date: Sat, 11 May 2024 15:42:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch removed from -mm tree
Message-Id: <20240511224208.C810CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: find sysfs mount point from /proc/mounts
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: find sysfs mount point from /proc/mounts
Date: Fri, 3 May 2024 11:03:11 -0700

_damon_sysfs.py assumes sysfs is mounted at /sys.  In some systems, that
might not be true.  Find the mount point from /proc/mounts file content.

Link: https://lkml.kernel.org/r/20240503180318.72798-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -2,7 +2,18 @@
 
 import os
 
-sysfs_root = '/sys/kernel/mm/damon/admin'
+ksft_skip=4
+
+sysfs_root = None
+with open('/proc/mounts', 'r') as f:
+    for line in f:
+        dev_name, mount_point, dev_fs = line.split()[:3]
+        if dev_fs == 'sysfs':
+            sysfs_root = '%s/kernel/mm/damon/admin' % mount_point
+            break
+if sysfs_root is None:
+    print('Seems sysfs not mounted?')
+    exit(ksft_skip)
 
 def write_file(path, string):
     "Returns error string if failed, or None otherwise"
_

Patches currently in -mm which might be from sj@kernel.org are


