Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5060413B58F
	for <mm-commits@vger.kernel.org>; Sun, 10 Nov 2024 06:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731219015; cv=none; b=aR8NJV5Y74uIZivvAutxKw8KwHQ0R30zRlS3JQ7+hByBYazTjHabMj5K7hB2X94h/KImAZPMCwFvXCbXd4H8KtPDL+daBTu91RamGklPp/+xZcR7eSwEs3l70YqkfT+1YD4UBaJn2uuUcRdL/DjhL9XszgJANABprxSb+KN1OBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731219015; c=relaxed/simple;
	bh=yyX5nly/7zLHCbl+YCd3cM9RepR8uKkVVFqbtsektJQ=;
	h=Date:To:From:Subject:Message-Id; b=UsrekvRDIfz/nwhDLx7eyuRaaoyXQdduQVIS3RijAAK+rEGWzo2wVlimaVZhUvFwC/dWrnOh5hqb4zYOMgNpbQ1WYrVpeKAkToQJUmXYglTOwZbViEklAxvHO5itcopzWZ0PGXtpZJGcrJiNaw1w6McVeOuN1GJKOBlO4rm8Lms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=REndoYlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="REndoYlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86A2C4CECD;
	Sun, 10 Nov 2024 06:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731219014;
	bh=yyX5nly/7zLHCbl+YCd3cM9RepR8uKkVVFqbtsektJQ=;
	h=Date:To:From:Subject:From;
	b=REndoYlw2Tq2SNe0CY8LJ0Y1aFyGylTLzQ/Gta/7V0BIPCugxu3P+g/PADNZTR0IR
	 /0rNu0z32JzM+LJQo3EdGwAd7RYRZ+cMednh+gzMvfeIeSCDI2Bsvrp9xeMcRCkANj
	 trkfRPCZbPMwfLuwH0MSIPvqyxwKMHC5IhjCcZ7o=
Date: Sat, 09 Nov 2024 22:10:14 -0800
To: mm-commits@vger.kernel.org,kbingham@kernel.org,andrewjballance@gmail.com,etienne.buira@free.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gdb-lx-symbols-do-not-error-out-on-monolithic-build.patch added to mm-nonmm-unstable branch
Message-Id: <20241110061014.C86A2C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gdb: lx-symbols: do not error out on monolithic build
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     gdb-lx-symbols-do-not-error-out-on-monolithic-build.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gdb-lx-symbols-do-not-error-out-on-monolithic-build.patch

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
From: Etienne Buira <etienne.buira@free.fr>
Subject: gdb: lx-symbols: do not error out on monolithic build
Date: Fri, 8 Nov 2024 17:45:32 +0100

This avoids spurious message:
(gdb) lx-symbols
loading vmlinux
No source file named kernel/module/main.c.

Link: https://lkml.kernel.org/r/Zy5ALByQtpO-ddh4@Z926fQmE5jqhFMgp6
Signed-off-by: Etienne Buira <etienne.buira@free.fr>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |    3 +++
 scripts/gdb/linux/symbols.py |    3 +++
 2 files changed, 6 insertions(+)

--- a/scripts/gdb/linux/modules.py~gdb-lx-symbols-do-not-error-out-on-monolithic-build
+++ a/scripts/gdb/linux/modules.py
@@ -19,6 +19,9 @@ from linux import cpus, utils, lists, co
 module_type = utils.CachedType("struct module")
 
 
+def has_modules():
+    return utils.gdb_eval_or_none("modules") is not None
+
 def module_list():
     global module_type
     modules = utils.gdb_eval_or_none("modules")
--- a/scripts/gdb/linux/symbols.py~gdb-lx-symbols-do-not-error-out-on-monolithic-build
+++ a/scripts/gdb/linux/symbols.py
@@ -178,6 +178,9 @@ lx-symbols command."""
 
         self.load_all_symbols()
 
+        if not modules.has_modules():
+            return
+
         if hasattr(gdb, 'Breakpoint'):
             if self.breakpoint is not None:
                 self.breakpoint.delete()
_

Patches currently in -mm which might be from etienne.buira@free.fr are

gdb-lx-symbols-do-not-error-out-on-monolithic-build.patch

