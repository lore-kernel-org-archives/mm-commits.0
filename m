Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D241AA3ED
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722377607; cv=none; b=K4QoA5e7t7XhxAkTDGb1Q3EL/Muh+s9iBPD3iXmCagBZ5Up9CNRftj9O/Wf2MS15i8/NgM44D3E3pDkLGlhyrhqlw1Y8bC6QW5P1G1Ae0NTcdD5V1pZRTOndUjmGaQa333HCqLA4No/8vCzK1I+wJ0STgulj6jcE/74BsVivsc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722377607; c=relaxed/simple;
	bh=JdaSzPbQTml6lmJj2Juj4hdAF1/eNh/NXtKBnSFMC5A=;
	h=Date:To:From:Subject:Message-Id; b=EyVZ00HjEvjHvwgRS0vZaobt+q/qC7ai9ByT4WW9lDjTP98N33IFHIwwmnze3epPIl4acbsIp6oAVkNf6LvIoVLtqky78jU7pZ5kTLUNBVxu/d5q6ou9cpqMWwnXVSwzsTLAK/rmgHv7Vg/TqSXoJNgWsCwU692UnsqjhwZxH/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zr3toFiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zr3toFiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F715C4AF09;
	Tue, 30 Jul 2024 22:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722377606;
	bh=JdaSzPbQTml6lmJj2Juj4hdAF1/eNh/NXtKBnSFMC5A=;
	h=Date:To:From:Subject:From;
	b=Zr3toFivI+UesWG7TVxHFRW+Veym43tInngyx3zngEOi7agkG+4usNHep2Uw6KIhZ
	 rLdfgLVU2ssd+36sCAUcY65wewz6x5RsLUZu/SUXHXVL/cJFF0Gt/lpWZwKZ6j0/s7
	 +re0hrftat8XeR3aXsmNZpDx/FajgAy1FfhcKnWY=
Date: Tue, 30 Jul 2024 15:13:25 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + failcmd-add-script-file-in-maintainers.patch added to mm-nonmm-unstable branch
Message-Id: <20240730221326.6F715C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: failcmd: add script file in MAINTAINERS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     failcmd-add-script-file-in-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/failcmd-add-script-file-in-maintainers.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: failcmd: add script file in MAINTAINERS
Date: Tue, 30 Jul 2024 09:08:13 -0700

failcmd is one of the main interfaces to fault injection framework, but,
it is not listed under FAULT INJECTION SUPPORT entry in MAINTAINERS.  This
is unfortunate, since git-send-email doesn't find emails to send the
patches to, forcing the user to try to guess who maintains it.

Akinobu Mita seems to be actively maintaining it, so, let's add the file
under FAULT INJECTION SUPPORT section.

Link: https://lkml.kernel.org/r/20240730160814.1979876-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~failcmd-add-script-file-in-maintainers
+++ a/MAINTAINERS
@@ -8536,6 +8536,7 @@ M:	Akinobu Mita <akinobu.mita@gmail.com>
 S:	Supported
 F:	Documentation/fault-injection/
 F:	lib/fault-inject.c
+F:	tools/testing/fault-injection/
 
 FBTFT Framebuffer drivers
 L:	dri-devel@lists.freedesktop.org
_

Patches currently in -mm which might be from leitao@debian.org are

failcmd-add-script-file-in-maintainers.patch

