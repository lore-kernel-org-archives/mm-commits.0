Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F583F39F1
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816287; cv=none; b=UwcBzElj/3PXNcwhN05BgoyNXy9YxK0sL2YScFEa+z7iqADY9frryuvK7zvTNgJfXh7uqEoz4zQS/YlnAmeRhzoZ0cbgsz1fMXVc7C8J63t/JuUR3cXwdu4kK6AOt8Vj5Va65NaGwcDk90j2PWeFbiOBcJojBEi2pZa7tbpf1vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816287; c=relaxed/simple;
	bh=RZqHGpJ0UnGsq68x8LO91uz21Q9REsnPY9DeJExhqTM=;
	h=Date:To:From:Subject:Message-Id; b=U/8E2UbfIuxR6t206b9NtFaYca4/N/LchqGArC2qoSQiOW1KS/ntJ0ve72vDTY+KK5rHqwsQLLkNlDACNZW5eRrXtcdmQBkYBkWw/CCAruhNrWb3Fy1JXP5MzpbM+FrXBKxOAG9xreGDzwE0aAIRTl74C8V5xGfZs0MKtVVQd2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=irrVMnff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="irrVMnff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39B41F00A3A;
	Tue,  4 Aug 2026 04:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816286;
	bh=AvK7N4c+h838mXme8uDm8BpXCs+ufVjVjPJlMaQofTA=;
	h=Date:To:From:Subject;
	b=irrVMnffsxliYFWlzBs6BZ6ZsLVqJx10ybG0Zz5/S/BDb8CPNtAQ2VW037EUpKla+
	 7tPImn7aKSlPqJ1kQyJ7RzTYCU82x4KvC+UrQfQRivwFfRoyY6/OArVgiMzccHAfYe
	 FE/9+x6VgHrHxob9uE9KiZuLwlhPjGLpvViVlfPg=
Date: Mon, 03 Aug 2026 21:04:45 -0700
To: mm-commits@vger.kernel.org,penberg@kernel.org,kees@kernel.org,joern@logfs.org,cl@linux-foundation.org,andy@kernel.org,akinobu.mita@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-string-fix-memchr_inv-for-large-ranges.patch removed from -mm tree
Message-Id: <20260804040445.F39B41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/string: fix memchr_inv() for large ranges
has been removed from the -mm tree.  Its filename was
     lib-string-fix-memchr_inv-for-large-ranges.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: lib/string: fix memchr_inv() for large ranges
Date: Sun, 21 Jun 2026 12:11:33 +0000

memchr_inv() takes a size_t length but counts 8 byte words in an unsigned
int.  At 32GiB that count wraps, so the scan can quietly miss most of the
range.

Use size_t for the word count.

Link: https://lore.kernel.org/20260621121133.16460-1-include@grrlz.net
Fixes: 798248206b59 ("lib/string.c: introduce memchr_inv()")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Akinbou Mita <akinobu.mita@gmail.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Christoph Lameer <cl@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/string.c~lib-string-fix-memchr_inv-for-large-ranges
+++ a/lib/string.c
@@ -821,7 +821,8 @@ void *memchr_inv(const void *start, int
 {
 	u8 value = c;
 	u64 value64;
-	unsigned int words, prefix;
+	size_t words;
+	unsigned int prefix;
 
 	if (bytes <= 16)
 		return check_bytes8(start, value, bytes);
_

Patches currently in -mm which might be from include@grrlz.net are

taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch

