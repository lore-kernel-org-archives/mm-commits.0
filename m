Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA3B13541E
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291735; cv=none; b=VuCy+BSv9nIIKs9YyuqpgvPX3YMSJ90phLlZWddpW2dT1x2OUIME/VLxWDi68y9YBOmgaU3LT1Bq9DwNIfwcDBQbJlYKWTOlcC5EDOo1vOTqBNX0lOtKt5EsrR09FxjvrtdWrg1XPOkK8Suor5xhzTL9O9UFwRJIm0BBeCqRUoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291735; c=relaxed/simple;
	bh=xViK/5HPyA1wiUsrPBXh4whTpZfGrF3a2qiAOLJ9YDI=;
	h=Date:To:From:Subject:Message-Id; b=C4ozWZArwz/YTwZZ24nW0XQDmIpWecg9PGGS/J13msB7tb5muFq3NypDP6Yu76k6BwspzeGro0wy0LvZVwPh2OV56E8IfLOMW4rMytdgfbAIT8ed1q9Oa3nH85umyqosjBE2iUVagZn6ZyOHO1otrQy1s9WVJhIjHaStISNzjCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WSdpY7+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WSdpY7+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F912C2BD10;
	Sat,  6 Jul 2024 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291735;
	bh=xViK/5HPyA1wiUsrPBXh4whTpZfGrF3a2qiAOLJ9YDI=;
	h=Date:To:From:Subject:From;
	b=WSdpY7+oudHJ2B0I4/FHwBAtCF3SlmocZHxlAdVH+KEF5vuIRC8q1CLMRcRIACYcw
	 fzSYMjGDPzJN5bwdV+5hROIUxrWHVI8u/RUiyyK79i5GWLO/kM0KmYeJcfTgQ71Gqw
	 YVBfgcOdN4LoJy71Q0+31SDjbh7foL+Fr6SKDQeI=
Date: Sat, 06 Jul 2024 11:48:54 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch removed from -mm tree
Message-Id: <20240706184855.0F912C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix
has been removed from the -mm tree.  Its filename was
     tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch

This patch was dropped because it was folded into tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix
Date: Tue Jun 25 11:01:55 AM PDT 2024

tools/mm/thp_swap_allocator_test.c needs linux/mman.h, per Kairui Song

Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/thp_swap_allocator_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/mm/thp_swap_allocator_test.c~tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix
+++ a/tools/mm/thp_swap_allocator_test.c
@@ -27,6 +27,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <errno.h>
 #include <time.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch

