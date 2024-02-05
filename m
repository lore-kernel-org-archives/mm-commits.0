Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31214B5DD
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175225; cv=none; b=A9hb6yejZ5WmPWO0jyOBuTxlsDhBVHABny3lJU+hBIpDtX1T8Qv/Ylca4Z87uON8veA93cj29v6uKRtyqzUBxOkxwZz245LYTRaXWdMTUu5qD5cLN95rNf4xdPR6Gm21sSPmCEGa2gA9gI7wZJduEBnasX5K2cxnSAPAZpSxWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175225; c=relaxed/simple;
	bh=7HIshANhw6f5iksrjfd9J8MlZ+fakYY/pXWnTKLsay0=;
	h=Date:To:From:Subject:Message-Id; b=mH+rTfbBxTmIQWthJSH74TM79pqdcgb+DTJ+58NaJ5gMArH3KJMTGPyhW60oKdY+GKz+WUKvUWfOi9XrY2aOe4W6eEj7hWZP31XthWifK5OgiZjpcUIUj5rHXaWtTbifnbUN/u8KF5CP2zshBoO2Jn2vifUBRvYkMTD2CJzh0XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwvzsETQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwvzsETQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F046BC433F1;
	Mon,  5 Feb 2024 23:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175225;
	bh=7HIshANhw6f5iksrjfd9J8MlZ+fakYY/pXWnTKLsay0=;
	h=Date:To:From:Subject:From;
	b=qwvzsETQc4Vmx+EuMypsb5KbbGFhDBylFnztrQnGiaH/G22/sE2WDdrKsFy5yXDMQ
	 ReLLbafGo83m+JFGe/mYUrn896hUZEatrn/J5YnUuzr1T/aoRySg9+FtDESMEyBMRr
	 EmuvE43Ybq8iZ7As7kqF6bOIruH0bcE/MLip1Q6I=
Date: Mon, 05 Feb 2024 15:20:24 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch removed from -mm tree
Message-Id: <20240205232024.F046BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: avoid wrap-around instrumentation in copy_compat_iovec_from_user()
has been removed from the -mm tree.  Its filename was
     iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

ubsan-reintroduce-signed-overflow-sanitizer.patch

