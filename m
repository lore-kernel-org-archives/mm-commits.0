Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718F1263C6A
	for <mm-commits@vger.kernel.org>; Tue,  1 Jul 2025 20:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751402910; cv=none; b=cJpOqTUyt9TJCg3HJn75kBYE6oXe4V9/bjL+H8dxYQ4DGLHm+I0eCCfL1wu2n4O0+09O/BQAdbJy26Gxu3DWmoVQbTRkixJexlYUJPenHZOktBYEM/5I1GCh+WCzYRVnBtcVEriLEXcZ4TRWw80NhVBEIrhQiHDhD7k/Y7pWtSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751402910; c=relaxed/simple;
	bh=r8Fip6KYGHCpZijeUf126EWMs1mZZz3dKIn0LR8Y7e4=;
	h=Date:To:From:Subject:Message-Id; b=SjtyzHFMR6jDkuPXU8LtFYgafKBxgxOT55kuDm1Oih8kRXUuIE59T9/siNGD179ed1MT+/3BwqNk8q8o13OmtYs2+uh8fiHCtLVKtQ/yuSsjQr0bFBG+yX9uH52VC+tkaZm7Um8tsOzZ05WKy3zHMBTr5I9M3nrKUrYUuuHmg5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h3ZLpdjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h3ZLpdjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72D8C4CEEE;
	Tue,  1 Jul 2025 20:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751402910;
	bh=r8Fip6KYGHCpZijeUf126EWMs1mZZz3dKIn0LR8Y7e4=;
	h=Date:To:From:Subject:From;
	b=h3ZLpdjA7CoYrj/jSVgI+Ivftwhr/5ngydCDfAqvgwNPzRUaesJ+8mdm/695TrkV6
	 H9XqtweBjVeg3fWRSnqJCsA0KRybhgFY0u9E4gO10mXJ1YDVHj84DvB2taxvFldi2r
	 /G+ttKeKuY48bPR5RBjGihGl6MybHg6qWEnO4utE=
Date: Tue, 01 Jul 2025 13:48:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,oleg@redhat.com,ldv@strace.io,moonhee.lee.ca@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-ptrace-add-set_syscall_info-to-gitignore.patch removed from -mm tree
Message-Id: <20250701204829.E72D8C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: ptrace: add set_syscall_info to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-ptrace-add-set_syscall_info-to-gitignore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Subject: selftests: ptrace: add set_syscall_info to .gitignore
Date: Mon, 23 Jun 2025 11:34:06 -0700

Add the set_syscall_info test binary to .gitignore to avoid tracking build
artifacts in the ptrace selftests directory.

Link: https://lkml.kernel.org/r/20250623183405.133434-2-moonhee.lee.ca@gmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ptrace/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/ptrace/.gitignore~selftests-ptrace-add-set_syscall_info-to-gitignore
+++ a/tools/testing/selftests/ptrace/.gitignore
@@ -3,3 +3,4 @@ get_syscall_info
 get_set_sud
 peeksiginfo
 vmaccess
+set_syscall_info
_

Patches currently in -mm which might be from moonhee.lee.ca@gmail.com are

selftests-mm-remove-duplicate-gitignore-entries.patch

