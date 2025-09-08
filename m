Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809F52F3C28
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757372554; cv=none; b=dAN0z1Y5mxTYwpqVZ9tVyiHi6weow7RGmjekQTVFrMuHZgD33CI+GSReDov1RNJTGxiTKZVArlpwdMV6SpSUj4eM8MDc/0xEy9auyCu6i0RQoDAMxDlpB2F4NXVEAV4LPwozxxvu/6siCKXQ+WP2YSXsVlD2WXTtKefcCf2EbTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757372554; c=relaxed/simple;
	bh=CTP1++1VVNXQgKIQYGninDx6pQ0hR2sULyd13pp4GPM=;
	h=Date:To:From:Subject:Message-Id; b=Ef7DT9kA8xZmyZbMCtLodjS2qPWhgrN15royJ1WCdBcUa5JfOxkAYNUiiMhy8g10EGC5jvwzk4VkCltkbQSW4gXGR/P0melO3x9zct47RpR2MPA9UlOHl1EKKNkYEIati45MCdYGNMWPxVyGcFKla94tZqzeTwMElGkcCoubIBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlCYJ16W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlCYJ16W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D7FC4CEF7;
	Mon,  8 Sep 2025 23:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757372554;
	bh=CTP1++1VVNXQgKIQYGninDx6pQ0hR2sULyd13pp4GPM=;
	h=Date:To:From:Subject:From;
	b=NlCYJ16WnlMN5wqL2MCiFO0+iefDkkMOReX+xAmZH0c6Wzi8kgmyUp15RV8bkYs48
	 W5k9eZUhm5Ij/SsxCNaUI8wBgJrAJgWUz+hihg+GUFsdEHTpvY5keBqcrYvbEnVJ9Q
	 WPjJcm3T5O7VT4v/9maf0bCJu0R/IP6XA7iPhRnY=
Date: Mon, 08 Sep 2025 16:02:33 -0700
To: mm-commits@vger.kernel.org,swboyd@chromium.org,quic_eberman@quicinc.com,luca.ceresoli@bootlin.com,leitao@debian.org,cmllamas@google.com,matttbe@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-code-preserve-alignment.patch added to mm-new branch
Message-Id: <20250908230234.47D7FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: code: preserve alignment
has been added to the -mm mm-new branch.  Its filename is
     scripts-decode_stacktracesh-code-preserve-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-code-preserve-alignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: scripts/decode_stacktrace.sh: code: preserve alignment
Date: Mon, 08 Sep 2025 17:41:59 +0200

With lines having a code to decode, the alignment was not preserved for
the first line.

With this sample ...

  [   52.238089][   T55] RIP: 0010:__ip_queue_xmit+0x127c/0x1820
  [   52.238401][   T55] Code: c1 83 e0 07 48 c1 e9 03 83 c0 03 (...)

... the script was producing the following output:

  [   52.238089][   T55] RIP: 0010:__ip_queue_xmit (...)
  [ 52.238401][ T55] Code: c1 83 e0 07 48 c1 e9 03 83 c0 03 (...)

That's because scripts/decodecode doesn't preserve the alignment.  No need
to modify it, it is enough to give only the "Code: (...)" part to this
script, and print the prefix without modifications.

With the same sample, we now have:

  [   52.238089][   T55] RIP: 0010:__ip_queue_xmit (...)
  [   52.238401][   T55] Code: c1 83 e0 07 48 c1 e9 03 83 c0 03 (...)

Link: https://lkml.kernel.org/r/20250908-decode_strace_indent-v1-3-28e5e4758080@kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Tested-by: Carlos Llamas <cmllamas@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-code-preserve-alignment
+++ a/scripts/decode_stacktrace.sh
@@ -242,8 +242,10 @@ debuginfod_get_vmlinux() {
 
 decode_code() {
 	local scripts=`dirname "${BASH_SOURCE[0]}"`
+	local lim="Code: "
 
-	echo "$1" | $scripts/decodecode
+	echo -n "${1%%${lim}*}"
+	echo "${lim}${1##*${lim}}" | $scripts/decodecode
 }
 
 handle_line() {
_

Patches currently in -mm which might be from matttbe@kernel.org are

scripts-decode_stacktracesh-symbol-avoid-trailing-whitespaces.patch
scripts-decode_stacktracesh-symbol-preserve-alignment.patch
scripts-decode_stacktracesh-code-preserve-alignment.patch

