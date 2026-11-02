Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793594261;
	b=fRyVC43/gLBTyudw0B72SmNcqVLIoGmX9ujfQMlAZlBPZ2+Z4sClqS+mmXWYrufEDElK
	 krfwUSf7PDdfH0JYUEodz/kWM7ODk+tMChbSsUYglmfF/rbduqJlOwNouBpOPQTyk7YM6
	 RrLL71yCK9/apuVnbHiSZcgydVJ8QXSvCpkZ9uWUCYxrFPXLnzHO21kYk00iKbeOiYFOq
	 D+aufiS4Kk29LA4Zh9vOZrV6UFWvilqIgOS5SA4sB1KzUEa+UvZflvJiJuxGsf8o474AP
	 HPitUdcjQXuQeIoGC0169XNl0e5pokpTbzBBjS9QV+D0C85KrtylkLklLkNl/fhqRgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793594261;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hM/gvwzJkusO2v57QMPXhaFyy9xcyUKEQdOMOHt01II=;
	b=322tlB4R70e/xPsW3uj7rqsN27Jk8Nl9KeEmhmCJRFwjso493diQXaDrOjcokuFFzIS1
	 m/jfjnoBC2SStcEN30b4PeeAS4lzMby8yPbCD5tRC25WTB8i1SiAxKld+wD3KFCk88hz2
	 HDhJ1pErmnFqgUOcyQreMJZMZtBfG+BFjEwRX4t2DX1d0Xya0K1IA1RnxsXTFVVZcVA2N
	 /0ZReqyEgvZP8ZauZmb0lJ1zzBOeclCXXaEDUCjhXlaoaXwdV7mvkof/K5wxxmaQ7KmRR
	 ijdqHSkkBXTmZavne0RBHqYYU+hle8hqGkc5NuBbWCF2OmydQMS6ZGUwjsS4onOj5OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="jDAwo/DC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A1606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 04:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jDAwo/DC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8EF1F000C1;
	Mon,  2 Nov 2026 04:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793594260;
	bh=hM/gvwzJkusO2v57QMPXhaFyy9xcyUKEQdOMOHt01II=;
	h=Date:To:From:Subject;
	b=jDAwo/DCMJ80bVZD6nZ3zqkiUmUYdCaO6VywFW2U0fYGzw+E1mqj9KIDauMEk8zl1
	 Wb38/DyIzZbrq5RPwVhR+IxrD+Do9x8JLkHpZtf+xJVyHUfYboNZKEvXyetzUcMGkN
	 8yARGuaojHlm2IHYM72xG2kmjMw2jht5qPEP7ZNM=
Date: Sun, 01 Nov 2026 20:37:40 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lukas.bulwahn@gmail.com,
	joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,
	kolyshkin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-warn-about-enosys-in-userspace-code.patch added to mm-nonmm-unstable branch
Message-Id: <20261102043740.9C8EF1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: don't warn about ENOSYS in userspace code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-warn-about-enosys-in-userspace-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-warn-about-enosys-in-userspace-code.patch

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
From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: checkpatch: don't warn about ENOSYS in userspace code
Date: Thu, 22 Oct 2026 15:44:21 -0700

The ENOSYS check enforces a kernel ABI rule: the kernel must only return
-ENOSYS for an invalid syscall number. It makes no sense for userspace
code under tools/, where ENOSYS is a regular "Function not implemented"
error, and checking for errno == ENOSYS is the standard way to detect
that a syscall is not available (e.g. to skip a selftest on an older
kernel). There, the warning is always a false positive.

Use the existing is_userspace() helper to skip the check for such files.

Link: https://lore.kernel.org/20261022224426.2756960-3-kolyshkin@gmail.com
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-enosys-in-userspace-code
+++ a/scripts/checkpatch.pl
@@ -4983,7 +4983,7 @@ sub process {
 # ENOSYS means "bad syscall nr" and nothing else.  This will have a small
 # number of false positives, but assembly files are not checked, so at
 # least the arch entry code will not trigger this warning.
-		if ($line =~ /\bENOSYS\b/) {
+		if ($line =~ /\bENOSYS\b/ && !is_userspace($realfile)) {
 			WARN("ENOSYS",
 			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from kolyshkin@gmail.com are

checkpatch-is_userspace-exclude-kernel-code-under-tools.patch
checkpatch-dont-warn-about-enosys-in-userspace-code.patch
checkpatch-dont-warn-about-bug-in-userspace-code.patch
checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch

