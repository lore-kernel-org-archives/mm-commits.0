Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA0439ADB
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716582384; cv=none; b=meTirD99x2ummnWX1pIgPJfS5FKqd2OGn9+MQZZ3Z7wwFPXTCe+O0S48fPrQFTUvHUvy5JX1pbGy4mHN53fiNgZUL9eF7vNyNcD+K5fVEyt3UTDI/3AIgO39qTpiCGUrTSCmMIrazW27xXe9k0z/Bh4DrCSKpV772+cg7RxBs8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716582384; c=relaxed/simple;
	bh=MKit0C5q+Fw9yKnM8fdZSBbDOHU5vqSUmFucvuEwQPQ=;
	h=Date:To:From:Subject:Message-Id; b=muJ61rePB+ouQMrpyqbrphpujlWtak7SBdxtsrThykhILYtyMv4UNd1WSrrXwYvYe2hoKy9xUO+lQm/8hwmQ2y2r2QSRbzC/DH1VeyMCit58CLAdR8/T+AoaUxvG8yiDw8Byfya1dvDLMolbJC9+/IN70ZtuHw2PF6deekushH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlsGzqun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlsGzqun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE6CC2BBFC;
	Fri, 24 May 2024 20:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716582384;
	bh=MKit0C5q+Fw9yKnM8fdZSBbDOHU5vqSUmFucvuEwQPQ=;
	h=Date:To:From:Subject:From;
	b=LlsGzqunMYxe2fNmZnNuZzbNmvGqrgJeLs2fT/1QEJMuIGh/zyBUYyL5GSxNavdG2
	 /X/EPa+0Ms9WoNKjOf42iBD0+wCM8qL/d/Fhlhn8x+I7smQ9rBN6dt4uUDBeNjILZc
	 6+WNZ4ZcXU4bS20nX/SJJ5gCZJ8VthI0U5+H4uDY=
Date: Fri, 24 May 2024 13:26:23 -0700
To: mm-commits@vger.kernel.org,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,cmllamas@google.com,xndchn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace.patch added to mm-nonmm-unstable branch
Message-Id: <20240524202624.2AE6CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: better support to ARM32 module stack trace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace.patch

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
From: Xiong Nandi <xndchn@gmail.com>
Subject: scripts/decode_stacktrace.sh: better support to ARM32 module stack trace
Date: Fri, 24 May 2024 12:26:00 +0800

Sometimes there are special characters around module names in stack
traces, such as ARM32 with BACKTRACE_VERBOSE in "(%pS)" format, such as:
[<806e4845>] (dump_stack_lvl) from [<7f806013>] (hello_init+0x13/0x1000
[test])

In this case, $module will be "[test])", the trace can be decoded by
stripping the right parenthesis first: (dump_stack_lvl) from hello_init
(/foo/test.c:10) test.

Link: https://lkml.kernel.org/r/20240524042600.14738-3-xndchn@gmail.com
Signed-off-by: Xiong Nandi <xndchn@gmail.com>
Suggested-by: Elliot Berman <quic_eberman@quicinc.com>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace
+++ a/scripts/decode_stacktrace.sh
@@ -283,6 +283,9 @@ handle_line() {
 
 	if [[ ${words[$last]} =~ \[([^]]+)\] ]]; then
 		module=${words[$last]}
+		# some traces format is "(%pS)", which like "(foo+0x0/0x1 [bar])"
+		# so $module may like "[bar])". Strip the right parenthesis firstly
+		module=${module%\)}
 		module=${module#\[}
 		module=${module%\]}
 		modbuildid=${module#* }
_

Patches currently in -mm which might be from xndchn@gmail.com are

scripts-decode_stacktracesh-wrap-nm-with-util_prefix-and-util_suffix.patch
scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace.patch

