Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043132FB96A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676301; cv=none; b=Q566gv4vdtlaikfwRSvRv+BlZp2XoWdsUEtOjuRQIJ1oZnaNybW6ZI2YRWroTncqDyCfFoiBWos3aeTMKP+k30X25m7AsaL7RJLDxxnNhiREQVoa+ezvgVSwQnBKhgiaD190hhPsiDn3J2+c2W26htyjDnDHj2BVDHyc7U/0uPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676301; c=relaxed/simple;
	bh=D9+lsp4E5tam5LSNxDrkHKekIyoNGE8cZu11+h/sEZo=;
	h=Date:To:From:Subject:Message-Id; b=Ht2hxBA3vq6d0vysnA2Npan2MkhmWjyzM3k1WOn3hVIVjPyxqEFwlWYSpaWE6M17yFDfsX10G6qfazWUvUZgTBDojkQgWaP/obj+xlXXVedVi7mx9wNCcjqA7VRgYeskCelF1bv9n352nlJdiBppkIy/qIJTYpU7rxbM8iv/Do8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E1yz179I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E1yz179I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87D2C4CEF1;
	Thu, 20 Nov 2025 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676300;
	bh=D9+lsp4E5tam5LSNxDrkHKekIyoNGE8cZu11+h/sEZo=;
	h=Date:To:From:Subject:From;
	b=E1yz179ImTnnFCDBFyKbvjR7lvnVbHu4hF61Ob1iOoMv/roNt3PzfulcpMXgv3+Sk
	 Hw9jd9I1PYm5t3zFbk1HX9aOy9DgZQTOVFp4mUjpS/oWGQUQt/QYsm/3aJXlg13QIi
	 cAsLEBYaL0Vq9RHrlxRSiwRRRAcyzSVuvcZn24k8=
Date: Thu, 20 Nov 2025 14:05:00 -0800
To: mm-commits@vger.kernel.org,a0979652527@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-ratelimit-fix-spelling-mistake-seperately.patch removed from -mm tree
Message-Id: <20251120220500.C87D2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: ratelimit: fix spelling mistake 'seperately'
has been removed from the -mm tree.  Its filename was
     lib-ratelimit-fix-spelling-mistake-seperately.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chia-Liang Wang <a0979652527@icloud.com>
Subject: lib: ratelimit: fix spelling mistake 'seperately'
Date: Wed, 19 Nov 2025 18:11:44 +0800

Corrects a spelling mistake in a comment in ratelimit.c where 'seperately'
was used instead of 'separately'.

Link: https://lkml.kernel.org/r/20251119101144.3175-1-a0979625527@icloud.com
Signed-off-by: Chia-Liang Wang <a0979652527@icloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ratelimit.c~lib-ratelimit-fix-spelling-mistake-seperately
+++ a/lib/ratelimit.c
@@ -27,7 +27,7 @@
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
 	/* Paired with WRITE_ONCE() in .proc_handler().
-	 * Changing two values seperately could be inconsistent
+	 * Changing two values separately could be inconsistent
 	 * and some message could be lost.  (See: net_ratelimit_state).
 	 */
 	int interval = READ_ONCE(rs->interval);
_

Patches currently in -mm which might be from a0979652527@icloud.com are


