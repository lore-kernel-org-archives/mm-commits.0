Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33778B67F
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959808; cv=none; b=EflQis8LGQzHoMDU+rHkM177JldF5mid7Vm/JBNcgH5q9mKTz0VboSlDzliZwVo+b184mrwg0FsGIFldY5y+1+8FP/zevTxjIQtGnpx8eIJ9ezazsjkGxD1y+sOMq88zzy0xhZHOky+wInQm8N7fd413s0LMm/YU4zlQ9E+pEt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959808; c=relaxed/simple;
	bh=vC1IZVoYuktgPMQPQNmw1/cHSS3rRibbilMzBfQNwFA=;
	h=Date:To:From:Subject:Message-Id; b=WcqA7G/B/UThdmNN+///+ooztxA4fiHImDeOPuKN+1ZzzCQ4dDZOgDL9xrNl7UygjlLgC9mCB3O/XSHlztutxHyecEHM4frJ48QJa/uA4QZDZDz2TM4m+N4GcyEkzAp9K7u00tSDtKj3lG17Ej8JJLCL6krvPKU+S1LphbrIR28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5/JVJtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5/JVJtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DB2C4CEF4;
	Tue, 12 Aug 2025 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959808;
	bh=vC1IZVoYuktgPMQPQNmw1/cHSS3rRibbilMzBfQNwFA=;
	h=Date:To:From:Subject:From;
	b=G5/JVJtM1CWQ/6R513jdotblEqVK4aBOsyxoP0HAN3bYjtM2KD3v19GG6Cs79K8yl
	 Q98VPyVockgM0NetfiICrAGSb/kxMfRsZ8AhqYuwQ8v17Lq63P7d1Eb9jJrmKI2ErQ
	 LUA20k+ah1WjUBEWWv3vWqXl6KH+PfqQQIeQmV1c=
Date: Mon, 11 Aug 2025 17:50:07 -0700
To: mm-commits@vger.kernel.org,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-digsig-remove-unnecessary-memset.patch added to mm-nonmm-unstable branch
Message-Id: <20250812005008.00DB2C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/digsig: remove unnecessary memset
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-digsig-remove-unnecessary-memset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-digsig-remove-unnecessary-memset.patch

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
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: lib/digsig: remove unnecessary memset
Date: Mon, 11 Aug 2025 16:27:38 +0800

kzalloc() has already been initialized to full 0 space, there is no need
to use memset() to initialize again.

Link: https://lkml.kernel.org/r/20250811082739.378284-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/digsig.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/digsig.c~lib-digsig-remove-unnecessary-memset
+++ a/lib/digsig.c
@@ -159,7 +159,6 @@ static int digsig_verify_rsa(struct key
 
 	len = mlen;
 	head = len - l;
-	memset(out1, 0, head);
 	memcpy(out1 + head, p, l);
 
 	kfree(p);
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are

lib-digsig-remove-unnecessary-memset.patch

