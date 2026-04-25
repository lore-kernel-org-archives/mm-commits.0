Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEABA1FE44A
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777136953; cv=none; b=GnRzRN1UYNxyj78NRH9hA2+jt3K8bmnkNMRueGmOsHskRbTEsYAF58C5cTDwkh0nPP7gveRGctA21n5tAR9slLoIf+1JqMl8U2HyOJt6IlzN2eNcsur7M+4tmALxXJ/OKnim3y4h1rlXSjkUtmizRY8qQCONFAFvUI7NFGT3kuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777136953; c=relaxed/simple;
	bh=kXcCdQv/1yOdCDEjsrQOFLVBMwgDX+z/D9EZ1/15bSY=;
	h=Date:To:From:Subject:Message-Id; b=bqrNHUAveH4n5qIKxhQ0H2x6l3+vNBkdYOhJoM5ZRKaZdSBM+/dGbmSaVQ030lj55FP38LWcuEYjajmtyqv3Z3MuJSz6XXYyf4IA+LLWJgjZknrG2WQmLqVk8s5rikE+Po+FUtaDf/dta0hNDAU8xuSNoZNZ3d/+prNQM0leh6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X/jocMbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X/jocMbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E9CC2BCB0;
	Sat, 25 Apr 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777136953;
	bh=kXcCdQv/1yOdCDEjsrQOFLVBMwgDX+z/D9EZ1/15bSY=;
	h=Date:To:From:Subject:From;
	b=X/jocMbroubSB0AD8Aum7Yl5jIlQuNKo3kzK8dyU+JCa60e69kwyUH4+c3ydVctTc
	 BGPMtibclxpgi+txVo2W0OIJHd/esA5HVvLcMoWf/GaeBQ3zlrfafoVGo3eCFIjoz2
	 tkzkOaoEy8VKZZXX4pZ6laSE9xVKlMjqqa0Jryac=
Date: Sat, 25 Apr 2026 10:09:12 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,skhan@linuxfoundation.org,jack@suse.cz,corbet@lwn.net,broonie@kernel.org,brauner@kernel.org,emanuele.rocca@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coredump-add-core_pattern-specifier-for-si_code.patch added to mm-nonmm-unstable branch
Message-Id: <20260425170913.63E9CC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coredump: add core_pattern specifier for si_code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coredump-add-core_pattern-specifier-for-si_code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coredump-add-core_pattern-specifier-for-si_code.patch

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

coredump-add-core_pattern-specifier-for-si_code.patch

