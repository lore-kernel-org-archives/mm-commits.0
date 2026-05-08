Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B23362152
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 23:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778284115; cv=none; b=Dkt18vYjvDHecWyIPJlX0zyQZiUZV1g9It5JJ40ccj4hnNOIfMrVU2p1Q2G0xCnT7u8VWfDUDIbtqeW4dqOSxOB4kh2UKOFEd/O3z1KPyX9paFRG60uGnBbPwqSOlcKsclj/U+kCC0GljHvVSWb/bDUxIuNi6G5V2KO96ImA/7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778284115; c=relaxed/simple;
	bh=LIVhLYuZcx/MmZMt2FcCKRPtE5UFZxkRIBrahaBUSj4=;
	h=Date:To:From:Subject:Message-Id; b=lUbNfL5Sn90lQydmdCA+Nm4CNP3C/dYi2aAG5fr8ax1L11RRjgBaiUNGc/kBVsteJy5/NqMQAY1rfPzNO4djf2R/OrhS4LyM5qGB3RFquDj1tCtx+QvMh6Oym7GrOFwxB8KcRnc/8/Zr52I7HJ/BA0tr4ayERRAag/UB5I0mASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h0uHyKDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h0uHyKDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38732C2BCB0;
	Fri,  8 May 2026 23:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778284115;
	bh=LIVhLYuZcx/MmZMt2FcCKRPtE5UFZxkRIBrahaBUSj4=;
	h=Date:To:From:Subject:From;
	b=h0uHyKDzZqhoCrFQV84w70VfDAV+ooW0HIO41B7qKmDaSvgBlCgop28ZWRqJsXVeg
	 urBJQV26R8YX37b9h0DPxUVaLR+db2UR/ASeiJLARHilZbmPiHVb1UwH1wr/xlFx9n
	 Uteo2E+da1Z4aFy5dIUPug+FsIQItU1OL14qLwfg=
Date: Fri, 08 May 2026 16:48:34 -0700
To: mm-commits@vger.kernel.org,neil.armstrong@linaro.org,luca.ceresoli@bootlin.com,ian.ray@gehealthcare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-after-gehc-spin-off.patch added to mm-hotfixes-unstable branch
Message-Id: <20260508234835.38732C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: .mailmap: Update after GEHC spin-off
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-after-gehc-spin-off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-after-gehc-spin-off.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ian Ray <ian.ray@gehealthcare.com>
Subject: MAINTAINERS: .mailmap: Update after GEHC spin-off
Date: Wed, 6 May 2026 09:33:35 +0300

Update my email address from @ge.com to @gehealthcare.com after GE
HealthCare was spun-off from GE.

Link: https://lore.kernel.org/20260506063335.3-1-ian.ray@gehealthcare.com
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-after-gehc-spin-off
+++ a/.mailmap
@@ -338,6 +338,7 @@ Henrik Rydberg <rydberg@bitmath.org>
 Herbert Xu <herbert@gondor.apana.org.au>
 Huacai Chen <chenhuacai@kernel.org> <chenhc@lemote.com>
 Huacai Chen <chenhuacai@kernel.org> <chenhuacai@loongson.cn>
+Ian Ray <ian.ray@gehealthcare.com> <ian.ray@ge.com>
 Ignat Korchagin <ignat@linux.win> <ignat@cloudflare.com>
 Igor Korotin <igor.korotin@linux.dev> <igor.korotin.linux@gmail.com>
 Ike Panhc <ikepanhc@gmail.com> <ike.pan@canonical.com>
--- a/MAINTAINERS~maintainers-mailmap-update-after-gehc-spin-off
+++ a/MAINTAINERS
@@ -16494,7 +16494,7 @@ F:	drivers/usb/mtu3/
 
 MEGACHIPS STDPXXXX-GE-B850V3-FW LVDS/DP++ BRIDGES
 M:	Peter Senna Tschudin <peter.senna@gmail.com>
-M:	Ian Ray <ian.ray@ge.com>
+M:	Ian Ray <ian.ray@gehealthcare.com>
 M:	Martyn Welch <martyn.welch@collabora.co.uk>
 S:	Maintained
 F:	Documentation/devicetree/bindings/display/bridge/megachips-stdpxxxx-ge-b850v3-fw.txt
_

Patches currently in -mm which might be from ian.ray@gehealthcare.com are

maintainers-mailmap-update-after-gehc-spin-off.patch

