Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD43F44D5
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 03:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785813173; cv=none; b=jM9BZ93cgXIKFalxbAhJhOZbFX5ZoM4LMnnCJaX8GgeQ+LTK15RX1fawxXAB9g7SqLrmb1NCmwhNOG1mvouDeDATA32zj5gsdteiuz5gk+2o6dM2p1WkD8LhEkjn+GE8jk7VFjstlqtkVySBZ5PLHRzlUrwp4neyWKIHPmngj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785813173; c=relaxed/simple;
	bh=MXqRS/iJOWvJu2JUh2YhohkDMvDILlpCM6NFpZP3SGM=;
	h=Date:To:From:Subject:Message-Id; b=RCtc0a2ua+i+sREoYO8WZzK9KkT35I0zdV2jRZmtzHwe5jrXR6UhXhAqWdOCsaS5C2KiFDDINdDIAaOSDl7SDHtFh6IC2xp//ueZtE03p6Kj+rbudlvdDFg20nkeAAixP9K2RlSPtObcmHLkQj4mLk5gDsNeSOh4nQo4yAeHLII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xwlcnAQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xwlcnAQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F81F00A3E;
	Tue,  4 Aug 2026 03:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785813161;
	bh=vhtCYxIbTQm1mSvMWNX1yOgI+oz3OgvFdz3+mTiY0zg=;
	h=Date:To:From:Subject;
	b=xwlcnAQBclrQ1o4N0pgRbMx0VxgNhtQBqCQGuDRvkew82Y55a+BGLJcNoUVqGznnc
	 mGgugDmQTZjRAQpWLQ3KrJRezqH/NM7JTxy3tKC/GGaHDGcqEV3kjWfyPEHfW/GuzT
	 YSO3V77tWPv6eXBnoU/dHKUCr/HEN0tA64yzDBuA=
Date: Mon, 03 Aug 2026 20:12:40 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch removed from -mm tree
Message-Id: <20260804031240.D97F81F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delaytop: fix a bunch of docs build problems
has been removed from the -mm tree.  Its filename was
     delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: delaytop: fix a bunch of docs build problems
Date: Wed, 8 Jul 2026 17:51:04 -0700

Add one space before '('.  Use a literal block for the last output
example, thus repairing all of these warnings:

Documentation/accounting/delay-accounting.rst:236: ERROR: Unexpected indentation. [docutils]
Documentation/accounting/delay-accounting.rst:237: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:237: ERROR: Unexpected section title or transition.
  ------------------------------------------------------------------------ [docutils]
Documentation/accounting/delay-accounting.rst:239: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:243: ERROR: Unexpected indentation. [docutils]
Documentation/accounting/delay-accounting.rst:244: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:246: ERROR: Unexpected indentation. [docutils]
Documentation/accounting/delay-accounting.rst:247: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:249: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:246: ERROR: Unknown target name: "pool_workqueue". [docutils]

Link: https://lore.kernel.org/20260709005104.501556-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix
+++ a/Documentation/accounting/delay-accounting.rst
@@ -181,7 +181,7 @@ Interactive keyboard controls during run
 	M - Toggle display mode (Default/Memory Verbose)
 	q - Quit
 
-Available sort fields(use -s/--sort or interactive command)::
+Available sort fields (use -s/--sort or interactive command)::
 
 	cpu(c)       - CPU delay
 	blkio(i)     - I/O delay
@@ -219,8 +219,8 @@ Advanced usage examples::
 
 
 
-delaytop add delay_max fields to track the maximum delay value for each delay type
-(cpu, blkio, irq, swapin, freepages, thrashing, compact, wpcopy) per task.
+delaytop add delay_max fields to track the maximum delay value for each delay
+  type (cpu, blkio, irq, swapin, freepages, thrashing, compact, wpcopy) per task::
 
 	bash# ./delaytop -t cpu
 	System Pressure Information: (avg10/avg60/avg300/total)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rbtree-fixup-kernel-doc-names.patch
llist-use-correct-function-parameter-name.patch
stacktrace-header-repair-kernel-doc-comments.patch

