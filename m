Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908B537D10E;
	Tue, 25 Aug 2026 01:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622952; cv=none; b=HuK4WdQG5XLXq8nADrEcTI261BCihEzOnJSSBvR5XNoX4r/hFRNFLygDtCxWVwai/ptJu1MscmIkN/OCO4edg/48dds/VwHxt6kF1fXMHf4MOakqEtCLBN1W0hlOkshPmDPRg7cXhGsKPw0cIzKrk1tXv75POoI1Uu9DqKNWZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622952; c=relaxed/simple;
	bh=cF7VmJBZwpvj471jcrw3ANTbEEfzFwLM1TdebdU0P8w=;
	h=Date:To:From:Subject:Message-Id; b=RvLdWFV8lJANKBbeGI+haPPQiS1S2fxcbr69cualv3/1p1aR6d/U0g8F1YBMCaqdIX8ICHK4qgxi2yEgRB3faJiRFNrouD+leXk9GSx1VIfhKAjqWY6e3imX1BwUS988gwJLwOvSp8g0vuzByHQbsKQH49VmaqN951GPEUujDgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1L+iJiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1L+iJiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFB01F000E9;
	Tue, 25 Aug 2026 01:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622950;
	bh=N4YM/pY7RVShPODW0spjrrFFcHLqORgyCUARmHqKurs=;
	h=Date:To:From:Subject;
	b=u1L+iJiRAA7kADE5Wv+CmK+R9pM0XJn5fzAA02khjZ4ClVDV8DuhI6Z1ERDDakue5
	 5eLwlFHsr+nJAbZHx7K1Yzjinhn+cTvunudogtW+wO2soqnwQwkYJo4ZwNCeqR2vlh
	 A4SX+eBzOUFuu7JQoL8AoaBaJn7pimz9U6Sd9XbM=
Date: Mon, 24 Aug 2026 18:55:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,ndesaulniers@google.com,morbo@google.com,kees@kernel.org,justinstitt@google.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch_numa-avoid-false-positive-fortify-warning-in-setup_node_to_cpumask_map.patch removed from -mm tree
Message-Id: <20260825015550.5CFB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch_numa: avoid false positive fortify warning in setup_node_to_cpumask_map()
has been removed from the -mm tree.  Its filename was
     arch_numa-avoid-false-positive-fortify-warning-in-setup_node_to_cpumask_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: arch_numa: avoid false positive fortify warning in setup_node_to_cpumask_map()
Date: Thu, 13 Aug 2026 20:12:55 -0700

When building ARCH=riscv using clang with CONFIG_FORTIFY_SOURCE and
CONFIG_UBSAN_BOUNDS enabled, CONFIG_NR_CPUS > 64, and the default value of
2 for CONFIG_NODES_SHIFT, there is a compiletime warning from the fortify
routines.

  In file included from mm/arch_numa.c:11:
  In file included from include/linux/acpi.h:14:
  In file included from include/linux/resource_ext.h:11:
  In file included from include/linux/slab.h:17:
  In file included from include/linux/gfp.h:7:
  In file included from include/linux/mmzone.h:8:
  In file included from include/linux/spinlock.h:60:
  In file included from include/linux/interrupt_rc.h:17:
  In file included from include/linux/smp.h:13:
  In file included from include/linux/cpumask.h:11:
  In file included from include/linux/bitmap.h:13:
  In file included from include/linux/string.h:383:
  include/linux/fortify-string.h:430:4: warning: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribue-warning]
    430 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  include/linux/fortify-string.h:430:4: note: called by function 'fortify_memset_chk(unsigned long, unsigned long, unsigned long)'
  include/linux/bitmap.h:248:3: note: inlined by function 'setup_node_to_cpumask_map'
    248 |                 memset(dst, 0, len);
        |                 ^
  include/linux/fortify-string.h:462:25: note: expanded from macro 'memset'
    462 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
        |                         ^
  include/linux/fortify-string.h:453:2: note: expanded from macro '__fortify_memset_chk'
    453 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
        |         ^
  include/linux/fortify-string.h:430:4: note: use '-gline-directives-only' (implied by '-g1') or higher for more accurate inlining chain locations
    430 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  1 warning generated.

In this configuration, MAX_NUMNODES is 4.  clang unrolls the for loop in
setup_node_to_cpumask_map() past this, which triggers the fortify check
when accessing node_to_cpumask_map on the theoretical fifth loop iteration
because it would be an out of bounds write.

Make it clear to clang that nr_node_ids is bounded by MAX_NUMNODES due to
the logic in setup_nr_node_ids() by early returning in
setup_node_to_cpumask_map() should that condition be violated.

Link: https://lore.kernel.org/20260813-arch_numa-avoid-fortify-warning-v2-1-093ad97a78df@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2174
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/arch_numa.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/arch_numa.c~arch_numa-avoid-false-positive-fortify-warning-in-setup_node_to_cpumask_map
+++ a/mm/arch_numa.c
@@ -105,6 +105,18 @@ static void __init setup_node_to_cpumask
 	if (nr_node_ids == MAX_NUMNODES)
 		setup_nr_node_ids();
 
+	/*
+	 * This check should never be true but it makes it clear to compilers
+	 * that node_to_cpumask_map is bound by nr_node_ids, avoiding false
+	 * positive fortify warnings when accessing node_to_cpumask_map in the
+	 * for loop below.
+	 */
+	if (unlikely(nr_node_ids > MAX_NUMNODES)) {
+		pr_err("nr_node_ids (%u) is larger than MAX_NUMNODES (%u)\n",
+		       nr_node_ids, MAX_NUMNODES);
+		return;
+	}
+
 	/* allocate and clear the mapping */
 	for (node = 0; node < nr_node_ids; node++) {
 		alloc_bootmem_cpumask_var(&node_to_cpumask_map[node]);
_

Patches currently in -mm which might be from nathan@kernel.org are


