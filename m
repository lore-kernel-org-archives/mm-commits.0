Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F21E0DCB
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487733; cv=none; b=C9lpLo4sTUXO7yRpR2psmJW2NeFryq2pbCY7iHLnqu03vlMSKfhbOeEUK6tQwL9aOPrjQHhU2Tuu1NIOimmpW+GpwkPHIQW+4/BgKj3oPqOV+09P6wSFz2DojqvmwCZhUTdvik63xNq5JaCuHPhp7llT1S0eW46kNZRzXetTQys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487733; c=relaxed/simple;
	bh=HRaU4+o++WzqRoPpB0L0PM0hQ2MgK4kqD9k8SHdZ+Ho=;
	h=Date:To:From:Subject:Message-Id; b=Z+At7f1nTsqgU9nJ/to6qo4zjLVhG/vfxPfGcB2l0CFFQVNTWcTMGgSOj1zt1NJWN38DW7QiRK6Ajqyer6eLRtZ8D52NHye4TBT+BGp0iF3zqp6wMCdsDAQW/SGk265lCLdfvAOslXKe2vuRsZQZnWKm88HdAZfoSnuvLmnu67A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2HsBwpy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2HsBwpy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6FAC4CEE7;
	Sun, 21 Sep 2025 20:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758487733;
	bh=HRaU4+o++WzqRoPpB0L0PM0hQ2MgK4kqD9k8SHdZ+Ho=;
	h=Date:To:From:Subject:From;
	b=2HsBwpy2CJHzTayRxx4oReORfagnRFHNhKuvTOPLsr/KhuSYsKSW2tk4OFbyzex63
	 iRUwEXwF/Qb7YoG/paMgUbaruaRLuuUtZo68FrUp4cAH6W57+ZumgNrXz7vwf8Zoi7
	 a9lUDSA/7YXmL7nfs/gteHyBGFAtd0mMSsGsMY3E=
Date: Sun, 21 Sep 2025 13:48:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix.patch removed from -mm tree
Message-Id: <20250921204853.1E6FAC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix
has been removed from the -mm tree.  Its filename was
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix.patch

This patch was dropped because it was folded into alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix
Date: Tue, 16 Sep 2025 09:01:10 -0700

Document new "accurate:no" marker.

Link: https://lkml.kernel.org/r/20250916160110.266190-1-surenb@google.com
Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then ea
 For example if the counters are not accurate, the line will be appended with
 "accurate:no" pair.
 
+Supported markers in v2:
+accurate:no
+              Absolute values of the counters in this line are not
+              accurate because of the failure to allocate storage required
+              to track some of the allocations made at this location.
+              Deltas in these counters are accurate, therefore counters
+              can be used to track allocation size and count changes.
+
 Example output.
 
 ::
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

