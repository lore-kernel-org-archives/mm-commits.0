Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CBC1A23A6
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 02:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638696; cv=none; b=EmB69t/XIjxkw/Enh9xq6SjEfPrYiynbQEdEsU0NMN/SYd5jMYFygsZOPNZDY6iaIZ/JEToXEBNeGLF9qC8TcrBikM8RZ1Gj8jxn0Zpo3xny5vhwKDTaFHkyQYIo0mR7wbR4zuIfEYgsA9gci46CLT0UJ/LI8pGNPTk4UzxhiXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638696; c=relaxed/simple;
	bh=OLRw3uuLpgfuWhJQiH6qEPfoXlgUoMsczmziKV0/j5k=;
	h=Date:To:From:Subject:Message-Id; b=KEimcWIn0uPOZrQpciQ8MfRDr0yan/oQCxGhlOpEUgGu3TyNII5rqu2HjLWFarTwYaEMijj1RAUlo5XsKiT2nC/ME/m7oFPQvKUhm/dUWWY7ghG6gDDN//PbgV/ceT+5xKmf4wh50i5EpbEn9dV34epSwi3juIDA79G8c5asu58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LAsOAPpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LAsOAPpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F13AC2BCB0;
	Wed, 13 May 2026 02:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638695;
	bh=OLRw3uuLpgfuWhJQiH6qEPfoXlgUoMsczmziKV0/j5k=;
	h=Date:To:From:Subject:From;
	b=LAsOAPpwTY0ddgMiPb2GzxumsxrhE4rluM9tW4ac7+d+3FQes/PxO7llJPvw0qyN/
	 u2fhrCvN1xtdbWudIq7rSmObp4dI0YX1AU/ZuZ5/9GhUCmSRYbPiAhzZ7low1GlcQa
	 UfsBMvCQh67VIU4MBwztHqgoz/QIyV/WyTIQfYjk=
Date: Tue, 12 May 2026 19:18:15 -0700
To: mm-commits@vger.kernel.org,vkoskiv@gmail.com,edumazet@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-ignore-_sdata.patch added to mm-nonmm-unstable branch
Message-Id: <20260513021815.9F13AC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/bloat-o-meter: ignore _sdata
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-ignore-_sdata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-ignore-_sdata.patch

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
From: Yury Norov <ynorov@nvidia.com>
Subject: scripts/bloat-o-meter: ignore _sdata
Date: Mon, 4 May 2026 16:36:05 -0400

_sdata is a linker symbol, but bloat-o-meter may consider it as a real
variable:

$ scripts/bloat-o-meter vmlinux.orig vmlinux
add/remove: 7/1 grow/shrink: 0/0 up/down: 3437/-4096 (-659)
Function                                     old     new   delta
crc32table_le                                  -    1024   +1024
crc32table_be                                  -    1024   +1024
crc32ctable_le                                 -    1024   +1024
byte_rev_table                                 -     256    +256
crc32_be                                       -      39     +39
crc32c                                         -      35     +35
crc32_le                                       -      35     +35
_sdata                                      4096       -   -4096
Total: Before=8592564398, After=8592563739, chg -0.00%

With the patch:

$ scripts/bloat-o-meter vmlinux.orig vmlinux
add/remove: 7/0 grow/shrink: 0/0 up/down: 3437/0 (3437)
Function                                     old     new   delta
crc32table_le                                  -    1024   +1024
crc32table_be                                  -    1024   +1024
crc32ctable_le                                 -    1024   +1024
byte_rev_table                                 -     256    +256
crc32_be                                       -      39     +39
crc32c                                         -      35     +35
crc32_le                                       -      35     +35
Total: Before=8592560302, After=8592563739, chg +0.00%

Link: https://lore.kernel.org/20260504203606.427972-1-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Cc: Valtteri Koskivuori <vkoskiv@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-ignore-_sdata
+++ a/scripts/bloat-o-meter
@@ -43,6 +43,7 @@ def getsizes(file, format):
                 if name.startswith("__se_compat_sys"): continue
                 if name.startswith("__addressable_"): continue
                 if name.startswith("__noinstr_text_start"): continue
+                if name.startswith("_sdata"): continue
                 if name == "linux_banner": continue
                 if name == "vermagic": continue
                 # statics and some other optimizations adds random .NUMBER
_

Patches currently in -mm which might be from ynorov@nvidia.com are

rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch
uaccess-unify-inline-vs-outline-copy_fromto_user-selection.patch
uaccess-minimize-inline_copy_user-related-ifdefery.patch
scripts-bloat-o-meter-ignore-_sdata.patch

