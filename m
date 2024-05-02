Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11215E5A9
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669902; cv=none; b=gTSe3i8JBJzUh8i/ehoRuiEwi2wdOlzccXlZWPL94OFmueTvTh6mB7iLDXzIKUBoddBwK/Q6pDrm0kzpBOiyZ4nbcCI1ad6l+QBvh9Z6St28uT30R558h+oaDRPZkGLhIa0q+ysFi4heKWy64YfRBFMWvcVL4S4yJDu8+YAfQHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669902; c=relaxed/simple;
	bh=WCIpJvd51WqiVpXjxquCS321eKba/mazqzNz4quKo9s=;
	h=Date:To:From:Subject:Message-Id; b=HtCLNyO2TclK0xuPJKPeKDuTCM7a7G3UvbFVAAq345MUdS/KeKTVCPwwebExi37gkgQGAB8bapKxKZkUqabGP9J9TLMTFEGw1AzeZd3mvXrSZhIPnoq3ug2tqlJBe9n1TZ6eX389L3ygD1HyGBA6ZvaZZKWfLCtXzKcAadz+vN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=er5SJd4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="er5SJd4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B5BC113CC;
	Thu,  2 May 2024 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714669901;
	bh=WCIpJvd51WqiVpXjxquCS321eKba/mazqzNz4quKo9s=;
	h=Date:To:From:Subject:From;
	b=er5SJd4/zpFkfMzBmai7VcvD2Mg/dBJevzxDpGuAsYFGtnPbLxHM/5gjKncT/VfqS
	 hJ4ALHO4i3w9TKKd5qcB8BHtaAJ7bN7kuVz0vgeVnErrrR0yxopEArpOA6j6F68t82
	 tXRSwsbxHYP92ohll0tUJ+SOilndBCAOx5XRYoVs=
Date: Thu, 02 May 2024 10:11:39 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,gorcunov@gmail.com,ebiederm@xmission.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-kcmp-remove-unused-open-mode.patch added to mm-nonmm-unstable branch
Message-Id: <20240502171141.54B5BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/kcmp: remove unused open mode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-kcmp-remove-unused-open-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-kcmp-remove-unused-open-mode.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Edward Liaw <edliaw@google.com>
Subject: selftests/kcmp: remove unused open mode
Date: Mon, 29 Apr 2024 23:46:09 +0000

Android bionic warns that open modes are ignored if O_CREAT or O_TMPFILE
aren't specified.  The permissions for the file are set above:

	fd1 = open(kpath, O_RDWR | O_CREAT | O_TRUNC, 0644);

Link: https://lkml.kernel.org/r/20240429234610.191144-1-edliaw@google.com
Fixes: d97b46a64674 ("syscalls, x86: add __NR_kcmp syscall")
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/kcmp_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/kcmp/kcmp_test.c~selftests-kcmp-remove-unused-open-mode
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -91,7 +91,7 @@ int main(int argc, char **argv)
 		ksft_print_header();
 		ksft_set_plan(3);
 
-		fd2 = open(kpath, O_RDWR, 0644);
+		fd2 = open(kpath, O_RDWR);
 		if (fd2 < 0) {
 			perror("Can't open file");
 			ksft_exit_fail();
_

Patches currently in -mm which might be from edliaw@google.com are

selftests-kcmp-remove-unused-open-mode.patch

