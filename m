Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2AA21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489964; cv=none; b=XVI85SBkhZ+nTXQuJk2z0jaf+FdOpFF3tbFTsFdujVuED2RJxblbpmt0Wqn3a4ftkWJqnsWZ8IzjYboWXx51anEasfZq4lQ/LFV3OsXhzuAx6YB2hp83UHFDC3XVwi6770x5w1854GUfkr4bjMiRGYOciMvBSwy7/LrhXBQ13Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489964; c=relaxed/simple;
	bh=Rjg+qdfcYeyvzS1SsVK56YnQH3KgSlP2onJsUQ4RyBo=;
	h=Date:To:From:Subject:Message-Id; b=DAn+k2Oi2bHCuclGf9ESGSc4dcSvNdHT8WUiMu3RJ012x8EtoKurYvzRcand83ZvYypAA9m9mMy6Dw6s29qgP9ykMcBGBWQODN7QB+z5/tzsVoKQvhMOPzBkjzBNCmWqmCXhPmmFxR9ZhcpxeGDuHXcPK6trmpx/72eWYT8JlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZpUTvAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZpUTvAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64290C4CEE7;
	Sun, 21 Sep 2025 21:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489964;
	bh=Rjg+qdfcYeyvzS1SsVK56YnQH3KgSlP2onJsUQ4RyBo=;
	h=Date:To:From:Subject:From;
	b=cZpUTvAT0MN6o77Jx9sjmOZG2cwREVYRj+KakW8AYH8gnWUffK4ZEvOy86dYSyM/p
	 yveaUsnQpeL/5X6j0qa25hkaMRr/3wnXu2ta8TjBAz74y/NnuZ7uP8HgpJ4+DwehBa
	 WXe90A50QpPdVtgj859zcfpCvJKLlzmiAJfknUzg=
Date: Sun, 21 Sep 2025 14:26:03 -0700
To: mm-commits@vger.kernel.org,swboyd@chromium.org,quic_eberman@quicinc.com,luca.ceresoli@bootlin.com,leitao@debian.org,cmllamas@google.com,matttbe@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scripts-decode_stacktracesh-code-preserve-alignment.patch removed from -mm tree
Message-Id: <20250921212604.64290C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: code: preserve alignment
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-code-preserve-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


