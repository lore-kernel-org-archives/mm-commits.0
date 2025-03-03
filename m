Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4228235C11
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741040673; cv=none; b=hCBIipsDlEIijbYQRf18r0L83IzXNUbDeCkRvwioIVZx6psr3ZTyfPbfAvY1KJWNHsqzIhTq6b1dYZkvDpWw/GnJ5D/qKCO5JzL41Q/7SZ6vnZbQRkFBK0xYiKi1wfr75akmansTmH36L8UzX16zS7+H4rRetcYSRC4eay4OVtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741040673; c=relaxed/simple;
	bh=tW/J5iMPSSxvlvupk+pXkHrEsjBzYXAbIfSmSwxsX2s=;
	h=Date:To:From:Subject:Message-Id; b=uE4MsLWR4cCweCnkLLrVIG0rYZ7btNt+WGV5FML+W7CPfZcwawYbmDFw7gKrH44GgfueMvAY+L60smz3BLAK2hudmlThDCgAKITTmF/B9Lro7MTMKuAKqb9v9kE19GD0UoS7H5efIoy19tySzczwkJ/TGp8ZW/HpvoMZSYJwTpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u3wLT37g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u3wLT37g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F08EC4CED6;
	Mon,  3 Mar 2025 22:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741040673;
	bh=tW/J5iMPSSxvlvupk+pXkHrEsjBzYXAbIfSmSwxsX2s=;
	h=Date:To:From:Subject:From;
	b=u3wLT37gzjYZ8pITJfiUm/dJYwQqQM+W0YfT5GzzuvbCvaIw8hDwemWcdyAgm3inX
	 TwaUteyyvb+YWyKTJHX80G8HsdOQBm06akb85fhg6fg5X+gQPpEg+s836TcRimghYe
	 JHW3k11BuOubvGxOz/lMO/+h7QjYx9OS14fCwPEo=
Date: Mon, 03 Mar 2025 14:24:32 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch added to mm-nonmm-unstable branch
Message-Id: <20250303222433.0F08EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: avoid clearing TIF_SIGPENDING in recalc_sigpending() if unset
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: signal: avoid clearing TIF_SIGPENDING in recalc_sigpending() if unset
Date: Mon, 3 Mar 2025 14:49:08 +0100

Clearing is an atomic op and the flag is not set most of the time.

When creating and destroying threads in the same process with the pthread
family, the primary bottleneck is calls to sigprocmask which take the
process-wide sighand lock.

Avoiding the atomic gives me a 2% bump in start/teardown rate at 24-core
scale.

Link: https://lkml.kernel.org/r/20250303134908.423242-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/signal.c~signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset
+++ a/kernel/signal.c
@@ -176,9 +176,10 @@ static bool recalc_sigpending_tsk(struct
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current) && !freezing(current))
-		clear_thread_flag(TIF_SIGPENDING);
-
+	if (!recalc_sigpending_tsk(current) && !freezing(current)) {
+		if (test_thread_flag(TIF_SIGPENDING))
+			clear_thread_flag(TIF_SIGPENDING);
+	}
 }
 EXPORT_SYMBOL(recalc_sigpending);
 
_

Patches currently in -mm which might be from mjguzik@gmail.com are

signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch

