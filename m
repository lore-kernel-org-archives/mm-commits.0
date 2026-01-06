Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363F337BB8;
	Tue,  6 Jan 2026 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719822; cv=none; b=GNqzlMVBr9RFLaSWZqpeFRS/IoNsKT1yChOL3wMoV/VFHcocq1ubeqrZL01x+EjRMaoq59S4COK8zdqXg/JIv6Qe0BX0K8Q/91vqi3v4A2Mfgh7aNfjtWBdKwOszlwE0t8NB1cSPovAcC84oqUw2EOT9BEBKtCyzrnOAaQ2wUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719822; c=relaxed/simple;
	bh=GpUUakj2qAg0mreZfE0T2jsgf7d85KdlNRXMuVpBbG8=;
	h=Date:To:From:Subject:Message-Id; b=ZLcbiWuNEbInYmbcPsaSxTJr47xplur7iKd60ztnbFSLsBgyzZv2nGuitWoHugdl3VCDuHwg3c61Luf0ByuJ1TwcXScQPXVbbQXIwgr/TiLQ/nTk33ZQV61Xku//ktBpQalM5dfJwF73APfJKmbzulGH7l+dz/yU2JMpf6+1j6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zRmMf3cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zRmMf3cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F4BC19424;
	Tue,  6 Jan 2026 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767719822;
	bh=GpUUakj2qAg0mreZfE0T2jsgf7d85KdlNRXMuVpBbG8=;
	h=Date:To:From:Subject:From;
	b=zRmMf3cz6miiZIANZx+w84Vx/mN33Li1wf2JXL8sXlIc1XyAEG4MKCkrm00nE46iI
	 vuJMCZE4AZuc+Py0WhnzcSO9MDyXgf6I3ZIxD5qExdGMEXPVSo3nbX+Lqov7YkBTE+
	 JMZBvA3MgTOqZMkCIKf6P+G4r5kg7gK7ionN3IXQ=
Date: Tue, 06 Jan 2026 09:17:01 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,noren@nvidia.com,mbloch@nvidia.com,joel.granados@kernel.org,feng.tang@linux.alibaba.com,gal@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-only-warn-about-deprecated-panic_print-on-write-access.patch added to mm-hotfixes-unstable branch
Message-Id: <20260106171701.E1F4BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: only warn about deprecated panic_print on write access
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     panic-only-warn-about-deprecated-panic_print-on-write-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-only-warn-about-deprecated-panic_print-on-write-access.patch

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
From: Gal Pressman <gal@nvidia.com>
Subject: panic: only warn about deprecated panic_print on write access
Date: Tue, 6 Jan 2026 18:33:21 +0200

The panic_print_deprecated() warning is being triggered on both read and
write operations to the panic_print parameter.

This causes spurious warnings when users run 'sysctl -a' to list all
sysctl values, since that command reads /proc/sys/kernel/panic_print and
triggers the deprecation notice.

Modify the handlers to only emit the deprecation warning when the
parameter is actually being set:

 - sysctl_panic_print_handler(): check 'write' flag before warning.
 - panic_print_get(): remove the deprecation call entirely.

This way, users are only warned when they actively try to use the
deprecated parameter, not when passively querying system state.

Link: https://lkml.kernel.org/r/20260106163321.83586-1-gal@nvidia.com
Fixes: ee13240cd78b ("panic: add note that panic_print sysctl interface is deprecated")
Fixes: 2683df6539cb ("panic: add note that 'panic_print' parameter is deprecated")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~panic-only-warn-about-deprecated-panic_print-on-write-access
+++ a/kernel/panic.c
@@ -131,7 +131,8 @@ static int proc_taint(const struct ctl_t
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	panic_print_deprecated();
+	if (write)
+		panic_print_deprecated();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
@@ -1014,7 +1015,6 @@ static int panic_print_set(const char *v
 
 static int panic_print_get(char *val, const struct kernel_param *kp)
 {
-	panic_print_deprecated();
 	return  param_get_ulong(val, kp);
 }
 
_

Patches currently in -mm which might be from gal@nvidia.com are

panic-only-warn-about-deprecated-panic_print-on-write-access.patch

