Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8894E3FD12A
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660980; cv=none; b=MXLk5HxxtFwNIud4aTsvIyxELM13UfD9jwr63/NC0F0a4HCatbumul5iOGOPlNaBUflZXPefv136Zwbs42yLIhYxTv76ZFtUkU50he6A9+Tsm7OjGqbCkoFFnz8LaCrkAa7BHD4aJGTyffz8s8nwFUM4TDs4zkFq+uouZgJ0dTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660980; c=relaxed/simple;
	bh=wVFgcnucFDusSRZsEJv8ysSUCEMbwcH7+f2bc13Qpxk=;
	h=Date:To:From:Subject:Message-Id; b=P9FDqzWrkfnIFvCSkNJC+C1UFDPUcgW6reeDH1WqAIA9TE6mW0Rzd9zmhM+aLEpaU2TPN24/C969KXT06GwVDAfPFMri2GVdzmBVxFh3n71Lvv+TzTLu2OGP0awNzOmkLn/uh0C3uWwg2X+h/tGi2WpWF3JdPnrS+rxsIgXlQIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNIepgjc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNIepgjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE3B1F00A3E;
	Thu, 13 Aug 2026 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660979;
	bh=PXt7Fd7VKZocqQzDB8vzpxrfMvhGgJxs4uQfZs3sBaA=;
	h=Date:To:From:Subject;
	b=lNIepgjcNv+FW5O0c+qaRmgkG2IZZM7Xsjn34IDz7s92TtZcTD0u3XWhkdxilcM7F
	 +IYFVW/Fe+ZEWlRzWYw9pwuYhwqDk0dVwLJC6teGZ8CPiXy+guhWKtwOMREUOCZW0J
	 sGb0xChqEQygt58rpA/JSXKHznD6zfg3demceyIk=
Date: Thu, 13 Aug 2026 15:42:58 -0700
To: mm-commits@vger.kernel.org,namcao@linutronix.de,jszhang@kernel.org,joe@perches.com,pjw@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions.patch removed from -mm tree
Message-Id: <20260813224259.5DE3B1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add NOKPROBE_SYMBOL to the whitelist of lines that can occur immediately after functions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-nokprobe_symbol-to-the-whitelist-of-lines-that-can-occur-immediately-after-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


