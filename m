Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C1B30E85B
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 21:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773524716; cv=none; b=B10GnhosvYrKxrzRx8AOIDy65bEwht0zRv3iAFdtagPwaQ6s6nY6r5oHmjaNQORhf0DIXicqu6H7p1TvFjMpUouQcCGXX0wXIjNfL0fIyUAlB7DXiCb1S8DB7khvFAzTyjMx9myA4GZqoWuTEHmpkizjJ7EKBnbR1JnMnO+ebrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773524716; c=relaxed/simple;
	bh=9hvc7YH6Vu7kHXyaZFiP/EpHjsoTdpXUvwP38B7CpPY=;
	h=Date:To:From:Subject:Message-Id; b=ZTCkt3W4Bv9E7QeXalJx3V+E0e3f6aNhsLZPd3+od39clSDHA3Y7jwm10DWpfu6DL27gWTt+EtkXyWIW0sD87/yNdEJYNiu4068Joe6eDViq3fWzsyzg/BBEqV33n3RA2e4mTo21BrnWB/sDDnuCr/0xew0Z+juuQMb0XqweDbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4LYFB3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4LYFB3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED89AC116C6;
	Sat, 14 Mar 2026 21:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773524716;
	bh=9hvc7YH6Vu7kHXyaZFiP/EpHjsoTdpXUvwP38B7CpPY=;
	h=Date:To:From:Subject:From;
	b=E4LYFB3cU/YeXKw90ECxsqbPayvaDL76zjsVHCXRJeloWJyTZHTYeVrDY79fK8AFH
	 jCIhpdyJ5nBpHr6ZEyQyyWnqNYGVlTrVzFThpR5WSkGaIhoas94ATepV3ic3ScGnPK
	 7X1TWm1mc1QPSL9bGLC6DF9/4E+XGUGq0+rx6kq4=
Date: Sat, 14 Mar 2026 14:45:15 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,mathieu.desnoyers@efficios.com,dennis@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-introduce-hierarchical-per-cpu-counters-fix.patch added to mm-unstable branch
Message-Id: <20260314214515.ED89AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: fix compare_delta parameter order in percpu_counter_tree
has been added to the -mm mm-unstable branch.  Its filename is
     lib-introduce-hierarchical-per-cpu-counters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-introduce-hierarchical-per-cpu-counters-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: David Carlier <devnexen@gmail.com>
Subject: lib: fix compare_delta parameter order in percpu_counter_tree
Date: Fri, 13 Mar 2026 17:54:24 +0000

The compare_delta() helper takes (delta, accuracy_neg, accuracy_pos), but
every call site passes (delta, accuracy_pos, accuracy_neg) — the last
two arguments are consistently swapped.

The documented invariant (include/linux/percpu_counter_tree.h) is:

  (precise_sum - under) <= approx_sum <= (precise_sum + over)

Which means precise_sum is in [approx_sum - over, approx_sum + under].

For a positive delta (v - approx_sum >= 0), accuracy_pos must be
"under" (the maximum amount precise_sum can exceed approx_sum).
For a negative delta, accuracy_neg must be "over". Since under > over
always (batch_size * M vs (batch_size - 1) * M), swapping them causes
false definitive results: the functions return 1 ("v > counter") when
the correct answer is 0 (indeterminate).

This affects all comparison functions:
- percpu_counter_tree_approximate_compare_value()
- percpu_counter_tree_approximate_compare()
- percpu_counter_tree_precise_compare_value()
- percpu_counter_tree_precise_compare()

The precise variants are also affected because their approximate
fast-path can short-circuit with a wrong result, skipping the precise
sum computation.

Fix by swapping the parameter order in compare_delta() itself, since all
call sites are consistently swapped.

Link: https://lkml.kernel.org/r/20260313175424.132735-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Josh Law <objecting@objecting.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter_tree.c~lib-introduce-hierarchical-per-cpu-counters-fix
+++ a/lib/percpu_counter_tree.c
@@ -458,7 +458,7 @@ long percpu_counter_tree_precise_sum(str
 EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_sum);
 
 static
-int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy_pos)
+int compare_delta(long delta, unsigned long accuracy_pos, unsigned long accuracy_neg)
 {
 	if (delta >= 0) {
 		if (delta <= accuracy_pos)
_

Patches currently in -mm which might be from devnexen@gmail.com are

lib-introduce-hierarchical-per-cpu-counters-fix.patch

