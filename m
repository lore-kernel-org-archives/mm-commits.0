Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C48182B7
	for <mm-commits@vger.kernel.org>; Sat, 31 May 2025 00:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748652683; cv=none; b=XVbTOPD6To2v9oNowk2CAy1VhZEC+mUm/RvvIoCaoSay3Q/pW5+9umpWPVdEUvPu70fYRElQwk9M0MioQzBTa9jkNEwtGqGy6TXTPrCPX3B6DFyWHr9+LPVYk8Efhb0bqUflAM70HDiIC2HuL9o+C+tpByr6TKVWQE6BIIJMnag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748652683; c=relaxed/simple;
	bh=kFWylVHZFNcQjhmOMot2yeI+2a1I2enheoQuCCz9YIs=;
	h=Date:To:From:Subject:Message-Id; b=qZKbNsUeYENaXhH0/wmHtYF/mCkAevIrcMxdRuAaBioGNrHueGs49VtaK10sfuQCLmZz639hEOoB4EhGNGHgIJhxn++yujKA3lu7LYUj+CTLzulkqNCQVIGHiIVF31TscaOh5AzwEQITHmb9qNz8QKFM/W3yFbgUygxuKBzsqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cjytgHpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cjytgHpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E84EC4CEEB;
	Sat, 31 May 2025 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748652681;
	bh=kFWylVHZFNcQjhmOMot2yeI+2a1I2enheoQuCCz9YIs=;
	h=Date:To:From:Subject:From;
	b=cjytgHpDvOmtejdJx7yY561TT0wdWjSPDNsTFgzfn4S3wnSSnaC10gm80CaaQuGsF
	 4wV6mDMFHZHa1CxwEVk22iA4ipa6/f46L1pFgQVAd5XHsMcM6GC4zNI7hfUZyo0KYL
	 uv9YswL8XD3O47Uyl71mUcYnfMOX1ElXtXT/2GSg=
Date: Fri, 30 May 2025 17:51:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pulehui@huawei.com,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch added to mm-unstable branch
Message-Id: <20250531005121.9E84EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix
Date: Fri May 30 05:50:22 PM PDT 2025

include sys/syscall.h, per Lorenzo

Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Lehui <pulehui@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <sys/wait.h>
 #include <linux/perf_event.h>
 #include "vm_util.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-expose-abnormal-new_pte-during-move_ptes-fix.patch
selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

