Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25056772F
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 09:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706693273; cv=none; b=aXx6G2is6w5x4JUtOLCBlqPh/YaDpI50C5gmf/DuaC6kdYw3gNc+436FzeoIiEr8MLz++CXfhkcvKal38ehefUdfXliXEphBGKEqu/X+JYrOi5eqMJVypeUoCC0YQnzlMqAaJ88Xz8Fc6rXlesPylV91T5Yj0ero9HsaBgckTss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706693273; c=relaxed/simple;
	bh=a32YEGvTfMpETTUNxWDMgehLJtr+x6gmXB3QIYCt7j8=;
	h=Date:To:From:Subject:Message-Id; b=FNzn0ER3cxD74rB286YRhQktgPKuMOlmkIFEjabePSXOJmZ3H0m/kc6m91QyfX0Eq5f2WAXmi8UWhxj0GNC3CU4gSNUcjxhWAGEakE3vEGwSMGFlMR+lzDl1C9uACO3+jIeeqqBxzNZEm3Ypuu+uDtkOy2fqT6U5If92xxaEGqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xrMseRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xrMseRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C56C433C7;
	Wed, 31 Jan 2024 09:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706693273;
	bh=a32YEGvTfMpETTUNxWDMgehLJtr+x6gmXB3QIYCt7j8=;
	h=Date:To:From:Subject:From;
	b=1xrMseRrEsVoS1AfypdG1x0mBFz/27KQDXWxu0YLOXW2b2DJxA4Xndz7LgIffLH7E
	 iEDMFFflbHL5trfcPzhNilK5XPCwH0qzMYT2+ikdcQaXMi9iHOGNOWIfsEa5t9hqtJ
	 BjUB6UHMr6sSuh8mgx844KHZezNsoZPsLGSSeDjk=
Date: Wed, 31 Jan 2024 01:27:38 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch added to mm-nonmm-unstable branch
Message-Id: <20240131092752.16C56C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: avoid wrap-around instrumentation in copy_compat_iovec_from_user()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: iov_iter: avoid wrap-around instrumentation in copy_compat_iovec_from_user()
Date: Mon, 29 Jan 2024 10:37:29 -0800

The loop counter "i" in copy_compat_iovec_from_user() is an int, but
because the nr_segs argument is unsigned long, the signed overflow
sanitizer got worried "i" could wrap around.  Instead of making "i" an
unsigned long (which may enlarge the type size), switch both nr_segs and i
to u32.  There is no truncation with nr_segs since it is never larger than
UIO_MAXIOV anyway.  This keeps sanitizer instrumentation[1] out of a
UACCESS path:

vmlinux.o: warning: objtool: copy_compat_iovec_from_user+0xa9: call to __ubsan_handle_add_overflow() with UACCESS enabled

Link: https://github.com/KSPP/linux/issues/26 [1]
Link: https://lkml.kernel.org/r/20240129183729.work.991-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c~iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user
+++ a/lib/iov_iter.c
@@ -1166,11 +1166,12 @@ const void *dup_iter(struct iov_iter *ne
 EXPORT_SYMBOL(dup_iter);
 
 static __noclone int copy_compat_iovec_from_user(struct iovec *iov,
-		const struct iovec __user *uvec, unsigned long nr_segs)
+		const struct iovec __user *uvec, u32 nr_segs)
 {
 	const struct compat_iovec __user *uiov =
 		(const struct compat_iovec __user *)uvec;
-	int ret = -EFAULT, i;
+	int ret = -EFAULT;
+	u32 i;
 
 	if (!user_access_begin(uiov, nr_segs * sizeof(*uiov)))
 		return -EFAULT;
_

Patches currently in -mm which might be from keescook@chromium.org are

iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch

