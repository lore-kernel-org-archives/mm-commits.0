Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA401519A6
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976949; cv=none; b=EL2sOYgm0d9uhDntH+1h+SzEj7p572PU2iUJwp0OmyRiQCLTHDWt7SmbAd3258UTZNJFyiTOknaa95ZZnM44o4TmhvJX/3ey2drYUqfgEycXV0P+YcUPtbK28VBjf2JNVYi9Gry2mOpYsm9DUzQBhBtElT8jl2MnPpfa/uUvK4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976949; c=relaxed/simple;
	bh=wEvncUiuQ0ACprkw9b6gacLYQmqyMV0nbEtCQcM6TZk=;
	h=Date:To:From:Subject:Message-Id; b=nH60ypEIadeG7h6LLPN0WBtU571IqhYKOs6pIkJWaMJ8ugMVfSkEB7AfnlZioK1GUfalk4wWBPjdvCqp7scKPTryBX3RGi/hadSwAaUllhfEFC1XrB+qeJo7VNp/YOTc2NhfBDB9E/UQ4jY6EZ9cJCo3iW1XTxjJIquG3MzTYXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DvlpCArI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DvlpCArI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43DCC4CEE3;
	Sun, 20 Jul 2025 02:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976948;
	bh=wEvncUiuQ0ACprkw9b6gacLYQmqyMV0nbEtCQcM6TZk=;
	h=Date:To:From:Subject:From;
	b=DvlpCArIXXZMYwCDUNdQDbwcb2A17Ezn+8x65zn2qJpWGdPsjwtMjDhCNdqpYaa0n
	 MY/OkP+5dnVl8XEIBHjOfp2wDOcytGNtFGcAEP6gKb6QsnYKn0LQ0/vW2QRuR5lSMA
	 IWWaKSvEhxCpGJKYoDwA6JRkTkmyovpxixSjWzC8=
Date: Sat, 19 Jul 2025 19:02:28 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch removed from -mm tree
Message-Id: <20250720020228.A43DCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: replace deprecated strcpy() with memcpy() in alloc_name()
has been removed from the -mm tree.  Its filename was
     mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/memfd: replace deprecated strcpy() with memcpy() in alloc_name()
Date: Sat, 12 Jul 2025 19:45:17 +0200

strcpy() is deprecated; use memcpy() instead.

Not copying the NUL terminator is safe because strncpy_from_user() would
overwrite it anyway by appending uname to the destination buffer at index
MFD_NAME_PREFIX_LEN.

No functional changes intended.

Link: https://github.com/KSPP/linux/issues/88
Link: https://lkml.kernel.org/r/20250712174516.64243-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c~mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name
+++ a/mm/memfd.c
@@ -411,7 +411,7 @@ static char *alloc_name(const char __use
 	if (!name)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(name, MFD_NAME_PREFIX);
+	memcpy(name, MFD_NAME_PREFIX, MFD_NAME_PREFIX_LEN);
 	/* returned length does not include terminating zero */
 	len = strncpy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, MFD_NAME_MAX_LEN + 1);
 	if (len < 0) {
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


