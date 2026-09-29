Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9D0559C80
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790707709; cv=none; b=ZB5Uvd4EKn1x7HOuvRQA71xCYmiKTe+TECEKEU0yNwDIaHIYDTt4soSnKUXG0UCyjRMsIwCda5rsSsSO6r0Jx+DZltZW5tNk04CjGL3reNlOWckgRXXF61GFMRT7adnPTA2XMO16/l/80nl7cwS+fQlMwEmg6COdBgg/9azX9SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790707709; c=relaxed/simple;
	bh=QYVz8r/w3HbQcysmBslBm8lHsQ+fmP8ni4nH/LPKUm0=;
	h=Date:To:From:Subject:Message-Id; b=QvklS76SagiUoJgjK0UzFharQGPAdcJ0uz4BnXlCGEM6ce4iF3ymtijdBCuuAdyDZuKlX3fS/ya6PRtdyDkhLG6naH73g642Csri4A/XBNYhwa19cRpE8kkauZ13LqNUALTpCtKTeZptRaR82N8H6o7VhpOr9m94r2m7ju7c0bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZVn9yozF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVn9yozF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129311F00898;
	Tue, 29 Sep 2026 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790707707;
	bh=8asgKdPFSeUynOBXlSs5e2xOI0KNmyT5zt990r6pPcQ=;
	h=Date:To:From:Subject;
	b=ZVn9yozF9wuLGiFX/yqKoclyepCnJcBF2twbL1fgt6tcJfDS86Xz/W6fSvOar5b0w
	 cAsrxe3ulf5460pgpAnqCjEXwWT4twhpAJeF47yGLQNciY9JoO1jafJ7XTYh4u3VGJ
	 J0EG18EuBz0s/vWzEqCQnLsdBqjGzaZTcQcTd2+4=
Date: Tue, 29 Sep 2026 11:48:26 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,david.laight.linux@gmail.com,andrey.grodzovsky@crowdstrike.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch added to mm-nonmm-unstable branch
Message-Id: <20260929184827.129311F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: increase marker density to 16:1 to accelerate lookups
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch

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
Subject: kallsyms: increase marker density to 16:1 to accelerate lookups
Date: Tue, 29 Sep 2026 12:07:31 -0600

kallsyms stores symbols with remarkably efficient packing, and simple
streaming unpacking, laid out sequentially in address order.  That said,
variable-length records make arbitrary access inherently linear. 
kallsyms_markers[] addressed this by marking stream offsets every 256
symbols, reducing the scan distance by 256x down to an average of 127.5
sequential steps.

While 127.5 hops was negligible for rare, single-shot oops backtraces,
both table size (~184k symbols) and lookup traffic have expanded
substantially.  In alphabetical binary search (kallsyms_lookup_names),
each of the ~17 comparison probes must locate candidate symbols via
get_symbol_offset(), compounding into ~2,170 sequential symbol hops per
lookup.  In bulk tracing workloads (such as BPF multi-kprobe attach), this
penalty compounds into multi-second latency.

Without altering the underlying storage layout, we can retune this
trade-off directly by increasing marker density from 256:1 down to 16:1
(KALLSYMS_MARKER_SHIFT 4) in kernel/kallsyms_internal.h, shared between
scripts/kallsyms.c and kernel/kallsyms.c.

This caps the remainder scan at 15 symbols and cuts average scan distance
from 127.5 down to 7.5 hops (a 17x reduction).  Across a 17-step binary
search, total hops collapse from ~2,170 down to ~127.  For a kernel with
~184,000 symbols, this adds ~10,800 u32 marker entries (+42 KiB) to
write-protected .rodata.

In-tree CONFIG_KALLSYMS_SELFTEST measurements across all ~184k symbols
show average lookup latency dropping from 6,102 ns down to 866 ns (a 7.0x
speedup).

