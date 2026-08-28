Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08037364058
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787941600; cv=none; b=ZnOkQd53bZgVzYH74Wvj1jbPKki3D32pKryBAoQZcjPhXaaAby61tq4Yos4DY/Ts4Fm6fbXfmDBMzHAFest62neWwbzq5mQ7Bz+K9Y1SIFXTZwFyZ2k1opx5PiIBOK570S3/e4LWQVRFhjdES17kRKoNmpn9eiYXaOPn+vANNeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787941600; c=relaxed/simple;
	bh=xQfl1m79qTopN/Lhhd9MjjYZD6Z1k/xiwOFp9SM0fuw=;
	h=Date:To:From:Subject:Message-Id; b=XbhtorPajJHDlO/A+nUTZw6wYRaDJPyD7Hi6YUxD0SXpGX3jRmvuM0VpfdkmcXWkSj0chEXI0wL6r9MNIXyVpHluopHKBUOIco+pR3ybByaTID8ODA6wTVg7szJeULredC15jLxj3khCuatdVpWvlmjs3dZA2ne2ERgo1fw9VP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q6d4BWbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q6d4BWbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6551F000E9;
	Fri, 28 Aug 2026 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787941598;
	bh=E+1fj8BLId4UiO1QxpzLy65JHxhSTqrYurmrGSj7Vj0=;
	h=Date:To:From:Subject;
	b=Q6d4BWbqxXmafASCkjO6fFCu4onsVPt3oUjJAInFZbrTGkvHz+xI53aEwsQA0Tyr9
	 NCV63jsikDHfdPIvkWaaZAP6Jcd5zpZpFyJA1xGUv0Ro4vHYLR1/BQ5+AC5cp8R2EU
	 Hqnvk0KAn5f4Sa+ZQO+Amw2nXkT9riZTk7XjpPOI=
Date: Fri, 28 Aug 2026 11:26:38 -0700
To: mm-commits@vger.kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-simplify-early_hostname.patch added to mm-nonmm-unstable branch
Message-Id: <20260828182638.6E6551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: simplify early_hostname()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-simplify-early_hostname.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-simplify-early_hostname.patch

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
From: Thorsten Blum <blum@kernel.org>
Subject: init: simplify early_hostname()
Date: Fri, 28 Aug 2026 19:43:37 +0200

Inline the strscpy() check and remove the redundant arglen variable.  Use
%zu to format the unsigned maxlen argument and add a newline after the
truncation warning.

Link: https://lore.kernel.org/20260828174337.609333-2-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/init/version.c~init-simplify-early_hostname
+++ a/init/version.c
@@ -21,16 +21,14 @@ static int __init early_hostname(char *a
 {
 	size_t bufsize = sizeof(init_uts_ns.name.nodename);
 	size_t maxlen  = bufsize - 1;
-	ssize_t arglen;
 
 	if (!arg)
 		return -EINVAL;
 
-	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
-	if (arglen < 0) {
-		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
+	if (strscpy(init_uts_ns.name.nodename, arg, bufsize) < 0)
+		pr_warn("hostname parameter exceeds %zu characters and will be truncated\n",
 			maxlen);
-	}
+
 	return 0;
 }
 early_param("hostname", early_hostname);
_

Patches currently in -mm which might be from blum@kernel.org are

init-fix-early-boot-crash-with-bare-hostname-parameter.patch
init-simplify-early_hostname.patch

