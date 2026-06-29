Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CD039282B
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782757620; cv=none; b=Wi/ZE0RVk6u3vcF84soBQzXU02kK7eTHHAtg45v9Jt9X5OdRaYMCQi1sl8yxUlMhG1I7r3kMSH9G8ZHwtx92HOORSgGn4oqJMIQMn7+mcuiPETE64KyR2jNLNbhWiSFVCV+WiVUKtLVh1v4hkq6pUjUanQ5N1dRtozSkuUDOwrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782757620; c=relaxed/simple;
	bh=dwCr9G9ViuU7haUetsxYc9gpCd9IZMMpwPauxSqUg9Y=;
	h=Date:To:From:Subject:Message-Id; b=FBx4BnFNdXNP1ThEx01R0Nrk2/WxWoBXabkg+E/PlvaKGEm/cA+87PR7QRAuqV9SpVOjjNpC5r39WHosv8RESefwEkRS4a8SHJxpqfF9SYYusOPDfbfPNpthRNTR3UNxdNQAvbI/WA++lVJz9/e4x03un2t5eaYTgwWiEujW+N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jb7Nrt+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jb7Nrt+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7273B1F00ACA;
	Mon, 29 Jun 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782757617;
	bh=/xurefpbBUA8AB7FAiGn4QKXKAysPP/co7D98IFNHFw=;
	h=Date:To:From:Subject;
	b=Jb7Nrt+/8SoUnqgxUz3ppIcWR9eD94EC/Zc/o5taBFGcgYH19prlq/Y2UFkOEjRlu
	 9OxqK+NayUGUdj2c8ZnXX+2hPxX1IS2sZwntzhqgdmNAfbhhchNpYhGKFVOYrIE5iW
	 kAtvy22GjUZEmYhFRSFWRo8Q+yQ0gxpWTXMk7cRE=
Date: Mon, 29 Jun 2026 11:26:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kkernel.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-fix-typos-in-kconfig-help-text.patch added to mm-new branch
Message-Id: <20260629182657.7273B1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: fix typos in Kconfig help text
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-fix-typos-in-kconfig-help-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-fix-typos-in-kconfig-help-text.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: samples/damon: fix typos in Kconfig help text
Date: Mon, 29 Jun 2026 07:55:35 -0700

Fix a couple  of typos in samples/damon/Kconfig help text. Change "Thps"
to "This", and "tierign" to "tiering".

Link: https://lore.kernel.org/20260629145538.134832-5-sj@kernel.org
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Philippe Laferriere <plafer@proton.me>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: SJ Park <sj@kkernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/damon/Kconfig~samples-damon-fix-typos-in-kconfig-help-text
+++ a/samples/damon/Kconfig
@@ -31,7 +31,7 @@ config SAMPLE_DAMON_MTIER
 	bool "DAMON sample module for memory tiering"
 	depends on DAMON && DAMON_PADDR
 	help
-	  Thps builds DAMON sample module for memory tierign.
+	  This builds DAMON sample module for memory tiering.
 
 	  The module assumes the system is constructed with two NUMA nodes,
 	  which seems as local and remote nodes to all CPUs.  For example,
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are

samples-damon-fix-typos-in-kconfig-help-text.patch