Link: https://lore.kernel.org/20260929-ksyms-tune-v7-2-be568ceef41e@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---

 kernel/kallsyms.c          |    8 ++++----
 kernel/kallsyms_internal.h |   11 +++++++++++
 scripts/kallsyms.c         |   14 +++++++++-----
 3 files changed, 24 insertions(+), 9 deletions(-)

--- a/kernel/kallsyms.c~kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups
+++ a/kernel/kallsyms.c
@@ -150,10 +150,10 @@ static unsigned int get_symbol_offset(un
 	int i, len;
 
 	/*
-	 * Use the closest marker we have. We have markers every 256 positions,
-	 * so that should be close enough.
+	 * Use the closest marker we have. We have markers every
+	 * (1 << KALLSYMS_MARKER_SHIFT) positions, so that should be close enough.
 	 */
-	name = &kallsyms_names[kallsyms_markers[pos >> 8]];
+	name = &kallsyms_names[kallsyms_markers[pos >> KALLSYMS_MARKER_SHIFT]];
 
 	/*
 	 * Sequentially scan all the symbols up to the point we're searching
@@ -161,7 +161,7 @@ static unsigned int get_symbol_offset(un
 	 * so we just need to add the len to the current pointer for every
 	 * symbol we wish to skip.
 	 */
-	for (i = 0; i < (pos & 0xFF); i++) {
+	for (i = 0; i < (pos & KALLSYMS_MARKER_MASK); i++) {
 		len = *name;
 
 		/*
--- a/kernel/kallsyms_internal.h~kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups
+++ a/kernel/kallsyms_internal.h
@@ -2,6 +2,16 @@
 #ifndef LINUX_KALLSYMS_INTERNAL_H_
 #define LINUX_KALLSYMS_INTERNAL_H_
 
+/*
+ * Provide compile-constants for scripts/kallsyms.c
+ * so it can build the corresponding kallsyms_marker[] table.
+ * and wrap the rest in __KERNEL__
+ */
+#define KALLSYMS_MARKER_SHIFT 4
+#define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
+#define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
+
+#ifdef __KERNEL__
 #include <linux/types.h>
 
 extern const int kallsyms_offsets[];
@@ -14,5 +24,6 @@ extern const u16 kallsyms_token_index[];
 
 extern const unsigned int kallsyms_markers[];
 extern const u8 kallsyms_seqs_of_names[];
+#endif /* __KERNEL__ */
 
 #endif // LINUX_KALLSYMS_INTERNAL_H_
--- a/scripts/kallsyms.c~kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups
+++ a/scripts/kallsyms.c
@@ -29,6 +29,8 @@
 
 #include <xalloc.h>
 
+#include "../kernel/kallsyms_internal.h"
+
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
 #define KSYM_NAME_LEN		512
@@ -349,16 +351,18 @@ static void write_src(void)
 	printf("\t.long\t%u\n", table_cnt);
 	printf("\n");
 
-	/* table of offset markers, that give the offset in the compressed stream
-	 * every 256 symbols */
-	markers_cnt = (table_cnt + 255) / 256;
+	/*
+	 * Table of offset markers, giving the offset in the compressed stream
+	 * every (1 << KALLSYMS_MARKER_SHIFT) symbols.
+	 */
+	markers_cnt = (table_cnt + KALLSYMS_MARKER_MASK) >> KALLSYMS_MARKER_SHIFT;
 	markers = xmalloc(sizeof(*markers) * markers_cnt);
 
 	output_label("kallsyms_names");
 	off = 0;
 	for (i = 0; i < table_cnt; i++) {
-		if ((i & 0xFF) == 0)
-			markers[i >> 8] = off;
+		if ((i & KALLSYMS_MARKER_MASK) == 0)
+			markers[i >> KALLSYMS_MARKER_SHIFT] = off;
 		table[i]->seq = i;
 
 		/* There cannot be any symbol of length zero. */
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch
kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch
kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

