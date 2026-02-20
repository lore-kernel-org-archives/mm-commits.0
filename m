Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4882C21DD
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 02:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771556152; cv=none; b=Hv3qDo7Fp9iWJxvJvU93/mKTV+G3lSFlM3QIFZukZ21vt1cu3dX2RR9f6F/jGPNDvpeZKrYUkNu2oKnStuGmH/KcthfTNv1cJRSf2E5QcD+haEI3pS+5gfZpLfiOisRZaWThEyAok0MaY7BtgK2cXN9Vq3QMlpYSvvKZ05jxku4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771556152; c=relaxed/simple;
	bh=eRmDDn+sYawZS+S0fnL8J5E1BFiNBzxphholnbwjBbA=;
	h=Date:To:From:Subject:Message-Id; b=ABcD5YA2eP3/5reVX+cOwemNlzFyFIl8wD10V9BlKFpzpjz2KU7wDGbkqfD4rU5FUcqk2Ap8VXvV5grqXz46M+Fp8T0ewzVPTJTcegGqTM1LwtK0cl2mtC/y1BIOH7dsQ//+q33fhqLUJ2SRa97UIuMuAEHcGwMlgySWNS8mdsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duBNBRcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duBNBRcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B224CC4CEF7;
	Fri, 20 Feb 2026 02:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771556151;
	bh=eRmDDn+sYawZS+S0fnL8J5E1BFiNBzxphholnbwjBbA=;
	h=Date:To:From:Subject:From;
	b=duBNBRcJEHhNruvDRPudDGo76qI2dYVqD4DucQwrw40gOadgdcquUXd6XNnpW14Fx
	 kmbxh6ze2iq3D5r2fljH+gCxiHcNSlXE2+5YjaJxIpkheJIcEHhtZvBwi+x9QKIueU
	 0rLQ2tgIkciruRsa01c94xKfUi5pZojKUzEBMwUU=
Date: Thu, 19 Feb 2026 18:55:51 -0800
To: mm-commits@vger.kernel.org,gnoack3000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-bindedbound.patch added to mm-nonmm-unstable branch
Message-Id: <20260220025551.B224CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: Add "binded||bound"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-bindedbound.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-bindedbound.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Günther Noack <gnoack3000@gmail.com>
Subject: scripts/spelling.txt: Add "binded||bound"
Date: Sat, 14 Feb 2026 15:08:54 +0100

The correct passive of "to bind" is "bound", not "binded".  This is often
used in the context of the BSD socket bind(2) operation.

Link: https://lkml.kernel.org/r/20260214140854.42247-1-gnoack3000@gmail.com
Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-bindedbound
+++ a/scripts/spelling.txt
@@ -257,6 +257,7 @@ begining||beginning
 beter||better
 betweeen||between
 bianries||binaries
+binded||bound
 bitmast||bitmask
 bitwiedh||bitwidth
 boardcast||broadcast
_

Patches currently in -mm which might be from gnoack3000@gmail.com are

scripts-spellingtxt-add-bindedbound.patch

