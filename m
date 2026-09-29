Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C0F5581EC
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790707707; cv=none; b=dY57c5ESH9kvrZzK5EVMyBeE7j4g+8K4DErataM10bNBGhZAayUlXEAtxBPeoQjjcn6Ii20apcfJTpugveXKzc+LL3T8Oezt4UoHTTOdsxH+mxnQy6RGrCyoSTlW8e7uCqC1eue0nh7S27LzxM08Vl/PIZnXM/lUeOWwH5Mw4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790707707; c=relaxed/simple;
	bh=GUA9llvrMMHr74I/pUhhh1ZUeVl8/jMJ2TjlhKTywvc=;
	h=Date:To:From:Subject:Message-Id; b=LT8Qm4AW5HRVZh3zxHV0MWVsZWMqZffpqVulWNWTJOSLWdoGg0IRJQKZikBRPPU/CoGqWp2mgrCAs2mWXbu4GPTv4pgLsWViuRInxBrCV7uqJciV1/HWnsjW4U7m0YZHS5E1SUBnBMp8dzpNH/ie2YxdpZ8lY5F222s/hwEcWJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYmRqCHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYmRqCHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36BE1F00893;
	Tue, 29 Sep 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790707705;
	bh=tDYnIIYM/xavabULHhVtYr65wDV8NjMYtlm+A4yRCZ0=;
	h=Date:To:From:Subject;
	b=EYmRqCHOQpPgFWVC6mDljVSoxVXJJZQ9AaJdS7lIAXSKeqWMK8VB4rPoca8mUJ878
	 go4Hu+Aiq7YWAC18MUmloY+8DdhfVuXupjlAfO7E5AI6fQwXb+KFSGES6D1dv77ljG
	 GiabkgmcfJs2+ChAgufLNtt/jCA7UDw8+w347EpI=
Date: Tue, 29 Sep 2026 11:48:24 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,david.laight.linux@gmail.com,andrey.grodzovsky@crowdstrike.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch added to mm-nonmm-unstable branch
Message-Id: <20260929184824.F36BE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: match compressed tokens on the fly during binary search
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch

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
Subject: kallsyms: match compressed tokens on the fly during binary search
Date: Tue, 29 Sep 2026 12:07:30 -0600

Patch series "kallsyms: Accelerate symbol name lookups by ~7x", v7.

In 2022, commit 60443c88f3a8 ("kallsyms: Improve the performance of
kallsyms_lookup_name()") introduced kallsyms_seqs_of_names[] (+550 KiB
.rodata), transforming an O(N) linear scan into an O(log N) binary search
(5.2 ms -> ~7.2 us).  While this was a major step forward, the binary
search inner loop was left decompressing full candidate names and scanning
across sparse 256:1 markers on every probe.

Modern fleet observability, security daemons (e.g.  CrowdStrike Falcon,
Cilium, Datadog, Falco), and tracing tools resolve thousands of kernel
functions by name at boot or service start.

CrowdStrike recently hit this in production:

commit 93e8fd1a565e ("ftrace: Use kallsyms binary search for single-symbol lookup")

Attaching just 50 kprobe.session programs caused an 858 ms attach stall
with 25% CPU burned in kallsyms.  That commit routed single-symbol libbpf
attach directly to kallsyms_lookup_name().  In larger workloads (such as
the BPF selftest serial_test_kprobe_multi_bench_attach across 64,000
symbols), kallsyms_lookup_names() spends ~390 ms in raw CPU spin.

This series accelerates kallsyms_lookup_names() by 7.0x (from 6,102 ns
down to 866 ns per lookup), cutting 64k-symbol attach from ~390 ms to ~55
ms, by fixing two inner-loop bottlenecks:

0. Candidate symbols are fully decompressed into a 512-byte stack buffer
   before calling strcmp(), even though ~16 of the 17 search steps
   mismatch at the first differing character (0..N-1, heavily
   front-loaded toward 0-2).

1. Probes scan sequentially from 256:1 markers in kallsyms_names[],
   decoding an average of 127.5 symbols per probe (~2,170 hops across a
   17-step search).

The 3-patch progression:

0. Patch 1 introduces kallsyms_strcmp_symbol() to compare ASCII queries
   against compressed tokens on the fly, bailing out on first mismatch.
   Drops the 512-byte stack buffer and saves ~530 ns.

