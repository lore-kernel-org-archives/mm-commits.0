Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376E7558210
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 18:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790707711; cv=none; b=b4uFumeVelbQPGIzxjigvJ68kRxo8XsOVOMBQuc8QsoQsY19pf6FoKa7Cbn1dYiWQtWyCO1BIADOyaTWNyLc8ILJKAf5aSgy/0PwUn+pf8Oj0Y5YZvBfqEGEaTOqM+TKCQOLtVRg7aRYtkGnkQPHGzkSLVJR49QUJYS3pukN4JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790707711; c=relaxed/simple;
	bh=teUu9ItRo4pi5FrgrGh5DoSZ7tr/sVjjVqau3/sPD3c=;
	h=Date:To:From:Subject:Message-Id; b=egI5FZUlg3fLsqlUBtPyo3226fesaS0mrhGw/nga/UAYtnVsukwCeHyw2pfM6cAUSz2KQKoqiN1Naytu/8Vj53FFu32aAzwOJv6fhsbWiXlvMcH+V0+ImAhB3hHOGmENiwP4v7M7bAQShqfjNAegwKF8A3KRelkhFK4uEL1NC1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2LVVGmip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2LVVGmip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F0C1F000FF;
	Tue, 29 Sep 2026 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790707710;
	bh=XEj9D+Bf7NYmQ/jbvpyExfvaeSJnMfsNFm6kHbbrSCc=;
	h=Date:To:From:Subject;
	b=2LVVGmip2n26Wib3IwE+qE7y0FDyEhcL9Yc9wIITb3uaZ05eGeNCQ71YoMLPHN6Ya
	 Fruq43oVBvsTD/zV65p6mo4B++zOXR3QsgtiAOwDvuFkd8ad6spfbi/rsFs9LnE2l5
	 t30YXOVNCPIKFj0Y+YjVINMS465DlsU3ihK92cY8=
Date: Tue, 29 Sep 2026 11:48:29 -0700
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,rostedt@goodmis.org,pmladek@suse.com,olsajiri@gmail.com,mcgrof@kernel.org,masahiroy@kernel.org,ljs@kernel.org,kees@kernel.org,geert@linux-m68k.org,david.laight.linux@gmail.com,andrey.grodzovsky@crowdstrike.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch added to mm-nonmm-unstable branch
Message-Id: <20260929184829.E2F0C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: unroll 24-bit sequence reconstruction in get_symbol_seq()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

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

kallsyms-match-compressed-tokens-on-the-fly-during-binary-search.patch
kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups.patch
kallsyms-unroll-24-bit-sequence-reconstruction-in-get_symbol_seq.patch

