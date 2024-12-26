Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6918E1F;
	Thu, 26 Dec 2024 21:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249131; cv=none; b=XawkQ1+wJDTECnbsUv0Z/ZDofpyvN78V0/5gGThFHvR8/R4QsJ7ovVraHJyfMMMbkchzooyRGs52Y4TdRo5u38wcciX1KvejWOKqjKY7NiOxSvdJeFc6AUszJIvyDB+pN2bW/ycYOaonhRqmYYVGsMMDb/oElKAvfb9mkNUOGUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249131; c=relaxed/simple;
	bh=jcyj5tSl4PeG/4jjbOvSRQSVQvAHVmja0i+w17NkK6o=;
	h=Date:To:From:Subject:Message-Id; b=uYVcLZya5872pkiLKP2v/eOy3bCgB406pxInXe+k2ykWuywk28e3DQnioqrhti9RbvMj/zDyL8SUR3ybdwRl2rCgCDbsr0mIMCf/WwuUmYza2FBtKioiq3vpPE1sLNMKXsiIpKi2wQ7iNDc5PokyVGORUPNdt7guJFVf+yPPNXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q80O9aGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q80O9aGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B615C4CED1;
	Thu, 26 Dec 2024 21:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249131;
	bh=jcyj5tSl4PeG/4jjbOvSRQSVQvAHVmja0i+w17NkK6o=;
	h=Date:To:From:Subject:From;
	b=Q80O9aGnYb41uUTK2ROxC6infLZYTvb/0LsRs5PvsJ8gulQmYoo1dGlx4Gzg56uFy
	 dezmw4NtaxHQ0K/r4KzhcliutmY+ikjCHHPGXy1/B4UduPM7Oy26exiJjzhhgEgBr6
	 VvvE8rmukUXMCR79D402MTDmaTcRgFpLU3O7DCfA=
Date: Thu, 26 Dec 2024 13:38:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shile.zhang@linux.alibaba.com,rostedt@goodmis.org,peterz@infradead.org,mingo@kernel.org,jserv@ccns.ncku.edu.tw,jpoimboe@kernel.org,chuang@cs.nycu.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-sorttable-fix-orc_sort_cmp-to-maintain-symmetry-and-transitivity.patch added to mm-hotfixes-unstable branch
Message-Id: <20241226213851.3B615C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-sorttable-fix-orc_sort_cmp-to-maintain-symmetry-and-transitivity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-sorttable-fix-orc_sort_cmp-to-maintain-symmetry-and-transitivity.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity
Date: Thu, 26 Dec 2024 22:03:32 +0800

The orc_sort_cmp() function, used with qsort(), previously violated the
symmetry and transitivity rules required by the C standard.  Specifically,
when both entries are ORC_TYPE_UNDEFINED, it could result in both a < b
and b < a, which breaks the required symmetry and transitivity.  This can
lead to undefined behavior and incorrect sorting results, potentially
causing memory corruption in glibc implementations [1].

Symmetry: If x < y, then y > x.
Transitivity: If x < y and y < z, then x < z.

Fix the comparison logic to return 0 when both entries are
ORC_TYPE_UNDEFINED, ensuring compliance with qsort() requirements.

Link: https://www.qualys.com/2024/01/30/qsort.txt [1]
Link: https://lkml.kernel.org/r/20241226140332.2670689-1-visitorckw@gmail.com
Fixes: 57fa18994285 ("scripts/sorttable: Implement build-time ORC unwind table sorting")
Fixes: fb799447ae29 ("x86,objtool: Split UNWIND_HINT_EMPTY in two")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: <chuang@cs.nycu.edu.tw>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/sorttable.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/sorttable.h~scripts-sorttable-fix-orc_sort_cmp-to-maintain-symmetry-and-transitivity
+++ a/scripts/sorttable.h
@@ -110,7 +110,7 @@ static inline unsigned long orc_ip(const
 
 static int orc_sort_cmp(const void *_a, const void *_b)
 {
-	struct orc_entry *orc_a;
+	struct orc_entry *orc_a, *orc_b;
 	const int *a = g_orc_ip_table + *(int *)_a;
 	const int *b = g_orc_ip_table + *(int *)_b;
 	unsigned long a_val = orc_ip(a);
@@ -128,6 +128,9 @@ static int orc_sort_cmp(const void *_a,
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
 	orc_a = g_orc_table + (a - g_orc_ip_table);
+	orc_b = g_orc_table + (b - g_orc_ip_table);
+	if (orc_a->type == ORC_TYPE_UNDEFINED && orc_b->type == ORC_TYPE_UNDEFINED)
+		return 0;
 	return orc_a->type == ORC_TYPE_UNDEFINED ? -1 : 1;
 }
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

scripts-sorttable-fix-orc_sort_cmp-to-maintain-symmetry-and-transitivity.patch
lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch

