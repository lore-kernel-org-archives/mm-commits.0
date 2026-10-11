Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B99405F7
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731770; cv=none; b=r5rUcGNyeoqbV2g1CAT6iRKuPAxov7NyFv61RIeefpw+W6vyjfA8igFFWjHFxHRBoWEaFxYkoxlF+UNBmE/b2oBoeiEfAf+dp4tXwXv56KR7jLaIanISssFgYv7+jsEOdCMXPAGCqX7jvy1TI9QlT4sF4nUfU/gVwI5H/IvzBbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731770; c=relaxed/simple;
	bh=4EFccj522AuTOLgNuFSnmEYQ3XwcIJ+DZTL8rVGkvxM=;
	h=Date:To:From:Subject:Message-Id; b=VtZI71EJOv3i1XSR5a9IWQQxx/qsRjUBVb59gRnvARWtgHBHJlLsKtzg+1kOMi3BEBrnXmALUPV+rmZAhcDvIaf0eswesSYdKniNNKYY0I3nKFMaMmu4XXxfLBWkhfAfLdw8OSobFbCksmdIqngP4JNlu5xnYFJ+IcFqP9Fr42Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mq4aiNIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mq4aiNIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEA31F0089C;
	Sun, 11 Oct 2026 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791731769;
	bh=BvdPPmwLAWnfbfnVJEU5aFoHZ2CsJEtOZttSKrDGDTg=;
	h=Date:To:From:Subject;
	b=Mq4aiNIqxfW1MFWpNe2And7AZsCg7OLeSCb9C1qO60ZnpWKhiaZBraZ4M147eql0D
	 HAUrno8GLnPoUgZDQbzokqV+TT1Xrb2Xpqxx4/DHFeZ+kPGQ4hyt2/HSJzE9GiRyCJ
	 KJR5vFOy3qFerAFu7FYdjZEZ8HNjewnFHCRFoc6A=
Date: Sun, 11 Oct 2026 08:16:08 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,thomas.weissschuh@linutronix.de,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,nsc@kernel.org,nathan@kernel.org,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,denis.benato@linux.dev,david.laight.linux@gmail.com,chewi@gentoo.org,andrey.grodzovsky@crowdstrike.com,abelvesa@kernel.org,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch removed from -mm tree
Message-Id: <20261011151608.DCEA31F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: increase marker density to 16:1 to accelerate lookups
has been removed from the -mm tree.  Its filename was
     kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch

This patch was dropped because an updated version will be issued

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

[jim.cromie@gmail.com: copy constants from __KERNEL__ to user, drop inclusion]
  Link: https://lore.kernel.org/20261008-fix-kallsyms-v1-1-3339fdac2ab3@gmail.com
Link: https://lore.kernel.org/20260929-ksyms-tune-v7-2-be568ceef41e@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Tested-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Abel Vesa <abelvesa@kernel.org>
Cc: Denis Benato <denis.benato@linux.dev>
Cc: James Le Cuirot <chewi@gentoo.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---

 kernel/kallsyms.c          |    8 ++++----
 kernel/kallsyms_internal.h |    9 +++++++++
 scripts/kallsyms.c         |   21 ++++++++++++++++-----
 3 files changed, 29 insertions(+), 9 deletions(-)

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
@@ -4,6 +4,15 @@
 
 #include <linux/types.h>
 
+/*
+ * These constants determine the size of the kallsyms_markers array
+ * written by scripts/kallsyms.c during the build.  The symbol values
+ * must be kept in sync.
+ */
+#define KALLSYMS_MARKER_SHIFT 4
+#define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
+#define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
+
 extern const int kallsyms_offsets[];
 extern const u8 kallsyms_names[];
 
--- a/scripts/kallsyms.c~kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups
+++ a/scripts/kallsyms.c
@@ -29,6 +29,15 @@
 
 #include <xalloc.h>
 
+/*
+ * These constants determine the size of the marker array filled here,
+ * and they're duplicated in kernel/kallsyms.c, where they're used in
+ * get_symbol_offset().  They must be kept in agreement.
+ */
+#define KALLSYMS_MARKER_SHIFT 4
+#define KALLSYMS_MARKER_SIZE  (1U << KALLSYMS_MARKER_SHIFT)
+#define KALLSYMS_MARKER_MASK  (KALLSYMS_MARKER_SIZE - 1U)
+
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
 #define KSYM_NAME_LEN		512
@@ -349,16 +358,18 @@ static void write_src(void)
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

kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

