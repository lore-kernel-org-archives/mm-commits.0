Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B803F39E4
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786139878; cv=none; b=iqPgcCmtr/qnukTGIRIkZOX3QfCZjOuEQTm7JPa9tZyMVD/k3PUpa+H/HR5pgRZNGUlTkn8fXk19GIIBVj/lTThiTT8fDMB6Uqu1exkUnqJcVKR/dSCZj/dxE1qF9l4zk+3XMJhtla+6MAWG9dS76jk2u1Ogr53LVyYkKMasobE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786139878; c=relaxed/simple;
	bh=bP/uk6FdRA0AyTkuJZqBvFXkYxI+xkUZ4Z6nOrTiSi8=;
	h=Date:To:From:Subject:Message-Id; b=jOg7jJzZZbi9phsbTg6UHTxLi0nExZ1eClrMtba7A7Pr1UvCcgxbGZzLr2KaRHvboRuW1YPDc6RbW0mhTPOU+Vml61liSBzulC70dSSx4rDdJ60J+gQf5R5d3GhkgGPess8EbLujnNRwUa8ROYDt9ArDnU+pX+X/0XGL5/1s2E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TLshpeWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TLshpeWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316C01F000E9;
	Fri,  7 Aug 2026 21:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786139876;
	bh=/+FNT/LQddpHOoyHlUv4BTje2U5l8duF/sv+IewQYwE=;
	h=Date:To:From:Subject;
	b=TLshpeWrPW9ZQF97KtOxzKEEygizZj5fj+Q6b4y0rq/oi/QLNnIdbYHECJ4Auvsk8
	 yVLeBRypw0lxxVWHrZZaHOwOsCoPrSL6DL3XKgocUx7sPIZwh0D3PCcNiTmnBK4QUL
	 O+oXLiCsJk8b14xErPGR5qbr/cuCzNcM9ZwiyJcY=
Date: Fri, 07 Aug 2026 14:57:55 -0700
To: mm-commits@vger.kernel.org,namcao@linutronix.de,jszhang@kernel.org,joe@perches.com,pjw@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20260807215756.316C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add NOKPROBE_SYMBOL to the whitelist of lines that can occur immediately after functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions.patch

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
From: Paul Walmsley <pjw@kernel.org>
Subject: checkpatch: add NOKPROBE_SYMBOL to the whitelist of lines that can occur immediately after functions
Date: Thu, 6 Aug 2026 19:00:47 -0600 (MDT)

It's customary for NOKPROBE_SYMBOL() macro usage to appear immediately
after a function's final closing brace, but checkpatch doesn't know that
yet.  As a result, checkpatch --strict incorrectly flags this common
kernel pattern, e.g.,

CHECK: Please use a blank line after function/struct/union/enum declarations
33: FILE: arch/riscv/kernel/traps.c:273:
 }
+NOKPROBE_SYMBOL(probe_single_step_handler);

Fix by adding NOKPROBE_SYMBOL to the whitelist of patterns that are
cleared to appear immediately after functions.

Link: https://lore.kernel.org/130be7db-6098-86a4-60fe-0c1a5d9e30ba@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checkpatch.pl~checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions
+++ a/scripts/checkpatch.pl
@@ -4154,6 +4154,7 @@ sub process {
 		      $line =~ /^\+[a-z_]*init/ ||
 		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
 		      $line =~ /^\+\s*DECLARE/ ||
+		      $line =~ /^\+\s*NOKPROBE_SYMBOL/ ||
 		      $line =~ /^\+\s*builtin_[\w_]*driver/ ||
 		      $line =~ /^\+\s*__setup/)) {
 			if (CHK("LINE_SPACING",
_

Patches currently in -mm which might be from pjw@kernel.org are

checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions.patch

