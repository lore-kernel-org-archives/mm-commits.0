Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C84922B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671903; cv=none; b=RLp7ClwE0KcWiVXLD0Qi8xAzMY+LLfu+sF5Z6phGOrZYkGz1nQkyxmNNqzU4VjIToTsPOzt+TP8qXk1tcuystqajRqp84EBCit3TGNUJXH5G7Kk6UDuZr0vUg/W2/V4yj6U6rs1ofk3n/i/HTSJyrCKizvCmTPr7x8wh0xUSL7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671903; c=relaxed/simple;
	bh=rc8l7OLdu2ZoHyFxqcC10TBd/pKJratMEE60cxTU/zo=;
	h=Date:To:From:Subject:Message-Id; b=ErH0rghEm4fATn4+hMFDbTCDD+BghYxnR7qZSKIgs2e7W/1of21AOlDg497PQeTAZ2WBehxfGy4snuOKHJNq8Fk7bxHhntl4fx780pUGpcsAlHg5BsBt8H+RUkwxg+bwFuqBIagYgy3tHWDxhxGL7+OIjabfCfu8+Re/bxiYJg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=prPnTyqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="prPnTyqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C52C4CEF7;
	Sat, 28 Mar 2026 04:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671903;
	bh=rc8l7OLdu2ZoHyFxqcC10TBd/pKJratMEE60cxTU/zo=;
	h=Date:To:From:Subject:From;
	b=prPnTyqLbIoG3KxZBZlvx9uGsCCPd3JKTR65ULgAzu7wfgWZ4vtFT9drBj2RY9Mop
	 TtHG1uWAYu/KJOzZCDJzes0nWiDQO23MSM8zFeMcHnzeHtoeTI7TGUd/kmpFH16iyO
	 0vwiUj9rn6C7EG62AilG/k7gW4EdF9RDGJkgjfyI=
Date: Fri, 27 Mar 2026 21:25:02 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-glob-add-explicit-include-for-exporth.patch removed from -mm tree
Message-Id: <20260328042503.74C52C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: glob: add explicit include for export.h
has been removed from the -mm tree.  Its filename was
     lib-glob-add-explicit-include-for-exporth.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib: glob: add explicit include for export.h
Date: Sun, 1 Mar 2026 15:21:41 +0000

Include <linux/export.h> explicitly instead of relying on it being
implicitly included by <linux/module.h> for the EXPORT_SYMBOL macro.

Link: https://lkml.kernel.org/r/20260301152143.2572137-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/glob.c~lib-glob-add-explicit-include-for-exporth
+++ a/lib/glob.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 #include <linux/module.h>
 #include <linux/glob.h>
+#include <linux/export.h>
 
 /*
  * The only reason this code can be compiled as a module is because the
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

