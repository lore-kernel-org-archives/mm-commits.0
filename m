Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5311279346
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2025 22:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755211809; cv=none; b=ESWEy6ubVNtY67GgklxlWmhAmbHR3XqXd/OjORxChWIpdAcXTvunaBtitxoUJJN228ggqBvBgVcZI4qTlbZBOKq2IQnBwg905v0iHe3ZRV1/BWSHTnspuOCkWVojMM5ltaZ301SeB8XY5AVpxovnYDvt5SlZ7J7+VonwKbQbRC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755211809; c=relaxed/simple;
	bh=LyZydo3OsB2JSgZU8dfGksmD+GivjVDV0gGYKFNqWk0=;
	h=Date:To:From:Subject:Message-Id; b=GhzlkdKdpdAlkqkeggZW/6ykUx1GWX60CxyzponinMcJy2E2cyQh/oquO+f+fQuTjZbXgzh4fIDZxlmQTh0Z0WTos/eM4ihUftBs1Yb5HHbPw2cQM0Ggzg0proDR6KaOgCdvZq22dOLzoKr+gdyPWtx42yBvQp5BXUWjVKs8BTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Djl+ZLX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Djl+ZLX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09497C4CEF1;
	Thu, 14 Aug 2025 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755211809;
	bh=LyZydo3OsB2JSgZU8dfGksmD+GivjVDV0gGYKFNqWk0=;
	h=Date:To:From:Subject:From;
	b=Djl+ZLX2A14gqxgr3pNoTmyvv8QCgwKtc3bKljXeDWiPSN6w3MsYDIHD3hHQgVm57
	 CMkmnOJHac/C9BfCnQN/sieRzN/jHO85SfiDu5rTFVO1ygsCdQKNfCXEyDHDP6CrRE
	 kC/sU2Ww3Pigl+MNFwWfrNmqCzJqly3LuKtFvLJg=
Date: Thu, 14 Aug 2025 15:50:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-access_memory_even-remove-unused-header-file.patch added to mm-new branch
Message-Id: <20250814225009.09497C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/access_memory_even: remove unused header file
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-access_memory_even-remove-unused-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-access_memory_even-remove-unused-header-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Enze Li <lienze@kylinos.cn>
Subject: selftests/damon/access_memory_even: remove unused header file
Date: Thu, 14 Aug 2025 20:54:16 +0800

Since the time.h header file is not actually needed in this code, we can
safely remove its inclusion.

Link: https://lkml.kernel.org/r/20250814125417.659937-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/access_memory_even.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/damon/access_memory_even.c~selftests-damon-access_memory_even-remove-unused-header-file
+++ a/tools/testing/selftests/damon/access_memory_even.c
@@ -9,7 +9,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <time.h>
 
 int main(int argc, char *argv[])
 {
_

Patches currently in -mm which might be from lienze@kylinos.cn are

selftests-damon-access_memory_even-remove-unused-header-file.patch

