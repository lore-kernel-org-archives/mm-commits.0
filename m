Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8319B
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845975; cv=none; b=bME0cQv4UOIcVIr8n2JbatxmdeASrTxy8I/ECvBlMcZ1zzTJhwA8RgAJFGXF5+CU0gMfrJYLK9KdTX7AbXqClj7wfFVIGME0oGl9dtZQeNWAdeYQ1/ttSsD5x4+kkUzpPvYSL9IDIOAh0urHuU9jSuJyNo318O//xIYmgHb0urU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845975; c=relaxed/simple;
	bh=BspsAefrh7v67ew53tNjxZRu/eZNGAeRzcviiN8g/7s=;
	h=Date:To:From:Subject:Message-Id; b=YPkCrKg+KAHt7vwvecXm/Gx8SEejEtcG+bC4v5ErarYqzzwk+NxBXlr6BPfjQ3oePt9iM469Rfb70cSuLUA9zGMfiKyfQFD5QpTktEsVNZS7YaROPHSuo9Ce9qSxVB+Yt3XsJMd/VwnXE/K3EitkjrEGaojY91DCvv8E/ugLcqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zBDyMeDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zBDyMeDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E9AC2BBFC;
	Thu, 20 Jun 2024 01:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845975;
	bh=BspsAefrh7v67ew53tNjxZRu/eZNGAeRzcviiN8g/7s=;
	h=Date:To:From:Subject:From;
	b=zBDyMeDBoCC3+76sm1QL/WNKUdA2jVmffjpMTi+XG1gMvr0SmXp241rbbxg265lmE
	 3tHlIiI+GOVCxkRJhoCA1YidI1it4Xz2txL8LZaeceYT/rxH1iR8jFuywJfaL5u3Hd
	 c0UZd6OGs6IH5/clq4i+Ce1M3MCHZCvzoSPMLhCs=
Date: Wed, 19 Jun 2024 18:12:54 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch added to mm-nonmm-unstable branch
Message-Id: <20240620011255.03E9AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: rename pool_index to pool_index_plus_1
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

scripts-gdb-redefine-max_order-sanely.patch
scripts-gdb-rework-module-va-range.patch
scripts-gdb-change-the-layout-of-vmemmap.patch
scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch
scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch
scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

