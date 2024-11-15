Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960731885BF
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 06:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653506; cv=none; b=TIYR6ByhyimjRwDELXaSOW5OUp1ZKvdkO7H+/QmOnaJ6eRootoqIu230KLV1sBFdMnMHSPDXg34nf0yriNYfDxJQWnKF8mnRVjDaFiE/m5YDdPym+EFzgGW0ljVW/qtnYwybPzHzbUX6GL5haAKv5mwzy5nNHT4aDI/T3t/Cr+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653506; c=relaxed/simple;
	bh=l1PyteM5EC/zqQZkVxVuRNjX+JunWnkAjsvJYsDlPLU=;
	h=Date:To:From:Subject:Message-Id; b=gIZS9aBy4947hCHf5V7zJhBsj475oxTECNJ6dSwya2aybGGSx+WkIhdnP2UTZsjkWcofH1vbGOk3klRz/cYVYJ0Wj3X/0IrxI6HOINdDRs3hhcMAlQzEELUVtZN3nXLGTCMmIZ3y3qbOWlyt+Hs25YhyDvflBt8XP6j3oq4oRKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWpEJm6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWpEJm6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DAAC4CED0;
	Fri, 15 Nov 2024 06:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653506;
	bh=l1PyteM5EC/zqQZkVxVuRNjX+JunWnkAjsvJYsDlPLU=;
	h=Date:To:From:Subject:From;
	b=tWpEJm6aDxsQFfkE/viqd7BxosTNL02dWHxXB4Muk0WbFxutkp3X99YkQ1vKZSnBJ
	 mVDwABw/kHUvXFqiBKwDjnsm/gJn4S2bUkMu7WZDIH7mRvJaf8BU8DCk8LqE17BKDu
	 WBOyC2r+ruijqC7bt0Iz8m+m2CypSsMceUjc9qzs=
Date: Thu, 14 Nov 2024 22:51:43 -0800
To: mm-commits@vger.kernel.org,kbingham@kernel.org,andrewjballance@gmail.com,etienne.buira@free.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] gdb-lx-symbols-do-not-error-out-on-monolithic-build.patch removed from -mm tree
Message-Id: <20241115065145.E1DAAC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gdb: lx-symbols: do not error out on monolithic build
has been removed from the -mm tree.  Its filename was
     gdb-lx-symbols-do-not-error-out-on-monolithic-build.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


