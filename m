Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D57F3955C7
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 03:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791691158; cv=none; b=aupT2TAUf6Tuv1EuzJkq7FDBB0G/8fcpqgYuQW95xMT0o+vDr5XCWF0+H2pV6n8de8bRw5aXcB6IX+Kc9LnFS3n9RB3SniAd5enRf+elpTcw3OEg6vYaZlXllIQrGuBkq5QXKUNVj471uDccX36w7r9kmGmhmFnCSXoY9UqgDR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791691158; c=relaxed/simple;
	bh=YiJvKb/ck48ohLzbVEVMiDpiXw/ckCTNt78/5MmEU/s=;
	h=Date:To:From:Subject:Message-Id; b=gpBiUM6S/ndK9o+d+gT8srBbnELOp1+zJntwRw8Hla5oFBzC3GzJ9xBYxctKb0DlyUwKrlvlej067V2RgtkGNZbBc8MVseu3WDlIPd9edv9xi+h0mwLmqZpwoXaRjCDOgSRyAL76vzdciseml/7Nt5hMauHFRdH8p1DNui0cI+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d8kGsho5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d8kGsho5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD71F00893;
	Sun, 11 Oct 2026 03:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791691156;
	bh=tz52SsTiIZ9ZwxlL6YeAvzEVRh5F9fpZJLjWOFIGKJ0=;
	h=Date:To:From:Subject;
	b=d8kGsho5nZVwPOiD1BWu+hA/tabX5wOjpIUg5GQAD4Q7NZmgjMuXaZTXgzef7djyA
	 bMMUpgPE9bu1k3y5BEYB0+6cYRk3dwIljiKNs+p1bW/TTt2x3ZOsopCjt5ob3YjbjM
	 wrt4hbA0HO34Q6sqAZcWoqv3sSTcF8bDZpqggu08=
Date: Sat, 10 Oct 2026 20:59:16 -0700
To: mm-commits@vger.kernel.org,kuan-ying.lee@canonical.com,kbingham@kernel.org,jan.kiszka@siemens.com,ue081723@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch added to mm-nonmm-unstable branch
Message-Id: <20261011035916.A2FD71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix stack depot out-of-bounds diagnostic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch

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
From: Ting-Han Hou <ue081723@gmail.com>
Subject: scripts/gdb: fix stack depot out-of-bounds diagnostic
Date: Sun, 11 Oct 2026 10:30:44 +0800

The pool_index field was renamed to pool_index_plus_1, but the
out-of-bounds diagnostic in stack_depot_fetch() still accesses the old
field.  Looking up a handle whose pool index is outside stack_pools
therefore raises "There is no member named pool_index" instead of printing
the diagnostic and returning an empty result.

Use the already decoded pool_index variable in the diagnostic.

Link: https://lore.kernel.org/20261011023044.1722-3-ue081723@gmail.com
Fixes: 9d938f40b228 ("scripts/gdb: rename pool_index to pool_index_plus_1")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
---

 scripts/gdb/linux/stackdepot.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic
+++ a/scripts/gdb/linux/stackdepot.py
@@ -39,7 +39,7 @@ def stack_depot_fetch(handle):
 
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (pool_index, pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
_

Patches currently in -mm which might be from ue081723@gmail.com are

scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch
scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch

