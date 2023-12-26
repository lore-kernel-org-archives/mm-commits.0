Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B889D1FAD
	for <mm-commits@vger.kernel.org>; Tue, 26 Dec 2023 19:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oG/xODCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ED5C433C7;
	Tue, 26 Dec 2023 19:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703620782;
	bh=E+gm+1lbBr3lg4cKl58ypMb5xT1UJ+pLxnv7ssDmDiU=;
	h=Date:To:From:Subject:From;
	b=oG/xODCnL9jy5wfgFe9fl4gsWgcA5P7PtD8MkASXo+98FsOGEV4caqC3IpH8yQVec
	 0PqHsS81uPUR6fN1yRA7tSkmh/hEq2fFAwt/VcKhkXfXmuL+lHmGzN5nzso0PtDokR
	 9HscQCvnnoL3jgzB5b3cLB4PKsMBx0M/2gU7ZlG0=
Date: Tue, 26 Dec 2023 11:59:41 -0800
To: mm-commits@vger.kernel.org,quic_bjorande@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-strip-unexpected-cr-from-lines.patch added to mm-nonmm-unstable branch
Message-Id: <20231226195942.13ED5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: strip unexpected CR from lines
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-strip-unexpected-cr-from-lines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-strip-unexpected-cr-from-lines.patch

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
From: Bjorn Andersson <quic_bjorande@quicinc.com>
Subject: scripts/decode_stacktrace.sh: strip unexpected CR from lines
Date: Mon, 25 Dec 2023 09:40:35 -0800

When the kernel log is acquired over a serial cable it is not uncommon for
the log to contain carriage return characters, in addition to the expected
line feeds.

When this output is feed into decode_stacktrace.sh, handle_line() fails to
strip the trailing ']' off the module name, which results in find_module()
not being able to find the referred to kernel module.  This is reported to
the user as:

  WARNING! Modules path isn't set, but is needed to parse this symbol

The solution is to reconfigure the serial port, or to strip the carriage
returns from the log, but this isn't obvious from the error reported by
the script.

Instead, make decode_stacktrace.sh more user friendly by stripping the
trailing carriage return.

Link: https://lkml.kernel.org/r/20231225-decode-stacktrace-cr-v1-1-9f306f38cdde@quicinc.com
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-strip-unexpected-cr-from-lines
+++ a/scripts/decode_stacktrace.sh
@@ -291,6 +291,9 @@ handle_line() {
 }
 
 while read line; do
+	# Strip unexpected carriage return at end of line
+	line=${line%$'\r'}
+
 	# Let's see if we have an address in the line
 	if [[ $line =~ \[\<([^]]+)\>\] ]] ||
 	   [[ $line =~ [^+\ ]+\+0x[0-9a-f]+/0x[0-9a-f]+ ]]; then
_

Patches currently in -mm which might be from quic_bjorande@quicinc.com are

scripts-decode_stacktracesh-strip-unexpected-cr-from-lines.patch

