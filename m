Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96914A28
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467938; cv=none; b=Fn9HMSjh+wEuRTEfIi4Ma8vsIQXRnzw6cOUx6nMSRUTgNqLuDsNBhUho7jBbVDRxdCvTsoFPyPE2n1atzo8mwvAUPPLDEjvAsQ7nxb4Jab1f1FfBvnar2cL87WV5xSkxj0ofJzs0rorVKZR70W1th0U1derHcMd3UekcokDR4vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467938; c=relaxed/simple;
	bh=bUgGfIsNB725Hy1xZilGmjvF1qeD3NojIPpLDq5quAc=;
	h=Date:To:From:Subject:Message-Id; b=nDhizDcsNGXE9jI0s0l+m8z0cmeR2IfY/bRry6UuRgRpGtSqNSfjcD3POhiVJ4g5QdZPQcIFIgUgukYT8k6ga0PE0pmNcrpV7r2fqzXYGYKPo/sZCkl/sDjBc8HlsNffPmdFMG+LoOVQkamuaqc6rp78rXGZw6ASnPNjHQDK9mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PcFRwXrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcFRwXrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B19DC2BBFC;
	Sat, 11 May 2024 22:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467938;
	bh=bUgGfIsNB725Hy1xZilGmjvF1qeD3NojIPpLDq5quAc=;
	h=Date:To:From:Subject:From;
	b=PcFRwXrnqG+nI/TwZBdD8rLyawgt6DPxcDEAB7aj4LcozwXmt9H4A/Und25z2n0Km
	 3AeM1v2blNh+LjGic0XuYGZMtKgRUqpiYbj1ebvDo1jE7Q/ssJGf+wWr5VC0F5rA0Z
	 2ab9bXJXlFiBnOh5/jIbNK+FsOCwF8nc5M292iTo=
Date: Sat, 11 May 2024 15:52:17 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,gorcunov@gmail.com,ebiederm@xmission.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-kcmp-remove-unused-open-mode.patch removed from -mm tree
Message-Id: <20240511225218.2B19DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/kcmp: remove unused open mode
has been removed from the -mm tree.  Its filename was
     selftests-kcmp-remove-unused-open-mode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


