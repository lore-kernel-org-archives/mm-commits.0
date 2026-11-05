Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899170;
	b=yyJibi/ahuklp/t0f4yzBFwYlZ2TaREdc5fS8BYKH0iZc4m3gPF7w6GVtk8zgkasAcdf
	 9Kt1m86xrlMKq60rq+AvAtbwMXb/EaiqFLn/XiGgGQYiHT+fusJAU7GmMJK2vMuIpwUWn
	 Lbe/feQ1nuySfaGnSgho6nWySww83L2IJYgQpjGmj9hOJ3aLsG6jTlrYcwDKlH4HVeqaT
	 FXjTZgk2kmhfqOynU9cn5oTWk8NQ6oYXD0VyDIuUkYGd6JpM71qWiKhS+gGC2tPMqKw79
	 b/4FYy42Rse/KrxPye8XizuuXsG5pSX34rdJ4em4DQchMzwod1mSNyV9iJHD6RzaKew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899170;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=W+nNccDp268JIC0BhTvaKbToCLbCGRj8XbTak0dCb7g=;
	b=bhg4jwFLJyVa2qQYeHH+L6XDWi/2WPpPjNAKWpGE7gC7mkF4B52LAhj4ShMCpBaFo1OL
	 8keq2+hKDUpoEwkXvH+9PDORsbi3q3wRYxNUx+u0LPQg6pVLlnXJa89vvA9LjUWPWIVvK
	 JjsRgE5gHIeqiSNkAftBqxYW4bwCmlI1eVEZkBendY6/2s/WX/QoNvpmfQTxrwvvQRjeX
	 /1OQz66WNKUnNc1uAk0a0yYf3T0nIMZcjvM4dcGJraixaNx2626hWNCcDzh/tDzbPOO/C
	 OCq8TVYg69eGOD8UZLeP3jOskyfte6Zsrgh0q+YmOV5mmq4goOyz+lM5NWu8CMsoMTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1eg+5eBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31715606EE96
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1eg+5eBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD271F00A28;
	Thu,  5 Nov 2026 17:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793899169;
	bh=W+nNccDp268JIC0BhTvaKbToCLbCGRj8XbTak0dCb7g=;
	h=Date:To:From:Subject;
	b=1eg+5eBjBkR/IHyLFYvu+VocyRkxp2JR48pEvlq8iyuxLnXTrdAJIy4DWvgO3g0/8
	 q4X75MPeXAggqI0ijV7FSki+j91jrFG15BhcrGAivYvp+m3xjlH+VIEFdJsapkGqzA
	 vbQSTpzNhbnqNI0HVugLF5Yii7ymIBlv3tJ1V/Jo=
Date: Thu, 05 Nov 2026 09:19:29 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,brads@mainlining.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compat-make-compat_sysinfo-scale-far-enough-to-actually-fit.patch added to mm-nonmm-unstable branch
Message-Id: <20261105171929.9BD271F00A28@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: compat: make compat_sysinfo() scale far enough to actually fit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compat-make-compat_sysinfo-scale-far-enough-to-actually-fit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compat-make-compat_sysinfo-scale-far-enough-to-actually-fit.patch

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
From: Bradley Morgan <brads@mainlining.org>
Subject: compat: make compat_sysinfo() scale far enough to actually fit
Date: Thu,  5 Nov 2026 00:31:29 +0000

compat_sysinfo() checks whether totalram or totalswap is too big for the
compat struct and scales the values down to fit, but the loop stops as
soon as s.mem_unit reaches PAGE_SIZE.  That caps the compression at one
page, 12 bits with 4K pages.  On a 64 bit kernel do_sysinfo() always hands
it values in bytes with mem_unit == 1, its own overflow math runs on
unsigned long so it does not bail until 16 EiB, so the loop runs its 12
turns, the values come back out as a page count, and anything past 2^32
pages still does not fit.  Storing that into the u32 field then just drops
the top bits.

So a 32 bit process on a box past 2^32 pages gets a wrapped number instead
of a coarse one, with 4K pages that starts at 16 TiB:

  ram      old                  new
  8 TiB    2147483648 x 4096    unchanged
  16 TiB   0 x 4096             2147483648 x 8192
  17 TiB   268435456 x 4096     2281701376 x 8192
  32 TiB   0 x 4096             2147483648 x 16384

The 17 TiB row is the nasty one, a 32 bit process is told the box has 1
TiB of ram.  Keep scaling until the values fit instead of until the unit
reaches a page, the unit then says how coarse the number is, which is what
mem_unit is for.

Nothing that works today changes.  I ran both loops side by side over ram
from 1 MiB to 2^56 with 4K and 64K pages, they disagree on exactly the
inputs where the old one dropped bits and agree on every one it got right.

Link: https://lore.kernel.org/20261105003129.3130709-4-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---

 kernel/sys.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/kernel/sys.c~compat-make-compat_sysinfo-scale-far-enough-to-actually-fit
+++ a/kernel/sys.c
@@ -3035,24 +3035,22 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct c
 	do_sysinfo(&s);
 
 	/* Check to see if any memory value is too large for 32-bit and scale
-	 *  down if needed
+	 * down if needed.  Keep going until the values fit, not just until the
+	 * unit reaches a page.  The values halve each turn, so this ends.
 	 */
 	if (upper_32_bits(s.totalram) || upper_32_bits(s.totalswap)) {
-		int bitcount = 0;
-
-		while (s.mem_unit < PAGE_SIZE) {
+		while (s.mem_unit < PAGE_SIZE || upper_32_bits(s.totalram) ||
+		       upper_32_bits(s.totalswap)) {
 			s.mem_unit <<= 1;
-			bitcount++;
+			s.totalram >>= 1;
+			s.freeram >>= 1;
+			s.sharedram >>= 1;
+			s.bufferram >>= 1;
+			s.totalswap >>= 1;
+			s.freeswap >>= 1;
+			s.totalhigh >>= 1;
+			s.freehigh >>= 1;
 		}
-
-		s.totalram >>= bitcount;
-		s.freeram >>= bitcount;
-		s.sharedram >>= bitcount;
-		s.bufferram >>= bitcount;
-		s.totalswap >>= bitcount;
-		s.freeswap >>= bitcount;
-		s.totalhigh >>= bitcount;
-		s.freehigh >>= bitcount;
 	}
 
 	memset(&s_32, 0, sizeof(s_32));
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-use-nla_put_u32-in-mk_reply.patch
taskstats-take-the-inode-once-in-exe_add_tsk.patch
taskstats-reuse-na-in-cgroupstats_user_cmd.patch
taskstats-use-div_u64-for-the-elapsed-time-in-tgid_stats_add_task.patch
compat-make-compat_sysinfo-scale-far-enough-to-actually-fit.patch

