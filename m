Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E773EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905016; cv=none; b=i/Th9ZC66pVmXABS4bG4rBhiNWNjDl+Mn1v0soB8OuuYLjpX/Ptct+uKP+A4e1Nq1iklheDiI5aA9a/27DUSkDmfPdGj0EQLg2XXgQ2VGB93DUkEqd9kSzYQj41shuBcWRwR/6/VoZKmUDcj5I37KMbh5W7/GlIlo1Mn0MGjFC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905016; c=relaxed/simple;
	bh=GbXwyCoX9TI/Qk1oPQS5oyWqxgkprdSmqieEnqi0q3Y=;
	h=Date:To:From:Subject:Message-Id; b=lTN5RHJ+GEGsvCZmwfbFic74aLpv+FHR0h6gD6NHB4imcqFEu8z5j6jshj53p8jcI9TEoDXeBITVq6Hb6o0o0w9SchuUsu5ynukGeepx8Z8Wk7qiBeLNN0ZqH763UejacQugoagjMyX2wSnHP+FZfCxu9bLyhhekOinPBAxDDYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2vZzTgsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2vZzTgsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CCFC4CEF1;
	Sun,  1 Feb 2026 00:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905016;
	bh=GbXwyCoX9TI/Qk1oPQS5oyWqxgkprdSmqieEnqi0q3Y=;
	h=Date:To:From:Subject:From;
	b=2vZzTgshdg/DPxKK05ExwPl1i06Zx5L2A6FIvlHcjZiChbpbL3FxE8jxonLLzsX9e
	 48uG8lE613wKAYgHbgfcshxPCCA/NJXDtDkzEi0ZkALWo46j9wytDiGpGgHhDgae1U
	 c9Rar662vO/Anlx1hsUIDHY5X0xUKMOygUhIj9XY=
Date: Sat, 31 Jan 2026 16:16:55 -0800
To: mm-commits@vger.kernel.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-ignore-__noinstr_text_start.patch removed from -mm tree
Message-Id: <20260201001656.06CCFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/bloat-o-meter: ignore __noinstr_text_start
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-ignore-__noinstr_text_start.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


