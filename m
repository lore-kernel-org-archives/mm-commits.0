Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9073D978
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939159; cv=none; b=k2Iql7vTbrmNe4mNv0CxLZt/BCy0fc6YbveluSOG9DJgeR17UIIddLD2fIYoN+7ZKG9bIZvsKEJTkq5n0SKCMGmCSt8bzJVLhiF8UULq2Ds9IzRBcXo8P+z11stLy0nJT2ewu4dPUHM2S4qL51LQe9QaGGeyWquLL0XsJEXnpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939159; c=relaxed/simple;
	bh=K0s6xucHWfcLHI/hqVxCcz9Xn2RDW+nIPAMywB+TxeE=;
	h=Date:To:From:Subject:Message-Id; b=ro/tte7jHqIAvDr5FGJ+6MNi6X1rF72MN2Y/Ai5iwrhzo79Q/bmjX+MuchUXseITUTlAMrJWEiRsByYoNjGFal8NuiVCVwbAyTK5Zt4oFXb9Tj8YaAMHxll9EJlhInioWfjX/6LTr8pLUAP1I1Ja6FRqoUs5lg4ceoPueNx56NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xjy7kfUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xjy7kfUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F6C116B1;
	Tue,  2 Jul 2024 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719939159;
	bh=K0s6xucHWfcLHI/hqVxCcz9Xn2RDW+nIPAMywB+TxeE=;
	h=Date:To:From:Subject:From;
	b=xjy7kfUsu3Jq3oV2tJfs8KCxhqlr6FTys7l8mkZmFMo1R5TovtDq5CXMnAy0q4JfE
	 Ag+Dr0VsKtFEtFZcRu9BRwPGVA3dOb9mKNxgG2lxYd9DqVQL5mRPDOpcNvc/0ZWPdP
	 I9rTLtFdrAZ4ZVzCUIaint1cqP1KqG4X3HEbYbko=
Date: Tue, 02 Jul 2024 09:52:38 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,swarupkotikalapudi@gmail.com,shuah@kernel.org,luto@kernel.org,kees@kernel.org,amer.shanawany@gmail.com,make24@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to.patch removed from -mm tree
Message-Id: <20240702165239.323F6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/capabilities: fix possible file leak in copy_fromat_to
has been removed from the -mm tree.  Its filename was
     selftests-capabilities-fix-possible-file-leak-in-copy_fromat_to.patch

This patch was dropped because it was nacked

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
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Amer Al Shanawany <amer.shanawany@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <kees@kernel.org>
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


