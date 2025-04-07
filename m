Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E685257451
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744051936; cv=none; b=tIwdePBI2TnmNFoZyJ4Bgnsq2RY+ni0B2J0CNJEOYbcW3939BJg4Aeg0uJJ/SPqkrSGKb8HY5LfVjp/ZplMImPu2EMzbKg34s0Mj+4AdwjZzf9rdBUXodZXfMGM2nzDt62rscarQE6BZlstelE20PiEeQ4T9o/hzB5NXWdxLmWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744051936; c=relaxed/simple;
	bh=k/ApKZUtTtGcpYjRJGPyxtgQIpvCj0V2GT+2Ru593+g=;
	h=Date:To:From:Subject:Message-Id; b=otDE38oTYyRD3nwu5H2oc4RaYoeBwuJTOhQdPDUp8HhG8tvuAwZr/iKNI3lXFDnUYIrJa1rH5AAeh7xqpan8mIHz2AYyHaBi3aoS0Fe1C/xTCWLmezLWnqEiYQKww1O7UR7oA/Q6H64UzrdZZCYTIktlRGyswZlWTwv0NQCkdxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYP29QVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYP29QVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87978C4CEF0;
	Mon,  7 Apr 2025 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744051935;
	bh=k/ApKZUtTtGcpYjRJGPyxtgQIpvCj0V2GT+2Ru593+g=;
	h=Date:To:From:Subject:From;
	b=dYP29QVWNlpL/i9EPJu/njpZevVdiHbUDuRYEG72LlgbR8uow45Z8frb4gOdVGyE8
	 slxK4iVNBYIGRvzmFrt/mzS6FTbGL47mVySaUBkMlTwWZRIYW1FORF+34iUqb1Ijlx
	 2KdGyxLk4HkaPcStOtXjnilP7HXInPYdHZtRyawc=
Date: Mon, 07 Apr 2025 11:52:14 -0700
To: mm-commits@vger.kernel.org,jlayton@kernel.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + errseq-eliminate-special-limitation-for-macro-max_errno.patch added to mm-nonmm-unstable branch
Message-Id: <20250407185215.87978C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: errseq: eliminate special limitation for macro MAX_ERRNO
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     errseq-eliminate-special-limitation-for-macro-max_errno.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errseq-eliminate-special-limitation-for-macro-max_errno.patch

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
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: errseq: eliminate special limitation for macro MAX_ERRNO
Date: Mon, 07 Apr 2025 19:44:16 +0800

Current errseq implementation depends on a very special precondition that
macro MAX_ERRNO must be (2^n - 1).

Eliminate the limitation by

- redefining macro ERRSEQ_SHIFT
- defining a new macro ERRNO_MASK instead of MAX_ERRNO for errno mask.

There is no plan to change the value of MAX_ERRNO, but this makes the
implementation more generic and eliminates the BUILD_BUG_ON().

Link: https://lkml.kernel.org/r/20250407-improve_errseq-v1-1-7b27cbeb8298@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/errseq.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/lib/errseq.c~errseq-eliminate-special-limitation-for-macro-max_errno
+++ a/lib/errseq.c
@@ -34,11 +34,14 @@
  */
 
 /* The low bits are designated for error code (max of MAX_ERRNO) */
-#define ERRSEQ_SHIFT		ilog2(MAX_ERRNO + 1)
+#define ERRSEQ_SHIFT		(ilog2(MAX_ERRNO) + 1)
 
 /* This bit is used as a flag to indicate whether the value has been seen */
 #define ERRSEQ_SEEN		(1 << ERRSEQ_SHIFT)
 
+/* Leverage macro ERRSEQ_SEEN to define errno mask macro here */
+#define ERRNO_MASK		(ERRSEQ_SEEN - 1)
+
 /* The lowest bit of the counter */
 #define ERRSEQ_CTR_INC		(1 << (ERRSEQ_SHIFT + 1))
 
@@ -60,8 +63,6 @@ errseq_t errseq_set(errseq_t *eseq, int
 {
 	errseq_t cur, old;
 
-	/* MAX_ERRNO must be able to serve as a mask */
-	BUILD_BUG_ON_NOT_POWER_OF_2(MAX_ERRNO + 1);
 
 	/*
 	 * Ensure the error code actually fits where we want it to go. If it
@@ -79,7 +80,7 @@ errseq_t errseq_set(errseq_t *eseq, int
 		errseq_t new;
 
 		/* Clear out error bits and set new error */
-		new = (old & ~(MAX_ERRNO|ERRSEQ_SEEN)) | -err;
+		new = (old & ~(ERRNO_MASK | ERRSEQ_SEEN)) | -err;
 
 		/* Only increment if someone has looked at it */
 		if (old & ERRSEQ_SEEN)
@@ -148,7 +149,7 @@ int errseq_check(errseq_t *eseq, errseq_
 
 	if (likely(cur == since))
 		return 0;
-	return -(cur & MAX_ERRNO);
+	return -(cur & ERRNO_MASK);
 }
 EXPORT_SYMBOL(errseq_check);
 
@@ -200,7 +201,7 @@ int errseq_check_and_advance(errseq_t *e
 		if (new != old)
 			cmpxchg(eseq, old, new);
 		*since = new;
-		err = -(new & MAX_ERRNO);
+		err = -(new & ERRNO_MASK);
 	}
 	return err;
 }
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are

errseq-eliminate-special-limitation-for-macro-max_errno.patch

