Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85001378
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 02:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708742289; cv=none; b=lc9fVIGWqCGKYGAkyu1WSnIWpNCpJhzG0G5bVjT04XqowAufoRjEVb0YicNmhlHtzmS2jn1DOLptNgOXAmc67uWEYl/EmlsIZXyAPwbLQ2EzaUGncn9h64LPrq/U+uLLXAJZFb+Gv4E84Q5AKH7h4XHU9AIld8t5cjajn1fZi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708742289; c=relaxed/simple;
	bh=OMauyuGS75WA5ijh+3NRuLfYNAX9F2dS7rMvBpYdh2M=;
	h=Date:To:From:Subject:Message-Id; b=nR6SvpM0Yu2d9TVz6P7cd47hRMOb2bM/VQ/BzkFZzeGp918F7V/cRxO17ohYpc5+IznjgHhzAfYFPXwACSfw7iKhsZ2YJtAMR8rgoY0B5R4goo2UgKnH6tGnDbSHwbVR6wjbEVNcBJ6VB7m3024eoEWWVAWZiSnjhcJoKvAHpl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sl3rMVzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sl3rMVzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE83C433F1;
	Sat, 24 Feb 2024 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708742289;
	bh=OMauyuGS75WA5ijh+3NRuLfYNAX9F2dS7rMvBpYdh2M=;
	h=Date:To:From:Subject:From;
	b=sl3rMVzU+SRUQqCzbEF3ZJKH6yvpuWODAj2Kef/L8Le8p2uRTdJT8+CF9hPS+paUv
	 zqdtWFH/oReQV6VuhHOZu8yEt4KQ9xSp1qwSydd3RmMHWAZUvUz77Tz6slyEoG+kid
	 YuIm5pHNxFVKcHAfRR64PlHpH0KD7Y+83NyqqDEY=
Date: Fri, 23 Feb 2024 18:38:08 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-add-kfifo_out_linear_ptr-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240224023809.1FE83C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo-add-kfifo_out_linear_ptr-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-add-kfifo_out_linear_ptr-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-add-kfifo_out_linear_ptr-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kfifo-add-kfifo_out_linear_ptr-fix
Date: Fri Feb 23 06:28:24 PM PST 2024

fix mismatched parenthesis build error

Cc: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/kfifo.c~kfifo-add-kfifo_out_linear_ptr-fix
+++ a/lib/kfifo.c
@@ -497,7 +497,7 @@ unsigned int __kfifo_out_linear_r(struct
 	if (tail)
 		*tail = fifo->out + recsize;
 
-	return min(n, __kfifo_peek_n(fifo, recsize);
+	return min(n, __kfifo_peek_n(fifo, recsize));
 }
 EXPORT_SYMBOL(__kfifo_out_linear_r);
 
@@ -609,4 +609,3 @@ unsigned int __kfifo_dma_out_prepare_r(s
 	return setup_sgl(fifo, sgl, nents, len, fifo->out + recsize);
 }
 EXPORT_SYMBOL(__kfifo_dma_out_prepare_r);
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch
kfifo-add-kfifo_out_linear_ptr-fix.patch

