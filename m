Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794203540;
	b=4wUfzM8KBMJSvh+LQvEKt7OrndV6noenncTGdBtzow2GduPl/C2LqzDLGgntxe5mDFyg
	 pVD+QF4TXM4LOdmebMaDr+qF2/mbn2qSDAhOaceNfW0O28CefPKv2lBMvA292JUvCwal4
	 awUF588xjuJAm0wl5KHZFHL6hAXP5sSICsYw2cisZc07xmolUkZrKeOzhKvXl0u29JCXZ
	 D/O1VppHXyWtQ0rPod25RNeXhi1eJi5oxsFVRZ/7tMDtfrzaMfpFv09EcRl9+0QBooPKu
	 tUhpM2mN8ADNEQ/B2mzGVQtpI2s9spR3n7uRN53DXG9JW/d8t+H4OTrQMmGO836aFQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794203540;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pymP+0SmU31uGuQ6Z2pCzEmfufQ91t2HCqIAJ+j0BqI=;
	b=zqEVmWr8s0YkE9qHNgoxV33mtmAyuTvTauAqSCOiu9FbKoK+gtpsGCd3U4iKIcnYTDsz
	 g6lsGMKfp0tK2TchIYEDGvOeJtiUpZdvQA52iTFePf/PPAtpwGgP/iqCVFQL1hH7zACL0
	 dIKcwgbW8L8OglTN7U0GprhfoN1LkE6G0PWWNAihD4sZJ4PoVp3ZnlIU3u9CAmr5w18Gh
	 7RJoJStE8iU20JzaiqQcDE+rk2Vz/RMR1Eb1Ywh7z/qV1i2ljXMcJe1CSL2X9tLrmOXcD
	 JEDRBSSDC85ZccjLGw4ZllWAkUZUYeJcpu0HpvYjE589hXj2AcxDXxyvnUS4U1fTHmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yyCyJj4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8BD606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 05:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yyCyJj4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18A91F0089F;
	Mon,  9 Nov 2026 05:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794203539;
	bh=pymP+0SmU31uGuQ6Z2pCzEmfufQ91t2HCqIAJ+j0BqI=;
	h=Date:To:From:Subject;
	b=yyCyJj4pNH0m0gRvgJL9SnBNupgnHabVzONoV24xaJAd7NTULKKt74QNYaacOTPq6
	 YBfuQQSJ5XZlxuju5kKqU1VFKiC+XojrBPXEyBbrk8CU4vTxtqSOrAUkWSbGx5oq8e
	 vAPIzPR6EyKhJaW4cAQZnjXqnXiKd4Fpm4Vb+hxM=
Date: Sun, 08 Nov 2026 21:52:19 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,apw@canonical.com,
	ptosi@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-fix-bad-complex_macro-on-asm-volatile.patch added to mm-nonmm-unstable branch
Message-Id: <20261109055219.B18A91F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: fix bad COMPLEX_MACRO on asm volatile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-fix-bad-complex_macro-on-asm-volatile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-fix-bad-complex_macro-on-asm-volatile.patch

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
From: Pierre-Clément Tosi <ptosi@google.com>
Subject: checkpatch: fix bad COMPLEX_MACRO on asm volatile
Date: Sat, 07 Nov 2026 15:57:02 +0100

Commit 42e152931deb ("checkpatch: exclude asm volatile from complex macro
check") added a substitution converting "asm volatile" into "asm_volatile"
so that macros expanding to an asm volatile statement would be treated
like a single function call and excluded from the COMPLEX_MACRO error
("Macros with complex values should be enclosed in parentheses").

However, that substitution was placed after the loop that flattens
parenthesized expressions into "1u" (originally "1").  For a macro without
whitespace between "volatile" and "(", such as:

    #define foo(x) asm volatile("..." : : "r" (x))

flattening the parenthesized argument list first turns the statement into
"asm volatile1u".  Because "1u" starts with a word character, the trailing
word boundary (\b) in /\b_*asm_*\s+_*volatile_*\b/ no longer matches after
"volatile", leaving the space between "asm" and "volatile1u" intact and
causing the macro to still fail the single-lvalue check and trigger a
false-positive COMPLEX_MACRO error.

Move the "asm volatile" to "asm_volatile" substitution before the
parenthesis-flattening loop so that "asm volatile(...)" is first rewritten
to "asm_volatile(...)" and then flattened to "asm_volatile1u" as intended.

Link: https://lore.kernel.org/20261107-checkpatch-asm-complex_macro-v1-1-9a7b3c69fc28@google.com
Fixes: 42e152931deb ("checkpatch: exclude asm volatile from complex macro check")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-bad-complex_macro-on-asm-volatile
+++ a/scripts/checkpatch.pl
@@ -6056,6 +6056,9 @@ sub process {
 			$dstat =~ s/^\s*//s;
 			$dstat =~ s/\s*$//s;
 
+			# Make asm volatile uses seem like a generic function
+			$dstat =~ s/\b_*asm_*\s+_*volatile_*\b/asm_volatile/g;
+
 			# Flatten any parentheses and braces
 			while ($dstat =~ s/\([^\(\)]*\)/1u/ ||
 			       $dstat =~ s/\{[^\{\}]*\}/1u/ ||
@@ -6069,9 +6072,6 @@ sub process {
 			{
 			}
 
-			# Make asm volatile uses seem like a generic function
-			$dstat =~ s/\b_*asm_*\s+_*volatile_*\b/asm_volatile/g;
-
 			my $exceptions = qr{
 				$Declare|
 				# named exceptions
_

Patches currently in -mm which might be from ptosi@google.com are

checkpatch-fix-bad-file_path_changes-on-headers.patch
checkpatch-fix-bad-complex_macro-on-asm-volatile.patch

