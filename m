Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B36156223
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712174372; cv=none; b=TwebgL6rumD+oWOJ1GghE0D0HUSxelpko4qpXGZMt4ItHVE671lizJ0Ie5MfRNa4CLREzK1IR1qvtmCGLaa1UKIGkn87Tg4BiGQweygwjTVBknxJ2z5ZnrX3nR3wogeE3t0xeOjOfHZtPQQgMu1NOZr4HcHGocpDcqqzv82DYtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712174372; c=relaxed/simple;
	bh=DHFvxHnE+YFfbtwv71e/9XDmtcmGpSAfTsO2YYpNPFg=;
	h=Date:To:From:Subject:Message-Id; b=iOvwvO5JSHKooFgGuetdWwQfLDk45in0xFeTHxtv5LRZzHFNbUaHyeXg0gBcathGz/5Lgw+0Qxy3STTJ4SGIjpkc6Hykq0fjdmjcrcDl+Xya+Nq1BMZsQXc3i1QUkBoxeSr+WmEReMxO8E5ctnoGr0UzF0ym9XDoA0f0vWAUoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=shCklVyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="shCklVyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7506C433F1;
	Wed,  3 Apr 2024 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712174372;
	bh=DHFvxHnE+YFfbtwv71e/9XDmtcmGpSAfTsO2YYpNPFg=;
	h=Date:To:From:Subject:From;
	b=shCklVyb0LTnPVgH8bxk+lZG323erroOGxGPETv7t6bGfYsRbGzoB9OrBcncAv2PO
	 IO0ds2WHIaTJMIDGer5cxZGDQlYmFaYw2zPblAcSZQfdUrDejlqRLk+fiVdpmAPYzl
	 7iHY7C4vs37nlNS0uFwm9T6ZP51B4SASO+F+CZls=
Date: Wed, 03 Apr 2024 12:59:31 -0700
To: mm-commits@vger.kernel.org,arnd@kernel.org,schnelle@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kgdb-add-has_ioport-dependency.patch added to mm-nonmm-unstable branch
Message-Id: <20240403195931.E7506C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kgdb: add HAS_IOPORT dependency
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kgdb-add-has_ioport-dependency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kgdb-add-has_ioport-dependency.patch

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
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: kgdb: add HAS_IOPORT dependency
Date: Wed, 3 Apr 2024 15:25:47 +0200

In a future patch HAS_IOPORT=n will disable inb()/outb() and friends at
compile time.  We thus need to add HAS_IOPORT as dependency for those
drivers using them.

Link: https://lkml.kernel.org/r/20240403132547.762429-2-schnelle@linux.ibm.com
Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kgdb |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.kgdb~kgdb-add-has_ioport-dependency
+++ a/lib/Kconfig.kgdb
@@ -122,6 +122,7 @@ config KDB_DEFAULT_ENABLE
 config KDB_KEYBOARD
 	bool "KGDB_KDB: keyboard as input device"
 	depends on VT && KGDB_KDB && !PARISC
+	depends on HAS_IOPORT
 	default n
 	help
 	  KDB can use a PS/2 type keyboard for an input device
_

Patches currently in -mm which might be from schnelle@linux.ibm.com are

kgdb-add-has_ioport-dependency.patch

