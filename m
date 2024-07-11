Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BBE18732F
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 19:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720726792; cv=none; b=CA8qWRmo1v8EsrQdWaN877MMmiycBbvWXfVaGD22smAngKiETaxiwbNpsBLlXgMCGXUBIL8uUyAiNP3VeGIB9EEDdpVq8139eyI8lGLzSyJ2pUc2gO1oGfj0DffVYZmImbd8dX8eYbHkZCB+3qkHn77N7TIU9VEYpAiPFd0uKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720726792; c=relaxed/simple;
	bh=lnHZZGbt7LXpvy3GIpmkvNlZnGKk7kBGHxKKpw5LIaM=;
	h=Date:To:From:Subject:Message-Id; b=Wyrie2Bkt1vg95VunD7TBKy4D6SXGe5jYBZcW7AXHr9028LcvNfzy7xc1CawxQp8Sbcya6wcbECGK99AFVa6jlouzXUfOf43Ba54oHGAZBQC45u2RyfyI2W+Qxc5lMTL6FxJ+6qo3e31huN0UPkFYRTTs7fHxyRixqgxqDyvbuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b+DqiKWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+DqiKWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F86C116B1;
	Thu, 11 Jul 2024 19:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720726792;
	bh=lnHZZGbt7LXpvy3GIpmkvNlZnGKk7kBGHxKKpw5LIaM=;
	h=Date:To:From:Subject:From;
	b=b+DqiKWyLRPS1c7X5bidHozpFWbZVkZnDKhx2f30k/eW5LsUrLlADacbeYoHHlNJy
	 X7WQdnPy5HQwYA0vIlgJ6Oyf7PPkzUmP16Rcf25X6CVlEKeO21AkHll3h5NU6RycEk
	 EmlqMbuCs2mCh6UHgk4cOMHiIeParKLY/MLfVP64=
Date: Thu, 11 Jul 2024 12:39:51 -0700
To: mm-commits@vger.kernel.org,thomas.orgis@uni-hamburg.de,liupeng256@huawei.com,ismael@iodev.co.uk,ebiederm@xmission.com,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tsacct-replace-strncpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20240711193951.E9F86C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tsacct: replace strncpy() with strscpy()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tsacct-replace-strncpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tsacct-replace-strncpy-with-strscpy.patch

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
From: Kees Cook <kees@kernel.org>
Subject: tsacct: replace strncpy() with strscpy()
Date: Thu, 11 Jul 2024 10:13:09 -0700

Replace the deprecated[1] use of strncpy() in bacct_add_tsk().  Since this
is UAPI, include trailing padding in the copy.

Link: https://github.com/KSPP/linux/issues/90 [1]
Link: https://lkml.kernel.org/r/20240711171308.work.995-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ismael Luceno <ismael@iodev.co.uk>
Cc: Peng Liu <liupeng256@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/tsacct.c~tsacct-replace-strncpy-with-strscpy
+++ a/kernel/tsacct.c
@@ -76,7 +76,7 @@ void bacct_add_tsk(struct user_namespace
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	strscpy_pad(stats->ac_comm, tsk->comm);
 }
 
 
_

Patches currently in -mm which might be from kees@kernel.org are

tsacct-replace-strncpy-with-strscpy.patch

