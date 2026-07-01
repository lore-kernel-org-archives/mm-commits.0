Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAFF3B2AA
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782877558; cv=none; b=nbTMeUJnmUdtURPcJVgQHIKh7xo6Ps7XSI3Yh0H3CrytQKIMdVG0H6ECbBmTdONfOpyKUaPumt8HJ+W3hlwztg6CmlgFmSEK23zNIYAIQxzRPqMxCB+QySbw0I5ygGJYRiveM8Ud7+L2V5SCs4bJgDlEEIRDFaLZfsPOO4Fit8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782877558; c=relaxed/simple;
	bh=3zgSB2HQB2/Wv5Wwyowo7sU0MDvuttQ92Wt5kM9JFxU=;
	h=Date:To:From:Subject:Message-Id; b=Hu5wKPi4/SKtNJg9PDt7+9TE6g6kVgwyLQkeTIuXKE9WDNVno1TrpVMWZFbwD5YtS7avlnQz27OqY2YTK15Oi3xyIMeGF3AdD10uC9OUHQv2S42Ls1pSOnJhqU3yYGcmfyWQ+unzsdVvUTV1kKZY5LdpeiOwOUcnpiClrUf3EU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyCJLOWw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyCJLOWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25A51F000E9;
	Wed,  1 Jul 2026 03:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782877556;
	bh=Or4PWSEfilkwGbXBgJnJD8+Mrvt0KR2xl9fMKN06sIQ=;
	h=Date:To:From:Subject;
	b=gyCJLOWwPLp7YDm2XCMvLBZRt6ivuehB4iMQIpIWhqWh+hXiFJzrT/EjSJUJG0AtZ
	 ABl5aHop5UwV/CmglkVMxwI0ptOPBlvm7qb4sKafbtSEQZhNKQms12iAnnJcAlDEf9
	 a8TO7fdokXejrEb0Y+R6jXsL1UWdqF1Sq9vJvrr0=
Date: Tue, 30 Jun 2026 20:45:56 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,sarasena.adr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-accounting-delaytopc-fix-typo-in-psi-header-string.patch added to mm-nonmm-unstable branch
Message-Id: <20260701034556.D25A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/accounting/delaytop.c: fix typo in PSI header string
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-accounting-delaytopc-fix-typo-in-psi-header-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-accounting-delaytopc-fix-typo-in-psi-header-string.patch

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
From: Sara Sena <sarasena.adr@gmail.com>
Subject: tools/accounting/delaytop.c: fix typo in PSI header string
Date: Tue, 30 Jun 2026 22:11:53 -0300

Link: https://lore.kernel.org/20260701011153.93426-1-sarasena.adr@gmail.com
Signed-off-by: Sara Sena <sarasena.adr@gmail.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/accounting/delaytop.c~tools-accounting-delaytopc-fix-typo-in-psi-header-string
+++ a/tools/accounting/delaytop.c
@@ -878,7 +878,7 @@ static void display_results(int psi_ret)
 	suc &= BOOL_FPRINT(out, "\033[H\033[J");
 
 	/* PSI output (one-line, no cat style) */
-	suc &= BOOL_FPRINT(out, "System Pressure Information: (avg10/avg60vg300/total)\n");
+	suc &= BOOL_FPRINT(out, "System Pressure Information: (avg10/avg60/avg300/total)\n");
 	if (psi_ret) {
 		suc &= BOOL_FPRINT(out, "  PSI not found: check if psi=1 enabled in cmdline\n");
 	} else {
_

Patches currently in -mm which might be from sarasena.adr@gmail.com are

tools-accounting-delaytopc-fix-typo-in-psi-header-string.patch

