Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0718CC13
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768698294; cv=none; b=PUJluUJn/VRWvlot4HbIoUbIEFo6nMgXsQxv34BbLTtpfZewJaoMkvyHVunPUwAU+lt7I3KN8TzvwYUYdId3ewH+JeGd9h+PRDtiwJEdi/EQTK3ER6YYQaQdomISUJyn3PRpmkhzV4jLgLTggs2aNihbt30DahCnIklVHhLYpCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768698294; c=relaxed/simple;
	bh=g6F4klM3wvszI0PfE9H3e2QUJ6aPz9bo+1aZMmz1+go=;
	h=Date:To:From:Subject:Message-Id; b=cpBvbVUm+GWLKqnt3z65CAOJvAVt8wJcEmmOkLWN51E6wTdHrcoI0zdZcfMWOz3k9MGb1TJuXBpssL+Zl67N4fXFRfIQDcYm4Y/WZ4s/n2yoPhhFDbo3GGFai0uQhN0NVyPaCGzly0CZ8blX2rhy19RblJ02w6EKz08IIFBgwRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e4LaQDdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e4LaQDdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1C1C4CEF7;
	Sun, 18 Jan 2026 01:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768698294;
	bh=g6F4klM3wvszI0PfE9H3e2QUJ6aPz9bo+1aZMmz1+go=;
	h=Date:To:From:Subject:From;
	b=e4LaQDdFkygkkGjeuMYGGBI4tKOvqw2fgqK/CxPm+lCuSrtCFC7aSZiNolgB5QY8L
	 s9uhdqGV0nrFENeVBbx2l5J+sg5nccvfQ8r3e92VQIGpvbzJEwHhMWNXTLwDsjpmAU
	 4Xn6MkMUNQUeVUZo2A8tfjrMadynzRm7tx0+m8Pk=
Date: Sat, 17 Jan 2026 17:04:53 -0800
To: mm-commits@vger.kernel.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-ignore-__noinstr_text_start.patch added to mm-nonmm-unstable branch
Message-Id: <20260118010454.6E1C1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/bloat-o-meter: ignore __noinstr_text_start
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-ignore-__noinstr_text_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-ignore-__noinstr_text_start.patch

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
From: Eric Dumazet <edumazet@google.com>
Subject: scripts/bloat-o-meter: ignore __noinstr_text_start
Date: Sat, 17 Jan 2026 08:34:47 +0000

__noinstr_text_start is adding noise to the script, ignore it.

For instance using __always_inline on __skb_incr_checksum_unnecessary and
CC=clang build.

Before this patch, __noinstr_text_start can show up and confuse us.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/2 grow/shrink: 3/0 up/down: 212/-206 (6)
Function                                     old     new   delta
tcp6_gro_complete                            208     283     +75
tcp4_gro_complete                            376     449     +73
__noinstr_text_start                        3536    3600     +64
__pfx___skb_incr_checksum_unnecessary         32       -     -32
__skb_incr_checksum_unnecessary              174       -    -174
Total: Before=25509464, After=25509470, chg +0.00%

After this patch we have a more precise result.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/2 grow/shrink: 2/0 up/down: 148/-206 (-58)
Function                                     old     new   delta
tcp6_gro_complete                            208     283     +75
tcp4_gro_complete                            376     449     +73
__pfx___skb_incr_checksum_unnecessary         32       -     -32
__skb_incr_checksum_unnecessary              174       -    -174
Total: Before=25505928, After=25505870, chg -0.00%

Link: https://lkml.kernel.org/r/20260117083448.3877418-1-edumazet@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-ignore-__noinstr_text_start
+++ a/scripts/bloat-o-meter
@@ -42,6 +42,7 @@ def getsizes(file, format):
                 if name.startswith("__se_sys"): continue
                 if name.startswith("__se_compat_sys"): continue
                 if name.startswith("__addressable_"): continue
+                if name.startswith("__noinstr_text_start"): continue
                 if name == "linux_banner": continue
                 if name == "vermagic": continue
                 # statics and some other optimizations adds random .NUMBER
_

Patches currently in -mm which might be from edumazet@google.com are

scripts-bloat-o-meter-ignore-__noinstr_text_start.patch

