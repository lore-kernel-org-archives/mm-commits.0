Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009C1533D6;
	Thu,  2 Jul 2026 02:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957809; cv=none; b=Mez1Se6W9I0+3XPrHjqefL11DXLzw8fl38Ry4qJJ9gGuwelk8dKzTNQDYj2oVPRjIeEeaVK2rV9BxIQx0XNsw3Dd5MTGjyYZB1d+KOyvCU3uuJEVbymltwECCckHSlH6inSGkslFcWdrrqb098wlaBsiu8ZhRJG0lxqMLjEgWW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957809; c=relaxed/simple;
	bh=R9m+PIIvrdJACQL1pc6fp0Yasf5Vz/CAGATDcgkgRl0=;
	h=Date:To:From:Subject:Message-Id; b=YUq2b26iNHlUuaODLSBNPX94/ykpxWOWHAONRpcQ6ksLfwcoj6IsOOOwkkgy5L3SxQF/Y17uf28zK7IC1p3wcC6xvNaNt4WTUUzhHc8zECCntR5uEFgsRQRDIr1MdR8SmtaRHvfB+VT6Ts7y2VlIgDKeY7El6f5lxk+/piXSXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IjH/YnAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IjH/YnAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750281F000E9;
	Thu,  2 Jul 2026 02:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957807;
	bh=NKxnObE8dSSzelyVDyM98+YZsFq3lckxHKs/8JxCRrY=;
	h=Date:To:From:Subject;
	b=IjH/YnAhoWFV6fvirautY+yuGDH8JbDXnNa4ULd6gz/d39z+7C4bKdIE5jzHtW2GI
	 ooOO1cu/xrmmw8AAHWCSKWxJH1Lp1A90p3+OmNzuFm5v+wd42UttsqoJnbKv7JkcIj
	 kYgZTaBw9FIlrtjDP27lRqlRQWR/O+RrbBzJkFY8=
Date: Wed, 01 Jul 2026 19:03:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-ksft_process_madvsh-test-category.patch removed from -mm tree
Message-Id: <20260702020327.750281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix ksft_process_madv.sh test category
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-ksft_process_madvsh-test-category.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: selftests/mm: fix ksft_process_madv.sh test category
Date: Mon, 8 Jun 2026 16:02:24 +0530

ksft_process_madv.sh currently runs run_vmtests.sh with the mmap category.
Update it to run the process_madv category, since ksft_mmap.sh already
runs the mmap category tests.

This avoids running mmap tests twice and ensures that process_madv tests
are run through the kselftest harness.

Link: https://lore.kernel.org/20260608103224.344101-1-sarthak.sharma@arm.com
Fixes: 6ce964c02f1c ("selftests/mm: have the harness run each test category separately")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksft_process_madv.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksft_process_madv.sh~selftests-mm-fix-ksft_process_madvsh-test-category
+++ a/tools/testing/selftests/mm/ksft_process_madv.sh
@@ -1,4 +1,4 @@
 #!/bin/sh -e
 # SPDX-License-Identifier: GPL-2.0
 
-./run_vmtests.sh -t mmap
+./run_vmtests.sh -t process_madv
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are


