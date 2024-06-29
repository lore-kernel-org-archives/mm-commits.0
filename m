Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B12E18C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628630; cv=none; b=OOmuhED4SDznE+XlFtUsPcePgNwfJXSumX18Pgwbo/plEMirx7OuVc1M73QhQ5LyS1bYTlKjPy7NaDwjCt/spYWSXk1CKnbfQD6NSwnB5m1XYHVWRouh40XtqDoR17IB9sv7JOW8bpVVw8MfxwMxXmM5A3uKN5dUR8yF8b6w06I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628630; c=relaxed/simple;
	bh=8ie/znwYVRmWNUDDUAipkOTFaMWrXQz5hL4XCpQR1k4=;
	h=Date:To:From:Subject:Message-Id; b=H8qMTGVB9PMCGa5hhhDHmQGl4dkLIKAkqLsB+7vwr+fmIlTq4Kk4hg450um4mINkwK+95IQDiyF3oZVN0YTZhECd8Hhqb1Rz4etzNtVKFLq9ebuPsCxuG1wHwP/L8S+xZbrId2SoiI1Xyo+FRgvdytR6Syui4NjdaEzPwga5pAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0E+Tu+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0E+Tu+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1493CC32781;
	Sat, 29 Jun 2024 02:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628630;
	bh=8ie/znwYVRmWNUDDUAipkOTFaMWrXQz5hL4XCpQR1k4=;
	h=Date:To:From:Subject:From;
	b=r0E+Tu+jRFtsYrh1BNDPe7hAnnnIRc8xUqN57ac4ad1VFjkzU+S+b8OU3b2hMOsJS
	 PhxHjyj+J+ybGIQ78UQsOUedglPH9HLU4uLfH1dA14ezLCfXspdsPyJOcBPSxnQn1G
	 dLs5Y102iRaJ500kAvwrb3z+MsQyWEdmzfZ4eETo=
Date: Fri, 28 Jun 2024 19:37:09 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch removed from -mm tree
Message-Id: <20240629023710.1493CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: rename pool_index to pool_index_plus_1
has been removed from the -mm tree.  Its filename was
     scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: rename pool_index to pool_index_plus_1
Date: Wed, 19 Jun 2024 15:49:11 +0800

We encounter the following issue after commit a6c1d9cb9a68 ("stackdepot:
rename pool_index to pool_index_plus_1").

(gdb) lx-dump-page-owner --pfn 262144
...
Python Exception <class 'gdb.error'>: There is no member named pool_index.
Error occurred in Python: There is no member named pool_index.

We rename pool_index to pool_index_plus_1 to fix this issue.

Link: https://lkml.kernel.org/r/20240619074911.100434-7-kuan-ying.lee@canonical.com
Fixes: a6c1d9cb9a68 ("stackdepot: rename pool_index to pool_index_plus_1")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/stackdepot.py |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-rename-pool_index-to-pool_index_plus_1
+++ a/scripts/gdb/linux/stackdepot.py
@@ -27,14 +27,18 @@ def stack_depot_fetch(handle):
     offset = parts['offset'] << DEPOT_STACK_ALIGN
     pools_num = gdb.parse_and_eval('pools_num')
 
-    if parts['pool_index'] > pools_num:
+    if handle == 0:
+        raise gdb.GdbError("handle is 0\n")
+
+    pool_index = parts['pool_index_plus_1'] - 1
+    if pool_index >= pools_num:
         gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
 
     try:
-        pool = stack_pools[parts['pool_index']]
+        pool = stack_pools[pool_index]
         stack = (pool + gdb.Value(offset).cast(utils.get_size_t_type())).cast(stack_record_type.get_type().pointer())
         size = int(stack['size'].cast(utils.get_ulong_type()))
         return stack['entries'], size
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are


