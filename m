Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F4DA32
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248843; cv=none; b=GbBl+k8EC2SLoEA5bBeYmz/1qAlh2mC3dXgVDmEcYdp4jmzPqbN3utcxah7Ac5pPe4/OTco1wiTtdgichVVGy7Vfz6y/NS+4Uql1cxhaepJSyrTNMszInYNe9LHFXfYVneKSInpIkkmlg+sNYwA6YABeo+talk0a0kjG7YWjqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248843; c=relaxed/simple;
	bh=7YYbcBT38LkemBFoF01/EMhyDfy/gC5/C469H3R6eAU=;
	h=Date:To:From:Subject:Message-Id; b=e3hYl5FYnuRj4FrPyhhPhHWePUsqPigMcJX3kj9XML+KEkK7VyfuQzbqrsZC3wIjsfIg7/DXRbiNgeqJtejw7NIDuTOhkW5S9HgZOseAQx8GF7gvYAWysHAqHsQH8x0fG6u6a9QQewsSy8y32O0M7xq9PIcw+IoRi8zCfqI9NZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBoSQ3/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBoSQ3/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C51C4CEC2;
	Mon,  2 Sep 2024 03:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248842;
	bh=7YYbcBT38LkemBFoF01/EMhyDfy/gC5/C469H3R6eAU=;
	h=Date:To:From:Subject:From;
	b=YBoSQ3/DnCXLRhr7/OsYuu1OcetfVKQG9/fvv5298NMS+wlLgNb1DBLEkO0XY5LJL
	 yhJJL4+rYfnythjNqRCZQYoVGhU6k4rOpJOfarqE0D6M4Ef8yLqr0Am41GnhF+6xhi
	 g4tDnYsUY6r+EfHx5kcI+zFvlJFeGa1s0q3oHG3s=
Date: Sun, 01 Sep 2024 20:47:21 -0700
To: mm-commits@vger.kernel.org,11162571@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-fix-the-null-vs-is_err-bug-for-debugfs_create_dir.patch removed from -mm tree
Message-Id: <20240902034722.89C51C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: fix the NULL vs IS_ERR() bug for debugfs_create_dir()
has been removed from the -mm tree.  Its filename was
     lib-fix-the-null-vs-is_err-bug-for-debugfs_create_dir.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Ruibin <11162571@vivo.com>
Subject: lib: fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed, 21 Aug 2024 03:34:40 -0400

debugfs_create_dir() returns error pointers.  It never returns NULL.  So
use IS_ERR() to check it.

Link: https://lkml.kernel.org/r/20240821073441.9701-1-11162571@vivo.com
Signed-off-by: Yang Ruibin <11162571@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_fpu_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_fpu_glue.c~lib-fix-the-null-vs-is_err-bug-for-debugfs_create_dir
+++ a/lib/test_fpu_glue.c
@@ -42,7 +42,7 @@ static int __init test_fpu_init(void)
 		return -EINVAL;
 
 	selftest_dir = debugfs_create_dir("selftest_helpers", NULL);
-	if (!selftest_dir)
+	if (IS_ERR(selftest_dir))
 		return -ENOMEM;
 
 	debugfs_create_file_unsafe("test_fpu", 0444, selftest_dir, NULL,
_

Patches currently in -mm which might be from 11162571@vivo.com are

tools-mm-check-mmap-based-on-return-values.patch

