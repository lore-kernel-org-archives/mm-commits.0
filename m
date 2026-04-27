Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A3626F46F
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304002; cv=none; b=juSRZXzOMapDTSCtegM9/sRtkH1Zv9Y6wi0GezMbeneBR/v5kF1IJv03ACP3aqrB0wnSV5LJfuNJZacgDYoLXKKy9fph7ycA/YxFOEG0IVlt2hz+ffNrSQO8Q1mF2r1HtZRShifKC1r2ObicpMsF2YayAVhnrKHfiSgks2xI5iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304002; c=relaxed/simple;
	bh=tk18V7qzJzLpRWZlWWICLC7vghUa15IELdjiD7K4vbk=;
	h=Date:To:From:Subject:Message-Id; b=M/obuK7rMslaRt43vc1PsTwLlH2GgzPyC2PRV7fZ/Rq//j1CPrX2NpAUPoE2E8/07IUQY3eWA2a42P5oyLG4m7TO4DZW8DDOBB3o3uUHcmqvTgv2Nt/z8xombeV+6xg23SjjSpzDA5CM4G5ILCloIxedcpMLNQeeyBQr/6q6VIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e3Yr6C/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e3Yr6C/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFA2C19425;
	Mon, 27 Apr 2026 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777304002;
	bh=tk18V7qzJzLpRWZlWWICLC7vghUa15IELdjiD7K4vbk=;
	h=Date:To:From:Subject:From;
	b=e3Yr6C/nBPoe92ZfGQTKrVmAnGaQqVMKOxFDMaDhA6ExXJTLhYkbdrQ7c2+NOO3Dv
	 W7ncZM/Jj2RVc+XEXkA5A4ZKSGE76x/h6gfIyD8UmWPvORnuBVZRh3/fMvRvgCdrav
	 0vXx3srkX1NrHIIOfz5b3P4HsneKfw5BSX14S114=
Date: Mon, 27 Apr 2026 08:33:21 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,skhan@linuxfoundation.org,jack@suse.cz,corbet@lwn.net,broonie@kernel.org,brauner@kernel.org,emanuele.rocca@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] coredump-add-core_pattern-specifier-for-si_code.patch removed from -mm tree
Message-Id: <20260427153322.1FFA2C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: coredump: add core_pattern specifier for si_code
has been removed from the -mm tree.  Its filename was
     coredump-add-core_pattern-specifier-for-si_code.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Emanuele Rocca <emanuele.rocca@arm.com>
Subject: coredump: add core_pattern specifier for si_code
Date: Tue, 17 Mar 2026 16:00:06 +0100

The specifiers supported by core_pattern include the option to indicate
the signal number si_signo by using %s.  Other than identifying which
signal generated a core dump (eg: 11 for SIGSEGV), it is useful to know
the reason why a certain signal was sent.  The signal code si_code (eg: 2
for SEGV_ACCERR) provides this information.

Adding the signal code to core_pattern can benefit in particular sysadmins
who pipe core dumps to user-space programs for later analysis. 
systemd-coredump(8) is a notable example of such programs.

Link: https://lore.kernel.org/ablsdmLsMKm0z5wt@NH27D9T0LF
Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    1 +
 fs/coredump.c                               |    5 +++++
 2 files changed, 6 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~coredump-add-core_pattern-specifier-for-si_code
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -170,6 +170,7 @@ core_pattern
 	%d		dump mode, matches ``PR_SET_DUMPABLE`` and
 			``/proc/sys/fs/suid_dumpable``
 	%s		signal number
+	%n		signal code
 	%t		UNIX time of dump
 	%h		hostname
 	%e		executable filename (may be shortened, could be changed by prctl etc)
--- a/fs/coredump.c~coredump-add-core_pattern-specifier-for-si_code
+++ a/fs/coredump.c
@@ -403,6 +403,11 @@ static bool coredump_parse(struct core_n
 				err = cn_printf(cn, "%d",
 						cprm->siginfo->si_signo);
 				break;
+			/* code of the signal that caused the coredump */
+			case 'n':
+				err = cn_printf(cn, "%d",
+						cprm->siginfo->si_code);
+				break;
 			/* UNIX time of coredump */
 			case 't': {
 				time64_t time;
_

Patches currently in -mm which might be from emanuele.rocca@arm.com are


