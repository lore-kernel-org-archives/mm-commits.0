Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8552717A303
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 00:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791678222; cv=none; b=WgZ2LDBowuOES08yMS7oUYwN7e4HFYvEsmeprLvRUIp9dhrNeJRSwP0okNzfpkswQgSzHfB7cnv8MdtOK9URenA0iaHkRAoKI+BP0AvTfs3lTkR/urBe/cIzLNOU0OsJi+YVnlVAE64NFxi5zYYRH22KGGrm6yXDdU8uV9+LyqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791678222; c=relaxed/simple;
	bh=AcwOp3aGLitxxEdc/RECGK+M9tkKgGv7Kyn8vWjAG6M=;
	h=Date:To:From:Subject:Message-Id; b=O45E7SShyljVKexXFfJ+Amph2Crd+lIwRHeTER5d9FJ9fAn0aEfuixytzEUbYGJLfWQ2gm6coCAOLTuaWgKlTxounIIUewq5y1fDS0u8K0QU7DkHhyoADwSlzKwRf7l22KzF8MiPwQmhW+fce7k5bMk7imS1ldLmmO3YoFlei2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HruHOTqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HruHOTqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44771F000FF;
	Sun, 11 Oct 2026 00:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791678221;
	bh=dHnxIcRWydVuf7h1zetdXXsPSc4JCxfxscKOXCai6Lo=;
	h=Date:To:From:Subject;
	b=HruHOTqqMB8vpKwicHpWDbGSAyhau2gSCYyuNRGuuVTcYLlu5eoQ3E5i5X0q8lW9a
	 1Jb4OqpDEev8LJo5T3Mypr8GVtWsL/QJFhKuD62i9Nvg8Q1wzCY0wlwtZyoD4BxeSO
	 cIHztO/icT7LlsPegHgwCPl5sE3I7OMMiGqmRHT8=
Date: Sat, 10 Oct 2026 17:23:40 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,thomas.weissschuh@linutronix.de,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,nsc@kernel.org,nathan@kernel.org,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,denis.benato@linux.dev,david.laight.linux@gmail.com,chewi@gentoo.org,andrey.grodzovsky@crowdstrike.com,abelvesa@kernel.org,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261011002340.E44771F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch

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
kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

