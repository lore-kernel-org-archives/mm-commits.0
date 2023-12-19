Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0373639AEA
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYllkndr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CDBC433C7;
	Tue, 19 Dec 2023 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019550;
	bh=4Pe/eYotuo+ktk/fuCEDH0xuO0GqXYjUoTNh5v8WxNw=;
	h=Date:To:From:Subject:From;
	b=fYllkndrOcAUIdnxLRur1L4aduuMM52MCkRYEz/JAYCWqN+wPuEFgdmsOPi8udDqE
	 WQ17TGvXInAHArNUAJj2WSoK8mM0Gqaawjb+zWLwXcryG7fTNSgFGSAv+Ul+GjY4MS
	 FWeNWUJ+hp1UNPqavVL2Iey/qfQSeD4PlNKHcgDI=
Date: Tue, 19 Dec 2023 12:59:09 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkstackpl-change-min_stack-to-512-by-default.patch added to mm-nonmm-unstable branch
Message-Id: <20231219205910.59CDBC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/checkstack.pl: change min_stack to 512 by default
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkstackpl-change-min_stack-to-512-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkstackpl-change-min_stack-to-512-by-default.patch

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
Subject: scripts/checkstack.pl: change min_stack to 512 by default
Date: Tue, 19 Dec 2023 20:50:00 +0800

According to Documentation/process/submit-checklist.rst, checkstack does
not point out problems explicitly, but any one function that uses more
than 512 bytes on the stack is a candidate for change, hence it is better
to omit any stack frame sizes smaller than 512 bytes, just change
min_stack to 512 by default.

Link: https://lkml.kernel.org/r/20231219125008.23007-5-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-change-min_stack-to-512-by-default
+++ a/scripts/checkstack.pl
@@ -47,7 +47,7 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 
 	$min_stack = shift;
 	if ($min_stack eq "" || $min_stack !~ /^\d+$/) {
-		$min_stack = 100;
+		$min_stack = 512;
 	}
 
 	$x	= "[0-9a-f]";	# hex character
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

scripts-checkstackpl-remove-ia64-support.patch
scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch
scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch
scripts-checkstackpl-change-min_stack-to-512-by-default.patch
docs-submit-checklist-remove-all-of-make-namespacecheck.patch