1. Patch 2 increases marker density from 256:1 to 16:1, cutting average
   scan distance from 127.5 to 7.5 hops and dropping lookup latency from
   6,102 ns to 866 ns for +42.2 KiB of .rodata.

2. Patch 3 inlines and unrolls get_symbol_seq() 24-bit reconstruction.

Results (CONFIG_KALLSYMS_SELFTEST across ~184k symbols):
- Baseline (256:1):  6,102 ns
- Patch 1 (strcmp):  5,572 ns (-530 ns)
- Patch 2 (16:1):      866 ns (7.0x faster)

Trade-offs:
- .rodata footprint: +42.2 KiB (+10,782 u32 entries for ~184k symbols,
  ~0.1% of loaded kernel image).
- Runtime overhead: 0 bytes dynamic RAM (no kmalloc/kvmalloc), 0 RCU,
  0 new locks, and 0 new algorithms.
- Kernel stack: -512 bytes freed in kallsyms_lookup_names().
- Build tooling: scripts/kallsyms.c includes
  ../kernel/kallsyms_internal.h (guarded by #ifdef __KERNEL__) so host
  build and kernel runtime share KALLSYMS_MARKER_SHIFT 4 as a single
  source of truth.
- Build time: Unmeasurable delta (< 1 ms in scripts/kallsyms.c).

What's Unchanged:
- Symbol table layout in address order remains identical.
- Streaming decompression for /proc/kallsyms and sprint_symbol() is
  untouched.
- 0 new user-facing APIs, 0 new locking primitives, 0 Kconfig options.


This patch (of 3):

kallsyms_lookup_names() runs a binary search across ~184k tokenized
(compressed) symbols.  For each of the ~17 comparisons in the search, it
currently decompresses the candidate symbol into a temporary buffer on the
stack before calling strcmp().

Comparing tokenized symbols directly in compressed space is impossible. 
The BPE token table assigns values by frequency, not alphabetical order
(e.g.  token 0x05 might expand to "zebra" while 0x42 expands to "apple"),
so comparing raw token values scrambles lexicographical order.  Even
sorting the token table alphabetically wouldn't help; "bpf_" and
"bpf_foo_" do not *have* a determinative sorting order, because the
suffixes following those tokens would matter.

However, full string expansion at every step is equally wasteful: of the
~17 strcmps in the binary search, only the last needs to check all N chars
in both strings, earlier steps will know +/- outcome at char 0,1,2..N-1.

However, full string expansion at every step is equally wasteful: of the
~17 strcmp()s in the binary search, only the final matching step needs to
test all characters.  Earlier non-matching steps diverge at the first
differing character (0..N-1), but the baseline expands every candidate
symbol to the stack unconditionally, before comparing.

So we introduce kallsyms_strcmp_symbol() to compare ASCII search_name
against tokenized symbols on the fly.  Like strcmp, it tests the strings
char by char, but when it hits a token in the symbol-string, it continues
the char-test against that token-string, which is in
kallsyms_token_table[].  It returns +- on 1st mismatch.

Measured across all ~184k symbols via CONFIG_KALLSYMS_SELFTEST, this
shaves ~530 ns (~14%) off average kallsyms_lookup_name() latency (from
~3810 ns to ~3280 ns on the default 256:1 baseline) and drops the 512-byte
namebuf buffer stack-alloc in kallsyms_lookup_names().

Link: https://lore.kernel.org/20260929-ksyms-tune-v7-0-be568ceef41e@gmail.com
Link: https://lore.kernel.org/20260929-ksyms-tune-v7-1-be568ceef41e@gmail.com
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

 kernel/kallsyms.c |   94 +++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 35 deletions(-)

--- a/kernel/kallsyms.c~kallsyms-match-compressed-tokens-on-the-fly-during-binary-search
+++ a/kernel/kallsyms.c
@@ -35,6 +35,21 @@
 #include "kallsyms_internal.h"
 
 /*
+ * Get the compressed symbol length and data pointer.
+ */
+static inline const u8 *get_symbol_data(unsigned int off, unsigned int *len)
+{
+	const u8 *p = &kallsyms_names[off];
+	unsigned int l = *p++;
+
+	if (unlikely(l & 0x80))
+		l = (l & 0x7F) | (*p++ << 7);
+	*len = l;
+
+	return p;
+}
+
+/*
  * Expand a compressed symbol data into the resulting uncompressed string,
  * if uncompressed string is too long (>= maxlen), it will be truncated,
  * given the offset to where the symbol is in the compressed stream.
@@ -42,28 +57,12 @@
 static unsigned int kallsyms_expand_symbol(unsigned int off,
 					   char *result, size_t maxlen)
 {
-	int len, skipped_first = 0;
+	int skipped_first = 0;
 	const char *tptr;
-	const u8 *data;
+	unsigned int len;
+	const u8 *data = get_symbol_data(off, &len);
 
-	/* Get the compressed symbol length from the first symbol byte. */
-	data = &kallsyms_names[off];
-	len = *data;
-	data++;
-	off++;
-
-	/* If MSB is 1, it is a "big" symbol, so needs an additional byte. */
-	if ((len & 0x80) != 0) {
-		len = (len & 0x7F) | (*data << 7);
-		data++;
-		off++;
-	}
-
-	/*
-	 * Update the offset to return the offset for the next symbol on
-	 * the compressed stream.
-	 */
-	off += len;
+	off = (data - kallsyms_names) + len;
 
 	/*
 	 * For every byte on the compressed symbol data, copy the table
@@ -101,14 +100,43 @@ tail:
  */
 static char kallsyms_get_symbol_type(unsigned int off)
 {
-	/*
-	 * Get just the first code, look it up in the token table,
-	 * and return the first char from this token. If MSB of length
-	 * is 1, it is a "big" symbol, so needs an additional byte.
-	 */
-	if (kallsyms_names[off] & 0x80)
-		off++;
-	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off + 1]]];
+	unsigned int len;
+	const u8 *data = get_symbol_data(off, &len);
+
+	return kallsyms_token_table[kallsyms_token_index[*data]];
+}
+
+/*
+ * Compare an uncompressed ASCII string against a compressed symbol table entry.
+ * Returns negative if name < sym, positive if name > sym, 0 if equal.
+ * Exits immediately on the first mismatched character without decompressing
+ * the rest of the symbol name.
+ */
+static int kallsyms_strcmp_symbol(unsigned int off, const char *name)
+{
+	const char *tptr;
+	unsigned int len;
+	const u8 *data = get_symbol_data(off, &len);
+
+	tptr = &kallsyms_token_table[kallsyms_token_index[*data++]] + 1;
+	while (*tptr) {
+		int diff = (unsigned char)*name++ - (unsigned char)*tptr++;
+
+		if (diff)
+			return diff;
+	}
+
+	while (--len) {
+		tptr = &kallsyms_token_table[kallsyms_token_index[*data++]];
+		do {
+			int diff = (unsigned char)*name++ - (unsigned char)*tptr++;
+
+			if (diff)
+				return diff;
+		} while (*tptr);
+	}
+
+	return (unsigned char)*name;
 }
 
 
@@ -174,7 +202,6 @@ static int kallsyms_lookup_names(const c
 	int ret;
 	int low, mid, high;
 	unsigned int seq, off;
-	char namebuf[KSYM_NAME_LEN];
 
 	low = 0;
 	high = kallsyms_num_syms - 1;
@@ -183,8 +210,7 @@ static int kallsyms_lookup_names(const c
 		mid = low + (high - low) / 2;
 		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
-		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = strcmp(name, namebuf);
+		ret = kallsyms_strcmp_symbol(off, name);
 		if (ret > 0)
 			low = mid + 1;
 		else if (ret < 0)
@@ -200,8 +226,7 @@ static int kallsyms_lookup_names(const c
 	while (low) {
 		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
-		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		if (strcmp(name, namebuf))
+		if (kallsyms_strcmp_symbol(off, name) != 0)
 			break;
 		low--;
 	}
@@ -212,8 +237,7 @@ static int kallsyms_lookup_names(const c
 		while (high < kallsyms_num_syms - 1) {
 			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
-			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-			if (strcmp(name, namebuf))
+			if (kallsyms_strcmp_symbol(off, name) != 0)
 				break;
 			high++;
 		}
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch
kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch
kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

