Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B46113D251
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291564; cv=none; b=g22XjqV9Td54IOqh0Wf3UFfsIZ5KFRjErYUqO8e3TciR4vx/AeQeirSAKmiVz+g83U/RbEmpH4Um9NASZYezzxR42nRR2E/bMgaKZgXgVHgt2cOo7wvAwQUy3YUY3qqzNN+4OWBLPKe7h+yrmEj03k35xNA/7kTxGi/aRske6Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291564; c=relaxed/simple;
	bh=FiVVdKpM2cO+u618SxzA4m6HP0qH5zOqvZ0fBRKRzpo=;
	h=Date:To:From:Subject:Message-Id; b=j9Ln3MU0cWsm9eIjCJxT8DaGqMGDSOf3jCV7WmedOawEmPiOOlTNDEuuhZD12lJzhht6NPd2Fb9G81RUSSMLOK02V3FZOdiSwW32/wPCePw0//ngtobb3QhfBVKgpmkcP7HtBtzDqV/llVOJRLsoo/d80qOwsDqVMsygvq2/Dw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjmcvJeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjmcvJeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B15C32782;
	Tue, 25 Jun 2024 04:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291564;
	bh=FiVVdKpM2cO+u618SxzA4m6HP0qH5zOqvZ0fBRKRzpo=;
	h=Date:To:From:Subject:From;
	b=NjmcvJeBd6dOx0I4d7d1GLChoj1eQkCYGGRXctiM06Zira1+FgibMiOJfMzuBqkSi
	 ywbUxhhvuCtp04WbyrhkXgw9fy6lJaZvRd6uzTzwPHMzDbtWaCAGTYv6YuBzwMNxcG
	 wCJ7WASKqC0dxto7Bqni8JjjECHNIrW6Rvr6KEYU=
Date: Mon, 24 Jun 2024 21:59:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-return-values.patch removed from -mm tree
Message-Id: <20240625045924.67B15C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: check return values
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-return-values.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: check return values
Date: Mon, 20 May 2024 11:52:48 -0700

Check return value and return error/skip the tests.

Link: https://lkml.kernel.org/r/20240520185248.1801945-1-usama.anjum@collabora.com
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-check-return-values
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1567,8 +1567,10 @@ int main(int argc, char *argv[])
 	/* 7. File Hugetlb testing */
 	mem_size = 2*1024*1024;
 	fd = memfd_create("uffd-test", MFD_HUGETLB | MFD_NOEXEC_SEAL);
+	if (fd < 0)
+		ksft_exit_fail_msg("uffd-test creation failed %d %s\n", errno, strerror(errno));
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	if (mem) {
+	if (mem != MAP_FAILED) {
 		wp_init(mem, mem_size);
 		wp_addr_range(mem, mem_size);
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


