Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22A1A4F36
	for <mm-commits@vger.kernel.org>; Thu,  3 Oct 2024 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727982394; cv=none; b=ViCzDpyvj9TX1YILk270c+hpQKjn2D2Op2gT5MDd7+yGqiJjA0ELQCSuXGzXIWJ3xJX6siHMe6XSqg/CW9b/aXTJy+K/ryEVsCZhih7H084plpx6BbMTqEyuKy4mv1dQ4buUwgsAsKhqOkn8dp/0A8ZMw9X8+63PT1Rz137k2A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727982394; c=relaxed/simple;
	bh=IL0fj9apA8SvNEd5z2nCN2lmpzwWgMIerGfbtv0fBaQ=;
	h=Date:To:From:Subject:Message-Id; b=JFdwhcCfIT9lKg3bUv/qgmG6wwxcqfg0bXZeORS2Vs5akYD90OnLGxJMsTTQPm47I/DVmplBQMhCTVfcqhSCQY/upxNpThXQzc2ktOBy8p/yDfepsovKpzdyubWFq6D8dcE0DCY4K9VrkR0wvdnhTXGUH3r8UIvumQYpPcxJxA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hxYhJ/Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hxYhJ/Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECECC4CEC5;
	Thu,  3 Oct 2024 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727982393;
	bh=IL0fj9apA8SvNEd5z2nCN2lmpzwWgMIerGfbtv0fBaQ=;
	h=Date:To:From:Subject:From;
	b=hxYhJ/PeK830rYFEXao1k4xKDzcSLKNDZcHfv+gw/3rn9ShbfX6jiSpQynKf4r8xq
	 6KupqAcZbvMSQCjtzPja2/PvR1PebMT302kYnkoixZXeFnIQOvEycaGxnnlVNXRJuU
	 VugSFkym1+HqCRE8B3TAkUWIjpKiFepouzNmJ6JA=
Date: Thu, 03 Oct 2024 12:06:33 -0700
To: mm-commits@vger.kernel.org,xndchn@gmail.com,swboyd@chromium.org,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,luca.ceresoli@bootlin.com,kent.overstreet@linux.dev,cmllamas@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-remove-trailing-space.patch added to mm-nonmm-unstable branch
Message-Id: <20241003190633.9ECECC4CEC5@smtp.kernel.org>
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
Date: Thu, 3 Oct 2024 03:30:05 -0700

decode_stacktrace.sh adds a trailing space at the end of the decoded stack
if the module is not set (in most of the lines), which makes the some
lines of the stack having trailing space and some others not.

Do not add an extra space at the end of the line if module is not set,
adding consistency in output formatting.

Link: https://lkml.kernel.org/r/20241003103009.2635627-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Stephen Boyd <swboyd@chromium.org>
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
+	if [ -z ${module} ]
+	then
+		echo "${words[@]}" "$symbol"
+	else
+		echo "${words[@]}" "$symbol $module"
+	fi
 }
 
 while read line; do
_

Patches currently in -mm which might be from leitao@debian.org are

scripts-decode_stacktracesh-remove-trailing-space.patch

