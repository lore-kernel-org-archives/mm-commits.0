Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D161FE471
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731773; cv=none; b=HJ33NsofV/Pi0+2tiPXjRp5t+Is9vPvLEta4jawQDia3dpNpdwD9N21KEqu6dMPR6FS/5SYyB+LlNqJxay22xsns6vPYC0WcJnBigPbCUS0UF5JFZjhS5gfDNAUo3uFGttyAfVG92Rh7vkctaKPzWohTBgIz2kA3VdKq8/h5/n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731773; c=relaxed/simple;
	bh=9+4vfKWmVqBSrP3cCortuZ+vS/fgbQzuwD2Am7pilSo=;
	h=Date:To:From:Subject:Message-Id; b=UP04hyx1wxWt4r7nIA3utyRtLOeXspXbrOpynfwjvlYo9XeqvnFE2pMlbKe/KhzpHKP3001TGXWQC+pXOPJCcgkRnpD67KfVQDbId3bGmkfK2cBw0mXx6qSqcfgRJml6EU4ZPt3BgC5HLmPzlRJJdi0el446/pjiYSitSf+gR2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZ+tg5p2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZ+tg5p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FC01F0089B;
	Sun, 11 Oct 2026 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791731772;
	bh=SOphisbfgQCvAYjf7JI7hViH7+BTlWsVx1uSsNqVLFE=;
	h=Date:To:From:Subject;
	b=HZ+tg5p2fhdfH3J+QLREPibcaLYU8ueFYpTxck+YVHAnXwXcqeRfnSTiunRsa/qdU
	 xcO5phiNpT/a0Kb0q60UlaiwpWAMfDBI5JyUQzFCpyzsa68MhANV/C2uB/3rcCi9sI
	 ND+x/+QD6KSFY+BDfh01ZDrWZchA8KRxewhp7h1A=
Date: Sun, 11 Oct 2026 08:16:11 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,thomas.weissschuh@linutronix.de,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,nsc@kernel.org,nathan@kernel.org,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,denis.benato@linux.dev,david.laight.linux@gmail.com,chewi@gentoo.org,andrey.grodzovsky@crowdstrike.com,abelvesa@kernel.org,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch removed from -mm tree
Message-Id: <20261011151612.58FC01F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: unroll 24-bit sequence reconstruction in get_symbol_seq()
has been removed from the -mm tree.  Its filename was
     kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kallsyms: unroll 24-bit sequence reconstruction in get_symbol_seq()
Date: Tue, 29 Sep 2026 12:07:32 -0600

kallsyms_seqs_of_names[] stores 3-byte big-endian sequence indices that
map alphabetical symbol positions to address-ordered symbol records. 
Currently, get_symbol_seq() reconstructs each 24-bit integer using a
3-iteration for-loop that shifts and bitwise-ORs each byte sequentially. 
During binary search in kallsyms_lookup_names() and duplicate boundary
scans, this loop introduces branch and loop overhead on the hot lookup
path.

Mark get_symbol_seq() as static inline and unroll the 3-byte extraction
into direct byte shifts: (p[0] << 16) | (p[1] << 8) | p[2].  This
eliminates loop induction variable maintenance and allows the compiler to
generate direct loads and constant shifts.

Link: https://lore.kernel.org/20260929-ksyms-tune-v7-3-be568ceef41e@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kees Cook <kees@kernel.org>
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
Cc: Nicolas Schier <nsc@kernel.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---

 kernel/kallsyms.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/kallsyms.c~kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq
+++ a/kernel/kallsyms.c
@@ -185,14 +185,11 @@ unsigned long kallsyms_sym_address(int i
 	return (unsigned long)offset_to_ptr(kallsyms_offsets + idx);
 }
 
-static unsigned int get_symbol_seq(int index)
+static inline unsigned int get_symbol_seq(int index)
 {
-	unsigned int i, seq = 0;
+	const u8 *p = &kallsyms_seqs_of_names[3 * index];
 
-	for (i = 0; i < 3; i++)
-		seq = (seq << 8) | kallsyms_seqs_of_names[3 * index + i];
-
-	return seq;
+	return (p[0] << 16) | (p[1] << 8) | p[2];
 }
 
 static int kallsyms_lookup_names(const char *name,
_

Patches currently in -mm which might be from jim.cromie@gmail.com are


