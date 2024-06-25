Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0472176FDF
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338596; cv=none; b=GTp/AjnHL++Mqg6Pw2xFHcN6uF3i5mE1Nf/lMkLpIHxzRpks0q/Rii5/9cSdSK/IKqH2q3sAIZAh4utYwVUVJtIgVEGmhB5MCOBhEqaKqoLu9bP2ksBvU05175HJKwZTG0hQZUPVSVHaqx+m9uuW+KuEDbO5Xt1tE9d+s1Wv0Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338596; c=relaxed/simple;
	bh=oX6v+D7Z+8hJEaHkVDpBF665Uk/PeUUnlDXNYhNMG+I=;
	h=Date:To:From:Subject:Message-Id; b=Lm7iP+WY0/Hd+op/FX7Z6hxKAr991ppWcMwUl1kPLR9q/t5WbFr+SPcmoI5NVrFH1T4ZM18Oyddb/0uk6/K3oILMI1KXfHYGXzyE2dt1UQAx55jxIoPxi1apKbNSLlw5PbhFStU/TfnWbYAsZ4T5pblivhEKIE9lAU/5gL9dlUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vm63dbOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vm63dbOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647F7C32786;
	Tue, 25 Jun 2024 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719338595;
	bh=oX6v+D7Z+8hJEaHkVDpBF665Uk/PeUUnlDXNYhNMG+I=;
	h=Date:To:From:Subject:From;
	b=Vm63dbOvqMsxqItLIBkQKnavmCyaKL87A/nIR0LHh3iHp1BflAID9uplaRBcpMaKW
	 9N72zUOyynu1dG8fj2U2A4VAxoHGyH1sjzfApMTnDMYraTzVKM4l4BjFnbfh+19Xri
	 3sGK8N1z4IhtHcQULN8PPoStDUitdzw4p/9m3VfM=
Date: Tue, 25 Jun 2024 11:03:14 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch added to mm-unstable branch
Message-Id: <20240625180315.647F7C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch

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

mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch

