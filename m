Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935D0171E7B;
	Fri,  5 Apr 2024 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341333; cv=none; b=bUF7jYG3l5v01keNXOuX1Np2d/a/wOBqGeSpK2hOKHPl5ffd/Vh2ZtQe1ouaiJ/Cpyu4bYhhJcchjFmRNEsA2IDpWO5CzWSzQlOiDzM/uy12m9WXZCsR1r1i61MP2DF1xS3owV3ugtbnfUC0b0lzbbJeEtLH2vouWOJEvEZHx1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341333; c=relaxed/simple;
	bh=h6Ev3p+d5gbVveyZ0AKmJBw3rwYBnKaBxaQIejBb1iY=;
	h=Date:To:From:Subject:Message-Id; b=QbXAE2Wx/yV9i0eFoab5nTMqgpMqgwMRvqnKvM41VYAV/lrPuO/f8E5enrBGLu+C+OjLaJhOdO/Wb0wj7yIHDrCm5ZfsKMxK+Nt/ReYRnqK2HSjyYUcuJvKDp9oq9B1PZOTq94xfF2pjQjR4BjOumVAyXrwoG3+CjdlDLEDK44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghlJ65Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghlJ65Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CD3C433F1;
	Fri,  5 Apr 2024 18:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341333;
	bh=h6Ev3p+d5gbVveyZ0AKmJBw3rwYBnKaBxaQIejBb1iY=;
	h=Date:To:From:Subject:From;
	b=ghlJ65LrdGHWiQQ0kFfdC4iZBrQyULgwjst523bRt7OSk2qT1dEKsZYR6J8X0cTm2
	 drDUwGlr+pKbYAIHW6hFcfCkdG36ndZuWBwSOrH3qD1bZdlrQkCb28jKXB4mRNpTSv
	 CTE6+mgtI4EuIzcZfJE4TLglmA092qgBnOkp0rZA=
Date: Fri, 05 Apr 2024 11:22:12 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,david@redhat.com,axelrasmussen@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-include-stringsh-for-ffsl.patch removed from -mm tree
Message-Id: <20240405182213.17CD3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: include strings.h for ffsl
has been removed from the -mm tree.  Its filename was
     selftests-mm-include-stringsh-for-ffsl.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: include strings.h for ffsl
Date: Fri, 29 Mar 2024 18:58:10 +0000

Got a compilation error on Android for ffsl after 91b80cc5b39f
("selftests: mm: fix map_hugetlb failure on 64K page size systems")
included vm_util.h.

Link: https://lkml.kernel.org/r/20240329185814.16304-1-edliaw@google.com
Fixes: af605d26a8f2 ("selftests/mm: merge util.h into vm_util.h")
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-include-stringsh-for-ffsl
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -3,7 +3,7 @@
 #include <stdbool.h>
 #include <sys/mman.h>
 #include <err.h>
-#include <string.h> /* ffsl() */
+#include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
_

Patches currently in -mm which might be from edliaw@google.com are


