Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3071EB5E3
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775004655; cv=none; b=N6ybxxx2MxPWBtYGCeo2r3no/kwoJ8h/XBQLC9VJw+5Ps4UrfMQyACBz+uZasteCPru9YJf+b04WMEOpBFfbKMqkYV0QD3MTZLl6QQvnTBUC8zZ1QQ4O1PayZjqluDlRjOu5gLmuQrmqmkMOSXo7fknrNIMQg8qK9E68BRm3jKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775004655; c=relaxed/simple;
	bh=clow05E1eaLISHVFv/olE/eS+f1tclYtnR4IxdsW+yw=;
	h=Date:To:From:Subject:Message-Id; b=ZuX2Vb8jYY8MxuAo385mOC9kwNf4iof7IFQQPYXrtYYLqXhvq+/Z9RxbOrkvFR4NsgQzkkHwMZ3tkqjDqNYRwB7ipexXnXdPpbPQlSv6iRHXQd5LLkUvZ7fbFAlEi9pFBsQeGrbNVKJiMNiQNzstNMeurXKbANSzu2bVTRArbR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YQatcVTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YQatcVTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21033C19423;
	Wed,  1 Apr 2026 00:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775004655;
	bh=clow05E1eaLISHVFv/olE/eS+f1tclYtnR4IxdsW+yw=;
	h=Date:To:From:Subject:From;
	b=YQatcVTRasS3cVjuQC2l1vny6q+5ekuX0SlJOLU++enoQV5yDjdUREAcXxtwWyUpk
	 tyvva57XxehvRO6OYBPnYTx22sJKvBW6hSGNwsqMuY+a/9teoTZ0PMqWmt+d3sSD8L
	 SQRIxgC9RN+qCzUptaaG6F1KdpUWSBjGtG4mKfDQ=
Date: Tue, 31 Mar 2026 17:50:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch removed from -mm tree
Message-Id: <20260401005055.21033C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-merge-test-for-partial-msealed-range-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch

This patch was dropped because it was folded into selftests-mm-add-merge-test-for-partial-msealed-range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-merge-test-for-partial-msealed-range-fix
Date: Mon Mar 30 05:12:35 PM PDT 2026

fix build

In file included from merge.c:4:
merge.c: In function merge_merge_vmas_with_mseal:
merge.c:1229:27: error: __NR_mseal undeclared (first use in this function)
 1229 |         ASSERT_EQ(syscall(__NR_mseal, 0, 0, ~0UL), -1);
      |                           ^~~~~~~~~~

Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-merge-test-for-partial-msealed-range-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -6,6 +6,7 @@
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <asm-generic/unistd.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/prctl.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch
selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

