Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7D539AEA
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NZHC8n2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160D4C433C8;
	Tue, 19 Dec 2023 20:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019547;
	bh=nGofkYiX1j+obUACbyXI+gSr0vLpRR89UpBFYnDYGzg=;
	h=Date:To:From:Subject:From;
	b=NZHC8n2XMnuuWKp7/pjdaUqvYoagUCRP5GXHrZn3Ddkf17nIxLxRWQVmKB2p5CmCz
	 WvkChPV0iWpKvhUKajn00YoCGBV++zRs3VshX7EDLLbQBCOnVLGh7BB8yGeeR1VW7n
	 rAdl17IEJjCnT94gyiBvVMY7WStgZMEXx6jWZ1IU=
Date: Tue, 19 Dec 2023 12:59:06 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20231219205907.160D4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/checkstack.pl: add min_stack to the usage comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch

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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: scripts/checkstack.pl: add min_stack to the usage comment
Date: Tue, 19 Dec 2023 20:49:58 +0800

After commit 572220aad525 ("scripts/checkstack.pl: Add argument to print
stacks greather than value."), it is appropriate to add min_stack to the
usage comment, then the users know explicitly that "min_stack" can be
specified like "arch".

Link: https://lkml.kernel.org/r/20231219125008.23007-3-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-add-min_stack-to-the-usage-comment
+++ a/scripts/checkstack.pl
@@ -18,7 +18,7 @@
 #	loongarch port by Youling Tang <tangyouling@kylinos.cn>
 #
 #	Usage:
-#	objdump -d vmlinux | scripts/checkstack.pl [arch]
+#	objdump -d vmlinux | scripts/checkstack.pl [arch] [min_stack]
 #
 #	TODO :	Port to all architectures (one regex per arch)
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

scripts-checkstackpl-remove-ia64-support.patch
scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch
scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch
scripts-checkstackpl-change-min_stack-to-512-by-default.patch
docs-submit-checklist-remove-all-of-make-namespacecheck.patch

