Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A313B156257
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727257058; cv=none; b=iqOEAzWkwpWYgToauP7AoQInLTFMBmkzShwePNXeaEVgpYyCtm8uJhBuA9tVeokpkaOM92NmUWJrjk+NFLGRZN483aSiaRQAcbrw5o+fs6039+JPio8KLJORJ7o6Vu9TL+wG5Olf3SuetzYmpXbArS/qKo8FT89NoYBR+pGtTNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727257058; c=relaxed/simple;
	bh=dWbM2ZBlwZ9zq8TwqotwBAl4F/jmZTKajhNWLAtPc1Y=;
	h=Date:To:From:Subject:Message-Id; b=MEWsD9NQkDTRPrWmQJTy0rJt5LDqDTKkTTeCcDgSopzeOUkp/vr5rB2+pIQfN5lFtVzv/jxnmlmLpCmSu6J+Tpf2cJB1Ah38PtF6lodf7TQfhul+CJGA6GPivh98oA+2JpSk+mMWHHAnRZVyFwKb5Un35zee/8TwQlBOFqytpsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V/UM5wTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/UM5wTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187EEC4CEC3;
	Wed, 25 Sep 2024 09:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727257058;
	bh=dWbM2ZBlwZ9zq8TwqotwBAl4F/jmZTKajhNWLAtPc1Y=;
	h=Date:To:From:Subject:From;
	b=V/UM5wTjzZ5Th3jnqOo300GdGo8YpC+RO27ce+ldIIZ/Sr0bLKEhmH9e3zrgNiNJ8
	 WuQjTy5kvJdP3vYI/5wQNSSf/0LCxmKuF7hioPiVXo+eQnmzZkrY6o3s3rRZM12R8k
	 QAw2ssqvR3nTTCSJdMgcuaVbiWzxF3/gA6DuLXAI=
Date: Wed, 25 Sep 2024 02:37:37 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-mm_access-to-not-return-null-fix.patch added to mm-unstable branch
Message-Id: <20240925093738.187EEC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: procfs: prefer neater pointer error comparison
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-mm_access-to-not-return-null-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-mm_access-to-not-return-null-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: procfs: prefer neater pointer error comparison
Date: Wed, 25 Sep 2024 08:48:27 +0100

We can compare a pointer to a known error code via PTR_ERR(ptr) == -EINVAL
or via ptr == ERR_PTR(-EINVAL) - the latter is neater and collects the
macro and constant in one, so refactor to use this form in
proc_mem_open().

Link: https://lkml.kernel.org/r/2fae1834-749a-45e1-8594-5e5979cf7103@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~mm-refactor-mm_access-to-not-return-null-fix
+++ a/fs/proc/base.c
@@ -841,7 +841,7 @@ struct mm_struct *proc_mem_open(struct i
 	put_task_struct(task);
 
 	if (IS_ERR(mm))
-		return PTR_ERR(mm) == -ESRCH ? NULL : mm;
+		return mm == ERR_PTR(-ESRCH) ? NULL : mm;
 
 	/* ensure this mm_struct can't be freed */
 	mmgrab(mm);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-fix-shared-radix-tree-build.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-madvise-introduce-pr_madv_self-flag-to-process_madvise.patch
selftests-mm-add-test-for-process_madvise-pr_madv_self-flag-use.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch

