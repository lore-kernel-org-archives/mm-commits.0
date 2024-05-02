Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D45316F91D
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668693; cv=none; b=TOTAfAZ8D3SwayiH4GEiHPJCE3A3Ox09BqeStVBtHsbmRBzmozJn63nzP6cB2VIOxTXO9MORIzFepGmhv63CKZ9NyEJ71FzkVs5/CeIXqSy6WFMyQhLXC5ZruzlD9LMtFhxNAcPvz5skjyj/vV6cZkMF+bGx8KwIfsKr/wOug1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668693; c=relaxed/simple;
	bh=+LlyKkdYCNiQ0L7dNmbeBAGS9r1tEGaH7Ld++BtHpRs=;
	h=Date:To:From:Subject:Message-Id; b=igYC4CQ55kTVP3mRSWq0nRKV5+2KcI7w2OyrgdmNByUI7GH/hATweZ8YK6dZYSq390EPpGQkctGN8jHhl8NCgk8UIrxNhD0/RO+HL/0VO1WVg2aLb+SHF9bhwbbEX/aj/v3HP7piMUr+5dL+ve63DxZtjRN+rRnPVm3mj73FFik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BSi7+p5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BSi7+p5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8839C4AF1B;
	Thu,  2 May 2024 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714668693;
	bh=+LlyKkdYCNiQ0L7dNmbeBAGS9r1tEGaH7Ld++BtHpRs=;
	h=Date:To:From:Subject:From;
	b=BSi7+p5CbDu6bgYYO/NtKl3LSBmF8QlyHcHsQuBZVB0yRb4e9s3QeiK4hlsnjI9I5
	 idJDEY/w4+geoPoGGya8yDeuJm/9porJwyhSr+IXcakRI2mPu7MIXwap3II1TYU6Xc
	 2T2RX6Ib+pRT34cSi6iour/Y5G86ax1w4z5s9qzs=
Date: Thu, 02 May 2024 09:51:31 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,song@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-handle-comma-separated-nmi_watchdog-command-line.patch added to mm-nonmm-unstable branch
Message-Id: <20240502165132.D8839C4AF1B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: handle comma separated nmi_watchdog command line
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-handle-comma-separated-nmi_watchdog-command-line.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-handle-comma-separated-nmi_watchdog-command-line.patch

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
From: Song Liu <song@kernel.org>
Subject: watchdog: handle comma separated nmi_watchdog command line
Date: Mon, 29 Apr 2024 23:02:35 -0700

Per the document, the kernel can accept comma separated command line like
nmi_watchdog=nopanic,0.  However, the code doesn't really handle it.  Fix
the kernel to handle it properly.

Link: https://lkml.kernel.org/r/20240430060236.1878002-1-song@kernel.org
Signed-off-by: Song Liu <song@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/watchdog.c~watchdog-handle-comma-separated-nmi_watchdog-command-line
+++ a/kernel/watchdog.c
@@ -71,6 +71,7 @@ void __init hardlockup_detector_disable(
 
 static int __init hardlockup_panic_setup(char *str)
 {
+next:
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
 	else if (!strncmp(str, "nopanic", 7))
@@ -79,6 +80,12 @@ static int __init hardlockup_panic_setup
 		watchdog_hardlockup_user_enabled = 0;
 	else if (!strncmp(str, "1", 1))
 		watchdog_hardlockup_user_enabled = 1;
+	while (*(str++)) {
+		if (*str == ',') {
+			str++;
+			goto next;
+		}
+	}
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
_

Patches currently in -mm which might be from song@kernel.org are

watchdog-handle-comma-separated-nmi_watchdog-command-line.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch

