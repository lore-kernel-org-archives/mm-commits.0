Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695F1CB330
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728935082; cv=none; b=Zm0InX1HyUFP3A81VHiSIlje3c3I98aH73IT2Fvs+n66LKVEGcAzOjc52wRVy7p81d244zR1Ah0doXql+rT6jYal1znI4v7er0n4PzTVc2GNuAZSQeALw6/Ig7HM1X/hzVeIpCgQ/jGKTjILgs/Y1ZnVqNegoS2RQspl3Y1/l+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728935082; c=relaxed/simple;
	bh=fqSYR/UJ+ebDkp2whGntl0aOtbYGH2r3cwA1E3YH6rg=;
	h=Date:To:From:Subject:Message-Id; b=kM/A0aZCuA6KKk+BwOtiylAXvw6VM2Gd+ghPTd0E8oe9eEpy8vrmWU8Q8x/PiztVXHPaDU/5fwiNhNPYw3QVVg7Tm+d3db1Qb11z9p+BzR6zRg1vk0sLEj9TGiyxkIww5gjEpvWPtHULkcFtjFCAmAliWjEWWkBY2ZZgp43wJLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wG3LlZxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wG3LlZxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBFEC4CEC3;
	Mon, 14 Oct 2024 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728935082;
	bh=fqSYR/UJ+ebDkp2whGntl0aOtbYGH2r3cwA1E3YH6rg=;
	h=Date:To:From:Subject:From;
	b=wG3LlZxFPzn92Jlluh1JWrmOpqV3Q1+8Zut4tjRy06YSWPqjiCqXmAdLIet6HfGcl
	 3z9FFNkkzqS/ttMyPUjJhEKVwb4ziyhzEe+kmvi+e8uXW72/Kt1JQiJTKkmc3eJGOa
	 jpknAb9hUIy6ILgr/U1La2IbczTpojmQDWRXgkWY=
Date: Mon, 14 Oct 2024 12:44:41 -0700
To: mm-commits@vger.kernel.org,xndchn@gmail.com,swboyd@chromium.org,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,luca.ceresoli@bootlin.com,cmllamas@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-remove-trailing-space.patch added to mm-nonmm-unstable branch
Message-Id: <20241014194441.EEBFEC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: remove trailing space
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-remove-trailing-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-remove-trailing-space.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: scripts/decode_stacktrace.sh: remove trailing space
Date: Mon, 14 Oct 2024 03:02:10 -0700

decode_stacktrace.sh adds a trailing space at the end of the decoded stack
if the module is not set (in most of the lines), which makes the some
lines of the stack having trailing space and some others not.

Do not add an extra space at the end of the line if module is not set,
adding consistency in output formatting.

Link: https://lkml.kernel.org/r/20241014100213.1873611-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Xiong Nandi <xndchn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-remove-trailing-space
+++ a/scripts/decode_stacktrace.sh
@@ -311,7 +311,12 @@ handle_line() {
 	parse_symbol # modifies $symbol
 
 	# Add up the line number to the symbol
-	echo "${words[@]}" "$symbol $module"
+	if [[ -z ${module} ]]
+	then
+		echo "${words[@]}" "$symbol"
+	else
+		echo "${words[@]}" "$symbol $module"
+	fi
 }
 
 while read line; do
_

Patches currently in -mm which might be from leitao@debian.org are

mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch
scripts-decode_stacktracesh-remove-trailing-space.patch

