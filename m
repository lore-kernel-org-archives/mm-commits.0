Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B98814277
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2wQzcZMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30587C433C8;
	Fri, 29 Dec 2023 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881417;
	bh=38EveL+5YOhrJQmcvJ426ZUtigeOa1raIUnqmEQX+C4=;
	h=Date:To:From:Subject:From;
	b=2wQzcZMaT8VFswVwmwkA7PSeQBVO6aAvuDY4jJ4drlhZAyQW6Z3++F1RDrJkDRsU9
	 WVV6hmT2FK8BzqWx43WzsS7qY4Hsqew81Bj15ttLS9cIIsHaspuKdVliD5MDwOWw1n
	 mZW9EonRZO7WPTuBbD5QHssOARIT0p6zrj2ix2x8=
Date: Fri, 29 Dec 2023 12:23:36 -0800
To: mm-commits@vger.kernel.org,quic_bjorande@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-strip-unexpected-cr-from-lines.patch removed from -mm tree
Message-Id: <20231229202337.30587C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: strip unexpected CR from lines
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-strip-unexpected-cr-from-lines.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


