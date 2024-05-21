Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0178148822
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 23:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716334521; cv=none; b=Bv0sg1zeSXaCa9oKcz+AtG6pqrf6S/jb2iBgMCfxcSmFtQ0Ebaj8q7BwaEjsVDi/YygADdr3Hzl/0CljDhYSCs2TMKZxxPdBXjRAQVJ0vAQmb4gV51bPqe0VyDcX/2QZV847Ka58yaMPFnS/YbuJ15zZCAFC6Dmm4+y6TyXI0Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716334521; c=relaxed/simple;
	bh=8Ds+H7ft3/vxaMWfAxTa59eJ2phrM4uDMghBTP1dH7w=;
	h=Date:To:From:Subject:Message-Id; b=i1yTFwUftSaigtYW/25XFN6FRX9f+ednEbMAMru7UpsZ9uULJJNgIdypJhiR3R4khX2ZRgK3EWiybTjtRoDjw6VvHg5IHUiAAExHy6rggREnJXT4YZ0K1vh1VsSnfPCCChsXH1K37LwlVkSx2wCOSZt5YOYDikIe8ei0C+gDEg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P/74UpNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P/74UpNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DC5C2BD11;
	Tue, 21 May 2024 23:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716334521;
	bh=8Ds+H7ft3/vxaMWfAxTa59eJ2phrM4uDMghBTP1dH7w=;
	h=Date:To:From:Subject:From;
	b=P/74UpNrupR667hYNDrzqT9GkfP1FQ5FqrU1OheEINz8G5jRl8Cjz3iA9kMhuUhnE
	 LqYL3O4kWp1PxUbwWNS7BUyUARP+jCk9h+88FysNYBA8rAwN8bzGmmhP2EQ2pZHyGU
	 cf/kMe9BMPD8OhxHQBXFza5U+wmgD+XCoYzeQ48E=
Date: Tue, 21 May 2024 16:35:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-return-values.patch added to mm-unstable branch
Message-Id: <20240521233521.34DC5C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: check return values
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-check-return-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-return-values.patch

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

selftests-mm-check-return-values.patch

