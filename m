Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288FD1DDEA
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 00:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755248; cv=none; b=lKgGdIMhI48gQl7XO3JJdRQ5l/7o0A+sJj9sdgpaKv9s5HN3MmQySrU2+u+x0SOio8J8enOWy4TljFvMys+asRL/lEvJ7KcpXq3YaO/Kxm3p6dWbYzIa7dngSi8r5k/k6eJ3WYWjgvhUpUxQOve90teEeQJ+waERkhUzW5fKa2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755248; c=relaxed/simple;
	bh=jlAbvladaNaWusIMtHx/WH89v6ssNps/fXLfWAx/kjw=;
	h=Date:To:From:Subject:Message-Id; b=jWWkDNGOReNFa2DDI/ISSFvTE+M+MmKMqYQCmt59IcCZ24R/MqvfaN3i3Kr9a5HXBUjkT8FFfPxxNYH7mARFG925beeHzix4h+5y49j4lBupb5hf/5kjA0DjYFzUL13c1/E4LRUJGZ3LE1minrhNTqEhinnaJUt2k7Zi5fAf6K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIpBHbzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIpBHbzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93228C4CECC;
	Thu, 28 Nov 2024 00:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755247;
	bh=jlAbvladaNaWusIMtHx/WH89v6ssNps/fXLfWAx/kjw=;
	h=Date:To:From:Subject:From;
	b=qIpBHbzpiRKQfZVn+upJiYMVTD/ezVBA3y9RPGBZSkG6NigpgER76O7mNAjwRVs1w
	 RhrTNjtNRbBIOpPdbLYRicZPfzUvmiuSr00D5KSx12wPKXaHkK0zYKHEmPQEwp1D2M
	 JbWP+hR77tPCqcsj9z/J9lryZ5r5M0q0cIasoIWE=
Date: Wed, 27 Nov 2024 16:54:06 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,richard.henderson@linaro.org,pasha.tatashin@soleen.com,mattst88@gmail.com,kent.overstreet@linux.dev,arnd@arndb.de,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alpha-remove-duplicate-included-header-file.patch added to mm-nonmm-unstable branch
Message-Id: <20241128005407.93228C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alpha: remove duplicate included header file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     alpha-remove-duplicate-included-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alpha-remove-duplicate-included-header-file.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: alpha: remove duplicate included header file
Date: Tue, 26 Nov 2024 12:47:26 +0100

Remove duplicate included header file asm/fpu.h

Link: https://lkml.kernel.org/r/20241126114728.139029-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/fpreg.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/alpha/lib/fpreg.c~alpha-remove-duplicate-included-header-file
+++ a/arch/alpha/lib/fpreg.c
@@ -10,7 +10,6 @@
 #include <linux/preempt.h>
 #include <asm/fpu.h>
 #include <asm/thread_info.h>
-#include <asm/fpu.h>
 
 #if defined(CONFIG_ALPHA_EV6) || defined(CONFIG_ALPHA_EV67)
 #define STT(reg,val)  asm volatile ("ftoit $f"#reg",%0" : "=r"(val));
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

alpha-remove-duplicate-included-header-file.patch

