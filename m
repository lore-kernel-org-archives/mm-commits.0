Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADDB5DF16
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970547; cv=none; b=nSRVJkerDxRtxZzLPVrIiNme0suO0G5Hflx7yY++6EbAkelr8vyvzwqP1txPu4g9+yYDBv5YSZV0stP/hDvys7f04ebBjpLT2maYD/cx6q5eNJSBuw/xWLOkQGM0Bj6VSXmy8j/MALj3dRfBZEt0VT40J6rCAaGul42PRYbfL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970547; c=relaxed/simple;
	bh=lhiWw0CMsC3Ol7n3MoZJ/1jwT77Y43c/glGbpnYKTBM=;
	h=Date:To:From:Subject:Message-Id; b=PuHmgixvs6E7cwOWQz1tJ6sOnENibV/BHLMGOMKVD+s3c8XesuB/OoWCmyYhc0KdfzRDVnOwUJq7jIit9DZFCyEDZQFHGiO63m+vZ/ERsKEC9L5DAN9usgTFZh1cIWCLv7nQvI/vCo8fS+n9fVMx0wzmS4/MCEcAqABMs+/GEH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TUVVO2rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TUVVO2rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A9CC433F1;
	Tue, 23 Jan 2024 00:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970547;
	bh=lhiWw0CMsC3Ol7n3MoZJ/1jwT77Y43c/glGbpnYKTBM=;
	h=Date:To:From:Subject:From;
	b=TUVVO2rE/GJQyzit372Qys3nVdqFX4TUMyIHuiBStTD8i1mx6HI8lOFUnT7vZeuwy
	 O9U5sEGFfdvoiEo7Oo2Ki7hxnyvK0UdPMOgHDNmFAa2s7Aq5xoNWlf/d+yAIqUM1Xm
	 sLzdVPee/pDztKeJVMtI8wZQ/Gy/duYv9ESL6Nog=
Date: Mon, 22 Jan 2024 16:42:24 -0800
To: mm-commits@vger.kernel.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-dhry-add-missing-closing-parenthesis.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004226.C6A9CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: dhry: add missing closing parenthesis
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-dhry-add-missing-closing-parenthesis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-dhry-add-missing-closing-parenthesis.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: add missing closing parenthesis
Date: Mon, 22 Jan 2024 15:50:45 +0100

The help text for the Dhrystone benchmark test lacks a matching closing
parenthesis.

Link: https://lkml.kernel.org/r/772b43271bcb3dd17a6aae671b2084f08c05b079.1705934853.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-dhry-add-missing-closing-parenthesis
+++ a/lib/Kconfig.debug
@@ -2140,7 +2140,7 @@ config TEST_DHRY
 
 	  To run the benchmark, it needs to be enabled explicitly, either from
 	  the kernel command line (when built-in), or from userspace (when
-	  built-in or modular.
+	  built-in or modular).
 
 	  Run once during kernel boot:
 
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-dhry-remove-unneeded-linux-mutexh.patch
lib-dhry-use-ktime_ms_delta-helper.patch
lib-dhry-add-missing-closing-parenthesis.patch

