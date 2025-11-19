Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E479258EFC
	for <mm-commits@vger.kernel.org>; Wed, 19 Nov 2025 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592991; cv=none; b=L/cMVeYjyb91IqcinkcMJFis9hWEhI1r2VyeBjl2bA3ELfYlsrE8QU2OeRdv9sCCJGTXByjV69R+WiTMz5aoZvdHenFoeCnZo3T24F70PMIzmbjuBNwiAFbgJyAJIv5BDuM+nT7D6K/6jGYIEwtRKLLP7yhxQa9fz4NQLWRbqXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592991; c=relaxed/simple;
	bh=VfmhfHKRdwM4X0MswOCC8wTgoj2LV2K4yY5LNx8nwSE=;
	h=Date:To:From:Subject:Message-Id; b=u9OHd6kOUQUO9ngmiqL2DjzfM1bTtldYKbSyLQmbO3wJuehRCuKoHXblGaOwquPmjRnN5t0uVn9DGwoT2yVNy0oSclv/QnX75TTkJOY9SSRpb37CdlFtU/hsJEPo8Bd9HRpsJNhmHE97yNJ9DkKSASeVzD9XAoeIATov8eXsvoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXKXsQX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXKXsQX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08768C4CEF5;
	Wed, 19 Nov 2025 22:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763592991;
	bh=VfmhfHKRdwM4X0MswOCC8wTgoj2LV2K4yY5LNx8nwSE=;
	h=Date:To:From:Subject:From;
	b=IXKXsQX5KURWpSwPxvEsQhJw8VwUNcVLsuyWce+jsJoWo9KIn7vipQcOCz9I3r1VV
	 vDnyYcdw+F2E3/h+tP1NDiTzGBKY1Ga0Vy65MVmY4jsxtfQLdX3J1J/IOYVKKOtxbr
	 /IrE/6pCdGt7hdbQehO6jwvGP5etvDi/s+arfFBs=
Date: Wed, 19 Nov 2025 14:56:30 -0800
To: mm-commits@vger.kernel.org,a0979652527@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ratelimit-fix-spelling-mistake-seperately.patch added to mm-nonmm-unstable branch
Message-Id: <20251119225631.08768C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: ratelimit: fix spelling mistake 'seperately'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ratelimit-fix-spelling-mistake-seperately.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ratelimit-fix-spelling-mistake-seperately.patch

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

lib-ratelimit-fix-spelling-mistake-seperately.patch

