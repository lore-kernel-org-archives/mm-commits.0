Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81EC3BB9FA
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731618; cv=none; b=Nyqi5eNZ3SdbouLGP8s7eZOhgEUKg1m32O3A5/PuPofkMClw7oln9573HO57Yb7kF3tKwgNFR1BBs9DeGV3Z0KEjX+GSNmQIuFreqvtzvefu5C3pI7FZ1CI1wCKDo/lULt88e7pTGcJHZgUj49fUYYP/0yFKu5fXPneaVyG+bqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731618; c=relaxed/simple;
	bh=yYu3kzk6wI7EEKo4gJhjT2DuXbe91NQkmexdfzBYZbo=;
	h=Date:To:From:Subject:Message-Id; b=jRjxphS4+NxQVEDT9KlQyK9FDFnzVLWjQskXfUmgmnXVLN5xhoSpfF6XJEzuaTOGI2P4vd+Wo2c4W34eK2nrsbpYweyHG8PRpgKHfYaQ05XtijD+K8la5D9pHu01TWfStsmwSesW04kwILDjl9Dx2cS56u8npVlhUhYc125f0gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uxtKjktQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uxtKjktQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673091F0089B;
	Sun, 11 Oct 2026 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791731616;
	bh=ykjT+3gCeToIh3k6ngi7li2krUKwOoFK1EshmFqi89k=;
	h=Date:To:From:Subject;
	b=uxtKjktQEsVMybUs1SWscC+0neKf0jF4dxhkky/LyaxoTWOGwZrgEDroTxPRZFWE5
	 DA6MwGuptFjbh53jrZYCsvBT+e5eOtkrErpVVVnz4zp8PIKbEnPpgM4fAaOMr53YeH
	 pmjwRVRK2nS6dTLE3c7WMM2qjKy8qaiuUg58qHPA=
Date: Sun, 11 Oct 2026 08:13:35 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,thomas.weissschuh@linutronix.de,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,nsc@kernel.org,nathan@kernel.org,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,denis.benato@linux.dev,david.laight.linux@gmail.com,chewi@gentoo.org,andrey.grodzovsky@crowdstrike.com,abelvesa@kernel.org,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch removed from -mm tree
Message-Id: <20261011151336.673091F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
has been removed from the -mm tree.  Its filename was
     kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch

This patch was dropped because it was folded into kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
Date: Thu, 08 Oct 2026 17:19:12 -0600

commit 4fafd1165b33 replaced hardcoded values which determine marker array
size, with new values that accelerate symbol-name lookups.  These symbols
are needed in user-space to generate the lookup tables, and in kernel to
read the generated table.

To avoid 2-defns problem, they were added to a kernel header (with ifdef
guards) and included by scripts/kallsyms.c.  But that creates packaging
problems elsewhere, so just add the 2nd defns, with an explicit comment
about the user-kernel coupling.

Link: https://lore.kernel.org/20261008-fix-kallsyms-v1-1-3339fdac2ab3@gmail.com
Fixes: 4fafd1165b33 ("kallsyms: increase marker density to 16:1 to accelerate lookups")
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Denis Benato <denis.benato@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: James Le Cuirot <chewi@gentoo.org>
Cc: Abel Vesa <abelvesa@kernel.org>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
---

 kernel/kallsyms_internal.h |   12 +++++-------
 scripts/kallsyms.c         |    9 ++++++++-
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/kallsyms_internal.h~kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix
+++ a/kernel/kallsyms_internal.h
@@ -2,18 +2,17 @@
 #ifndef LINUX_KALLSYMS_INTERNAL_H_
 #define LINUX_KALLSYMS_INTERNAL_H_
 
+#include <linux/types.h>
+
 /*
- * Provide compile-constants for scripts/kallsyms.c
- * so it can build the corresponding kallsyms_marker[] table.
- * and wrap the rest in __KERNEL__
+ * These constants determine the size of the kallsyms_markers array
+ * written by scripts/kallsyms.c during the build.  The symbol values
+ * must be kept in sync.
  */
 #define KALLSYMS_MARKER_SHIFT 4
 #define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
 #define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
 
-#ifdef __KERNEL__
-#include <linux/types.h>
-
 extern const int kallsyms_offsets[];
 extern const u8 kallsyms_names[];
 
@@ -24,6 +23,5 @@ extern const u16 kallsyms_token_index[];
 
 extern const unsigned int kallsyms_markers[];
 extern const u8 kallsyms_seqs_of_names[];
-#endif /* __KERNEL__ */
 
 #endif // LINUX_KALLSYMS_INTERNAL_H_
--- a/scripts/kallsyms.c~kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix
+++ a/scripts/kallsyms.c
@@ -29,7 +29,14 @@
 
 #include <xalloc.h>
 
-#include "../kernel/kallsyms_internal.h"
+/*
+ * These constants determine the size of the marker array filled here,
+ * and they're duplicated in kernel/kallsyms.c, where they're used in
+ * get_symbol_offset().  They must be kept in agreement.
+ */
+#define KALLSYMS_MARKER_SHIFT 4
+#define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
+#define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch
kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch
kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

