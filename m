Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF51552FA
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 00:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752539483; cv=none; b=XjJOSN0AgZ3sSykBUiBbEWelhJtm8g4O7nTvGAutOkFcgsIM8tZkkBwBykkRWULUFIm3zXZ0SjYDN/Mw1o3Ssvy5sQkD9aOfRL075N2S/jS/U5HXihwm1ihHbPH/2UObXHMy4m04pqZTaX1+9OT+Mi+We1IRBMO+r9DkTKVDZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752539483; c=relaxed/simple;
	bh=nTcqtdMyhg8pwYiA0F044jI3+rX79bEhOep2oU6pBEw=;
	h=Date:To:From:Subject:Message-Id; b=OQsglpMj70GhJUYcnkiOjSP1Ls/MCPXc+tnaCrfdlYeuuwTmd8HzHgDzZPPm8qe6anyVHkzDQp3+hV0f8A0OKPXv8gdzD3hfMrIKhA2H77XHBG1NOXKlc1sN7wIk9iVFQh5y/RRF1RGPRMhlCOxRUHlfFc8Mjwk02b9pITQX7hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRviOfw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRviOfw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D79C4CEED;
	Tue, 15 Jul 2025 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752539483;
	bh=nTcqtdMyhg8pwYiA0F044jI3+rX79bEhOep2oU6pBEw=;
	h=Date:To:From:Subject:From;
	b=rRviOfw9ubN05PKQF7xIGBG3MOk93mLP1JCDB6ePul5mkyybA+SXsKLslbOlY8bF7
	 ixTnpwvIeY0Vaaa4+RIcxDV7f3Ifr3xpf51tQfN6BTjGYlPP3zt/IJ0Bi76jYFems9
	 r+EevyKllWCpEsAQf+NgUqr4V6GxXPy80jn4dTqw=
Date: Mon, 14 Jul 2025 17:31:22 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,davem@davemloft.net,bp@alien8.de,anshuman.khandual@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-restore-config_broken-help-text.patch added to mm-nonmm-unstable branch
Message-Id: <20250715003123.68D79C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/Kconfig: restore CONFIG_BROKEN help text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-kconfig-restore-config_broken-help-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-restore-config_broken-help-text.patch

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
Subject: init/Kconfig: restore CONFIG_BROKEN help text
Date: Mon Jul 14 05:20:02 PM PDT 2025

Linus added it in 2003, it later was removed.  Put it back.

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/init/Kconfig~init-kconfig-restore-config_broken-help-text
+++ a/init/Kconfig
@@ -169,6 +169,10 @@ menu "General setup"
 
 config BROKEN
 	bool
+	help
+	  This option allows you to choose whether you want to try to
+	  compile (and fix) old drivers that haven't been updated to
+	  new infrastructure.
 
 config BROKEN_ON_SMP
 	bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch
init-kconfig-restore-config_broken-help-text.patch

