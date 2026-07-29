Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81633391E4C
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298450; cv=none; b=t2RMBFwvZTQWkbBKbug517TIN2SnpeWs+vDZeUpaj/g4F9yt2Jk3geo8qu62wivG8xXulyVDFm0xiLDyJ9s1S7cuUYzR6PjW2vVAOwprBuSORI34bAoGVIcR6P3P0v7fmipUVPjfQDHQ8i/KaYGYGanV6AfTx2k6gap0TJyK2Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298450; c=relaxed/simple;
	bh=8gcuEbIm9qaGT/tu28XA84hp1kGHWJlKoYwMOszQ5+A=;
	h=Date:To:From:Subject:Message-Id; b=E4jIhaL27TtCX98mFvuRCRx44hNkOUxRrqhBhNsEsRUkoa20T6dUUmrV8TiCAOtQjQtDXI/Ve1S803gygK0Aps8LXcW1m52ab21N2J8EGS3/RWLMqPbRL/I223iq+5iErHWvozUcDkIeNMDwM1o9ER1YDAfq7g9NoIc9wWQfaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mzU9EILJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mzU9EILJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A9F1F000E9;
	Wed, 29 Jul 2026 04:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298449;
	bh=zz7BlCcxAg00BwPhq4cOuswJg69wWeF87Wl6tmZKmYo=;
	h=Date:To:From:Subject;
	b=mzU9EILJwNmqFV3fj3bXoIRLkCV4+6/r8BHgA6OoriTdroWTTbfJK9FI0hhN4lAi1
	 EdvkbhgHwaznv6/PMhz9wxGjMDKgHwPzkNXu7gkQcmFmWUe3LIVb6YjvvvBrRLgWt7
	 d6pWBbqMQ8FKW4iGtYLLWj0EvBvKkAQOQz0f1iss=
Date: Tue, 28 Jul 2026 21:14:08 -0700
To: mm-commits@vger.kernel.org,agruenba@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-writebackh-to-docs-build.patch removed from -mm tree
Message-Id: <20260729041409.10A9F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add writeback.h to docs build
has been removed from the -mm tree.  Its filename was
     mm-add-writebackh-to-docs-build.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add writeback.h to docs build
Date: Mon, 15 Jun 2026 17:22:41 +0100

There's four functions in this header file with kernel-doc; add them to
the htmldocs.

Link: https://lore.kernel.org/20260615162244.2170866-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/core-api/mm-api.rst~mm-add-writebackh-to-docs-build
+++ a/Documentation/core-api/mm-api.rst
@@ -73,6 +73,7 @@ Readahead
 Writeback
 ---------
 
+.. kernel-doc:: include/linux/writeback.h
 .. kernel-doc:: mm/page-writeback.c
    :export:
 
_

Patches currently in -mm which might be from willy@infradead.org are


