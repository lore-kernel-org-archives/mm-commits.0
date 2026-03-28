Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF62C22B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671936; cv=none; b=CSTjYT3RK2NmYcoyhMTliDILT/P9dpNppCn0XokRD2tGX7IKxtG5R4OvLzXxBmsRGasrfy3Prdv+M7yf7JOBp/P1Nls7Vrk/oDhIhtFQ2QE/8r52WU7fxmyeQ3f4e4nhcCbXzxKqbLDyP3ksmVd77mzWcu1XEniTjORNzhW31QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671936; c=relaxed/simple;
	bh=3Lp3QiXnDc0Q21LyGyXl4BRgpBZHZPRxpyVLu//8nzg=;
	h=Date:To:From:Subject:Message-Id; b=SesJpz5WCaKBZXyVtwsVfT8vFyDY9vj9Ii+TZEaQBAMzf8sBhOTo2x8o4et3fegIsmNmpMAgNS9nayITKCKhQu4H1xy907oscqB3QrjdGPFkqOAykUuGk88VXlzHtZINwBIzELDezOpzJG08SGHWi0GUTOUXORxmjqp0OwvRDF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KS0Y/efT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KS0Y/efT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BBCC4CEF7;
	Sat, 28 Mar 2026 04:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671935;
	bh=3Lp3QiXnDc0Q21LyGyXl4BRgpBZHZPRxpyVLu//8nzg=;
	h=Date:To:From:Subject:From;
	b=KS0Y/efTC6uAZbDXHVoJztXB12QcGOXqvDFdIJaSjwYIZ3lU8QFdl4c5iyAvBPcY9
	 1gQlglPOH6vUNesJiEbR9Bq9ENhuUML1T7zbioiKZS4m4DaaRe6To+cHyEY04XaDef
	 snM4YDoB/lMxou2S5LoNQ/MxErJFemzZg5fB1LX4=
Date: Fri, 27 Mar 2026 21:25:35 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bug-remove-unnecessary-variable-initializations.patch removed from -mm tree
Message-Id: <20260328042535.C7BBCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bug: remove unnecessary variable initializations
has been removed from the -mm tree.  Its filename was
     lib-bug-remove-unnecessary-variable-initializations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/bug: remove unnecessary variable initializations
Date: Fri, 6 Mar 2026 16:24:18 +0000

Remove the unnecessary initialization of 'rcu' to false in
report_bug_entry() and report_bug(), as it is assigned by warn_rcu_enter()
before its first use.

Link: https://lkml.kernel.org/r/20260306162418.2815979-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/bug.c~lib-bug-remove-unnecessary-variable-initializations
+++ a/lib/bug.c
@@ -263,7 +263,7 @@ static enum bug_trap_type __report_bug(s
 enum bug_trap_type report_bug_entry(struct bug_entry *bug, struct pt_regs *regs)
 {
 	enum bug_trap_type ret;
-	bool rcu = false;
+	bool rcu;
 
 	rcu = warn_rcu_enter();
 	ret = __report_bug(bug, bug_addr(bug), regs);
@@ -275,7 +275,7 @@ enum bug_trap_type report_bug_entry(stru
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
 	enum bug_trap_type ret;
-	bool rcu = false;
+	bool rcu;
 
 	rcu = warn_rcu_enter();
 	ret = __report_bug(NULL, bugaddr, regs);
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

