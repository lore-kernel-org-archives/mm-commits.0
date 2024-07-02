Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC82E62B
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 05:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897128; cv=none; b=LdxYyjRi+3dACTfOi381bIvzIIjbR1Cd8UYrb/0qlbGAvuOgHhOdJFxv5Crar+y40iCBcNc9VThq9UMNxFpsq36TdgWWWa8kYhA7kpRPVf73h29pVXNSJs9NAGJrDoXbG7lW5Pa2HoZXX/f5NxPh2lpiMBaTS82VO/uW+zmn3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897128; c=relaxed/simple;
	bh=roVfQyhpNfeQyBsgMm8hiOphwIa/VvX1g+NbDYmazuU=;
	h=Date:To:From:Subject:Message-Id; b=QA79Rd3ARQb0pMjEDDPkXZ2904QNONGXD4Q7pIFfWNZrn40lbOBP7ZyIuuiSd9g9SqX6xvXJNylsvGwZ+n53ZtCFfrZNZSc+15oiQNe4Lzsc0yhMpEoh3rg8CXxv7pLUcqemnW+3AOCUt7NWkyhW3z83fNake5YiQGZuO8t1SX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NmRjK3Xv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NmRjK3Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA687C116B1;
	Tue,  2 Jul 2024 05:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719897127;
	bh=roVfQyhpNfeQyBsgMm8hiOphwIa/VvX1g+NbDYmazuU=;
	h=Date:To:From:Subject:From;
	b=NmRjK3XvMA0JfNpJAlBAieKxYUM8OkGumEUXDRDo6LN5bOydS+0bso0dEX4Ai9QiJ
	 66MGXLVitNXdOjd0B9tQCct6Sealgo/CAif2Nzr9WUSHm6MtDILT2dWbXhUPHRPB2T
	 H1B9zo1N19VfdVSP7m/3RZKBl9nC5vOUFeS1DMGs=
Date: Mon, 01 Jul 2024 22:12:07 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,swarupkotikalapudi@gmail.com,shuah@kernel.org,luto@kernel.org,kees@kernel.org,amer.shanawany@gmail.com,make24@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to.patch added to mm-nonmm-unstable branch
Message-Id: <20240702051207.CA687C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/capabilities: fix possible file leak in copy_fromat_to
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to.patch

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
From: Ma Ke <make24@iscas.ac.cn>
Subject: selftests/capabilities: fix possible file leak in copy_fromat_to
Date: Sun, 30 Jun 2024 21:00:38 +0800

open() returns -1 on error.  openat() and open() initialize 'from' and
'to', and only 'from' validated with 'if' statement.  If the
initialization of variable 'to' fails, we should better check the value of
'to' and close 'from' to avoid possible file leak.  Improve the checking
of 'from' additionally.

Link: https://lkml.kernel.org/r/20240630130038.3671507-1-make24@iscas.ac.cn
Fixes: 32ae976ed3b5 ("selftests/capabilities: Add tests for capability evolution")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Cc: Amer Al Shanawany <amer.shanawany@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/capabilities/test_execve.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/capabilities/test_execve.c~selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to
+++ a/tools/testing/selftests/capabilities/test_execve.c
@@ -145,10 +145,14 @@ static void chdir_to_tmpfs(void)
 static void copy_fromat_to(int fromfd, const char *fromname, const char *toname)
 {
 	int from = openat(fromfd, fromname, O_RDONLY);
-	if (from == -1)
+	if (from < 0)
 		ksft_exit_fail_msg("open copy source - %s\n", strerror(errno));
 
 	int to = open(toname, O_CREAT | O_WRONLY | O_EXCL, 0700);
+	if (to < 0) {
+		close(from);
+		ksft_exit_fail_msg("open copy destination - %s\n", strerror(errno));
+	}
 
 	while (true) {
 		char buf[4096];
_

Patches currently in -mm which might be from make24@iscas.ac.cn are

selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to.patch

