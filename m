Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55A221CC5A
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 21:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684779; cv=none; b=JcK2tfTDLdUkiUaLl0pGkcvfJ2JcntJH/5gWmHq3kUsWbON2DvlWckhdDoqCZnaFuvWIiXnCXhFB6mtfP3sioanS6fZuMCLHHKzl6Up9B1cCOOgATobZEPMt3caY0/LGGZJ2ipyyHwdP/ThHG72VmpN53hb/0prpWapOOjtLNII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684779; c=relaxed/simple;
	bh=GuWUlssW3UQOtzp0+/LcyEN9vI/krDYCyyb4LP1Q3Xo=;
	h=Date:To:From:Subject:Message-Id; b=vBOF6G7Vmhn8ucYR2sOkr8tnpuzBYBY7oPsqXiXgbGl0/K6PwDWXc46tvBvrAwtFlMA83sk7HLSMZzXemHT1Yi3rTfTDxx2yc2ZD94i08yQq40cjZaN0MJwg77tbBPu4kM4yFUmKLP+b4xqphVYGmUzQIEbIJiq7P2WY+8UJLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MgMtfiAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MgMtfiAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3500BC19421;
	Wed,  8 Apr 2026 21:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775684779;
	bh=GuWUlssW3UQOtzp0+/LcyEN9vI/krDYCyyb4LP1Q3Xo=;
	h=Date:To:From:Subject:From;
	b=MgMtfiAJxQuZX2zUBYaECH4oENFEbs42mMhN6nfudJ2pb7aTKCemhuvrqD9WPWqIl
	 KrRaciizqDkDUQliwUQzWpd0B2qRymz6QjUIW9Nxd/RzQEJmz1qSVepLwb4nAcuZKS
	 uzTPJ3GAWnbjvBdCSfw0zm4sX3zZA5rcFtBhtYTo=
Date: Wed, 08 Apr 2026 14:46:18 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,corbet@lwn.net,Bjorn@xn--rombobjrn-67a.se,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-watchdog-fix-typos-etc.patch added to mm-nonmm-unstable branch
Message-Id: <20260408214619.3500BC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: watchdog: fix typos etc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     doc-watchdog-fix-typos-etc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-watchdog-fix-typos-etc.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: doc: watchdog: fix typos etc
Date: Wed, 8 Apr 2026 14:35:21 -0700

Correct typos in lockup-watchdogs.rst.

Link: https://lkml.kernel.org/r/20260408213523.2707947-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Björn Persson <Bjorn@xn--rombobjrn-67a.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-fix-typos-etc
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
@@ -41,7 +41,7 @@ is a trade-off between fast response to
 Implementation
 ==============
 
-The soft and hard lockup detectors are built around a hrtimer.
+The soft and hard lockup detectors are built around an hrtimer.
 In addition, the softlockup detector regularly schedules a job, and
 the hard lockup detector might use Perf/NMI events on architectures
 that support it.
@@ -49,7 +49,7 @@ that support it.
 Frequency and Heartbeats
 ------------------------
 
-The core of the detectors in a hrtimer. It servers multiple purpose:
+The core of the detectors is an hrtimer. It serves multiple purposes:
 
 - schedules watchdog job for the softlockup detector
 - bumps the interrupt counter for hardlockup detectors (heartbeat)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

doc-watchdog-fix-typos-etc.patch

