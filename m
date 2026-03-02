Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8525282F05
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495742; cv=none; b=DpTUR3ch8w+YTsH5KZaY96TqKXTwmYUAgBu9/vAyKg83hi5xHeYi3scIL8B5Cx/Fjuze8tJl6lzc+uHu5zdGzpwxc4b8jWCI7rGMa2Fkqsz4jRnIz4QWPyPVuQ/UiNW43o8EJ5cFrj1BjwFlPqicoUT4DVLYPYb2KFNUD8nG9h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495742; c=relaxed/simple;
	bh=UQLnVfXUT3RF0U2HMl1uaKpUhMEPzs9sPMkAGwZFw5w=;
	h=Date:To:From:Subject:Message-Id; b=XRYusph0t/0LtW6bLPvsE5SOYkTfHyyzG6qnecppLq4FaI6xq22fMc+E+yw2O4wlK2hQYr66sxTY+sQUg7Ds+MkywSvvfMWU/kF4EY7E1+3VQKrnSAbcSn5dhP7zBQqGmCM17IckDicQ0mJGbw1iIfwKTdedOPid5b1fkCnq2ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/NxQ61s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/NxQ61s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E59C19423;
	Mon,  2 Mar 2026 23:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772495742;
	bh=UQLnVfXUT3RF0U2HMl1uaKpUhMEPzs9sPMkAGwZFw5w=;
	h=Date:To:From:Subject:From;
	b=o/NxQ61surXCj/FfqQb25WiYRnOwDF94RxStfxqApkPFF2sS6I+SSp9zhrzcSbKej
	 N6bu3oguI5Y5xz6TqW8ojieC6eaf4jGdGvHW1wqyEbyWAv/umbTfHUvS8lgSrL6mUT
	 HIItfN4d5UTm4xNyGFL2pHTD+Zd8bUSvbhmqmfN8=
Date: Mon, 02 Mar 2026 15:55:41 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + build_bugh-correct-function-parameters-names-in-kernel-doc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260302235542.70E59C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: build_bug.h: correct function parameters names in kernel-doc
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     build_bugh-correct-function-parameters-names-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/build_bugh-correct-function-parameters-names-in-kernel-doc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: build_bug.h: correct function parameters names in kernel-doc
Date: Sun, 1 Mar 2026 16:51:44 -0800

Use the correct function (or macro) names to avoid kernel-doc warnings:

Warning: include/linux/build_bug.h:38 function parameter 'cond' not
 described in 'BUILD_BUG_ON_MSG'
Warning: include/linux/build_bug.h:38 function parameter 'msg' not
 described in 'BUILD_BUG_ON_MSG'
Warning: include/linux/build_bug.h:76 function parameter 'expr' not
 described in 'static_assert'

Link: https://lkml.kernel.org/r/20260302005144.3467019-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/build_bug.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/build_bug.h~build_bugh-correct-function-parameters-names-in-kernel-doc
+++ a/include/linux/build_bug.h
@@ -32,7 +32,8 @@
 /**
  * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
  *		      error message.
- * @condition: the condition which the compiler should know is false.
+ * @cond: the condition which the compiler should know is false.
+ * @msg: build-time error message
  *
  * See BUILD_BUG_ON for description.
  */
@@ -60,6 +61,7 @@
 
 /**
  * static_assert - check integer constant expression at build time
+ * @expr: expression to be checked
  *
  * static_assert() is a wrapper for the C11 _Static_assert, with a
  * little macro magic to make the message optional (defaulting to the
_

Patches currently in -mm which might be from rdunlap@infradead.org are

uaccess-correct-kernel-doc-parameter-format.patch
mm-mmu_notifier-clean-up-mmu_notifierh-kernel-doc.patch
build_bugh-correct-function-parameters-names-in-kernel-doc.patch

