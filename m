Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC07491
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560181; cv=none; b=utieGgbuKr0g8Fe3Qd6F8V+gC0Uxw+ehX2BHYMAyOnJK3eFBZBN/hOzncpoXdC4w6ZAKO6jf55KAg7ZltmN1/bOnAovrwVNu2cNt+lSH3PgLbkNnCHRES5ZDbWViH0vr9CmoY8K78qBjLhghB2a5Vcb4W5+VKSqrgwZrp27sx54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560181; c=relaxed/simple;
	bh=w8OuOV+TAWwqpmSxcFTlZSV6llYoDmdDo9Y6heIMzEw=;
	h=Date:To:From:Subject:Message-Id; b=NRO9d2+lrb6t8zDqO8SHeY5nqWuiT0zpUn7LX7vbpMQJ1+9cslhA3edE/XR26r2OWL3BaATW1uEa8VBkpyRqCoTpGBIs/NCetXgFE1U+8hogSYV+yOM1IwMtZe3Eew5HWttKxoOoRFV7Y0JZlm5mW1UQEHYDgNF7lfx9H5DXBhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VFN3zYca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VFN3zYca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF82AC433C7;
	Thu, 22 Feb 2024 00:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560181;
	bh=w8OuOV+TAWwqpmSxcFTlZSV6llYoDmdDo9Y6heIMzEw=;
	h=Date:To:From:Subject:From;
	b=VFN3zYcaU0kHPoMOgIY5XTISqQc1iGkS6rQLJgltKggDyLfusGOP0o0RYMQ9UgTla
	 Non6iFFfK0wR3pSVlKA3zi6vYqeCssK/F/uFl+odPYMabBxsY01q858aBGnDYCzuAo
	 9yVKtG8eRCL75nw1v/LXNsiYjXoKKKMYhbZAQ6G8=
Date: Wed, 21 Feb 2024 16:03:00 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,jsavitz@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch removed from -mm tree
Message-Id: <20240222000300.DF82AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: add hugetlb test category
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: run_vmtests.sh: add hugetlb test category
Date: Mon, 29 Jan 2024 03:52:46 -0800

The usage of run_vmtests.sh does not include hugetlb, which is a valid
test category.

Add the 'hugetlb' to the usage of run_vmtests.sh.

Link: https://lkml.kernel.org/r/20240129115246.1234253-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Joel Savitz <jsavitz@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-hugetlb-test-category
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -64,6 +64,8 @@ separated by spaces:
 	test copy-on-write semantics
 - thp
 	test transparent huge pages
+- hugetlb
+	test hugetlbfs huge pages
 - migration
 	invoke move_pages(2) to exercise the migration entry code
 	paths in the kernel
_

Patches currently in -mm which might be from leitao@debian.org are


