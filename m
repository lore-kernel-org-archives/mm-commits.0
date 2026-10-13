Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DEA484255
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865980; cv=none; b=h8G7cEkbpTeJEpAZo7NS7KR0DCyt1bmjgt40WpqzfoYTJDD1f10WXycxWwQ94ZlNdin6R5DXZilRUykrZR34lrsoXiQhhwRhhrmp3hKy6S3ehzbmvWa7wekD/aRXKu9xVaQ5sP6VePmdIavgLptO5q/jkwftY2cu5mM+FSmhwhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865980; c=relaxed/simple;
	bh=KYFF+rq4+WFGbvvLuFo+Hmabso5tUZsy0etqdeOHp9I=;
	h=Date:To:From:Subject:Message-Id; b=MfkfBP+1MqE87sCz2NsMQwQz5ihF7b4MQWLjbbjpB97Te0/KTKkA+oDyZm+iYy6RhrtD2yBep3SGTCPtTx6QLgfHHah0KS2KVPNtZ49DdBt854XevRYlf/D9KwQn4jPn95IERsorzNTpWygTJmb4Czk8Dw1n0V2Zzc4z+Jiq25c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pkXPjlbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pkXPjlbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B981F00898;
	Tue, 13 Oct 2026 04:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865978;
	bh=fOI4OgSxbU6zccBr8tdDMutJj94t5OFQFbLPhTaYkNo=;
	h=Date:To:From:Subject;
	b=pkXPjlboKRZT4EBf4nmLb9p3iP786TT4HUYQzMJTVdWe9w9n/kfkpk/c/pYZMHwOw
	 sRQQwvgL93RdPOJAsbVcpL1Q67YJdP7h2CbUPO1pw2/7ug6pX90ltE2FNRl0lebCRp
	 SRC8Ak0onPCuBFcnN5RoOcXJHDwRDX0OAxqPEUug=
Date: Mon, 12 Oct 2026 21:32:58 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-kmemleak-fix-stale-statements-about-scanning.patch removed from -mm tree
Message-Id: <20261013043258.96B981F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: kmemleak: fix stale statements about scanning
has been removed from the -mm tree.  Its filename was
     documentation-kmemleak-fix-stale-statements-about-scanning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: Documentation: kmemleak: fix stale statements about scanning
Date: Thu, 17 Sep 2026 06:47:36 -0700

Three statements in the "false positives/negatives" and "Limitations"
sections have never matched the code:

 - task stack scanning is on by default (kmemleak_stack_scan = 1), as
   the parameter list earlier in the same document already states;

 - MSECS_MIN_AGE has been 5000, not 1000, since the initial commit;

 - scanning is done by a periodic kthread. Reading the debugfs file
   only lists what the last scan found; kmemleak_open() calls
   seq_open() and never scans.

Link: https://lore.kernel.org/20260917-b4-kmemleak-doc-v1-2-84fde6d1f749@debian.org
Fixes: 04f70336c80c ("kmemleak: Add documentation on the memory leak detector")
Fixes: e0a2a1601bec ("kmemleak: Enable task stacks scanning by default")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/dev-tools/kmemleak.rst |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~documentation-kmemleak-fix-stale-statements-about-scanning
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -190,7 +190,8 @@ reported by kmemleak because values foun
 point to such objects. To reduce the number of false negatives, kmemleak
 provides the kmemleak_ignore, kmemleak_scan_area, kmemleak_no_scan and
 kmemleak_erase functions (see above). The task stacks also increase the
-amount of false negatives and their scanning is not enabled by default.
+amount of false negatives and their scanning is enabled by default; it
+can be turned off with ``stack=off``.
 
 The false positives are objects wrongly reported as being memory leaks
 (orphan). For objects known not to be leaks, kmemleak provides the
@@ -200,7 +201,7 @@ longer be scanned.
 
 Some of the reported leaks are only transient, especially on SMP
 systems, because of pointers temporarily stored in CPU registers or
-stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
+stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 5000) representing
 the minimum age of an object to be reported as a memory leak.
 
 The ``min_unref_scans`` module parameter requires an object to be seen
@@ -217,8 +218,10 @@ Limitations and Drawbacks
 -------------------------
 
 The main drawback is the reduced performance of memory allocation and
-freeing. To avoid other penalties, the memory scanning is only performed
-when the /sys/kernel/debug/kmemleak file is read. Anyway, this tool is
+freeing. To avoid other penalties, the memory scanning is performed by a
+periodic thread rather than on every allocation. Reading the
+/sys/kernel/debug/kmemleak file only lists the objects found by the last
+scan; writing ``scan`` to it triggers a new one. Anyway, this tool is
 intended for debugging purposes where the performance might not be the
 most important requirement.
 
_

Patches currently in -mm which might be from leitao@debian.org are


