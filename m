Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CC8144D16
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293178; cv=none; b=Svn5vKKbveFLad2F1wy+X3gfFEl8sXtruHXPR4WDGl63Aw3VXurui6Fs3KDZzB093dreFqcATcB24W8WAlASa8YMS/aDAWEaEkohLlTjE3+mDJEcIe1zjM6W+JUW6nRxV2JXV86eNtwAyqK6iX46GVesJJp0gUfUXNqlG638Clc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293178; c=relaxed/simple;
	bh=3qUGSsSHJ43DdafRgIYD/zR/TkpllzHbyAphWMcjWmE=;
	h=Date:To:From:Subject:Message-Id; b=NY5t0ZjqWyJ31HWvxtzN06nwxsooO8AAwU7O43s+0xvDUzvEZyuTXY/7GxAqIgx99Wa140cBJa/nOObk+4EY+AwnIfByhAy29tIwo6jQwRTUOYF45+YXUEEfDHXhxDGIDFK4VFslmsJC5KdwWTQ98b3lGEDHu16Z+scZKAA//hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ug4antZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ug4antZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94230C32789;
	Tue, 25 Jun 2024 05:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293178;
	bh=3qUGSsSHJ43DdafRgIYD/zR/TkpllzHbyAphWMcjWmE=;
	h=Date:To:From:Subject:From;
	b=Ug4antZhGbeZe4Ds+ohoCSCd5UbmSF/vczd1w5k907e8J38C6I3yDkdvHbT2n+0Kx
	 Iia2rmsXuSK6tU/HSzvmPdRWkwgrfY0xUP4KevETiq4FRFYUOuVCqfQIJb5q+PI9gH
	 YwR5xFk2dwJ2RbOtyhRHPHi4hIkJ30ino3Jy8SKo=
Date: Mon, 24 Jun 2024 22:26:18 -0700
To: mm-commits@vger.kernel.org,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,cmllamas@google.com,xndchn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace.patch removed from -mm tree
Message-Id: <20240625052618.94230C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: better support to ARM32 module stack trace
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-better-support-to-arm32-module-stack-trace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


