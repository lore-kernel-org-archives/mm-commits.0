Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4632F15AACC
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663845; cv=none; b=bTxEivf8W9PEa0H20992Ojb+zEKuIsBis8QQNeLX+9LaNLEbdAZg9kIoHkaFpGFsIOzIj6qinw5JkhK5w0dApz89DhMPX+hw84HKtEeWfjKtx6JNAkkrrgnCuzHxvboRWjyjHcKuFGymMD8CwWiE1Tmuny/mpbX4N1ZuGcM07UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663845; c=relaxed/simple;
	bh=yHc2xU8U+7CMPr5esWuCDdnWJ8NE7iXylQNxm+hpKLE=;
	h=Date:To:From:Subject:Message-Id; b=hzJJDPatZXltvYISsxBX7plENJlOESg39fVTUB98a220GR8M11DevtozMuimcyGrMbJV0doVMTb38Kj4cMUSpdDu0cc8QKIbuAINu3hk1JqbxJ2n4SHhhZwRLO96gJU6uxNNoSOqpmxrvdoEozFCsaRiPUyjWR1yEGp0JSRqkTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KEPkUC9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KEPkUC9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85AAC113CC;
	Thu,  2 May 2024 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663845;
	bh=yHc2xU8U+7CMPr5esWuCDdnWJ8NE7iXylQNxm+hpKLE=;
	h=Date:To:From:Subject:From;
	b=KEPkUC9oH2fwLOSwl1BhIzB9hyyIcxz2ZKevpZhL0o7BuKMME9yXIgvroO2XQnyd0
	 vMjq7VDcjSM2FGoxiVS2WhD0xNYfz/5Eg1ExHteuAXcdiX8jUARwrlgaCxHaS8lCpO
	 LRKwI+D+2Gex/sHgJoEk3sZOxPCH8m6by44MIIp4=
Date: Thu, 02 May 2024 08:30:43 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jeffxu@google.com,gthelen@google.com,cyphar@cyphar.com,sauravshah.31@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-fix-spelling-mistakes.patch added to mm-unstable branch
Message-Id: <20240502153044.C85AAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd: fix spelling mistakes
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-fix-spelling-mistakes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-fix-spelling-mistakes.patch

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
From: Saurav Shah <sauravshah.31@gmail.com>
Subject: selftests/memfd: fix spelling mistakes
Date: Thu, 2 May 2024 04:43:17 +0530

Fix spelling mistakes in the comments.

Link: https://lkml.kernel.org/r/20240501231317.24648-1-sauravshah.31@gmail.com
Signed-off-by: Saurav Shah <sauravshah.31@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/fuse_test.c  |    2 +-
 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/fuse_test.c~selftests-memfd-fix-spelling-mistakes
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -306,7 +306,7 @@ int main(int argc, char **argv)
 	 * then the kernel did a page-replacement or canceled the read() (or
 	 * whatever magic it did..). In that case, the memfd object is still
 	 * all zero.
-	 * In case the memfd-object was *not* sealed, the read() was successfull
+	 * In case the memfd-object was *not* sealed, the read() was successful
 	 * and the memfd object must *not* be all zero.
 	 * Note that in real scenarios, there might be a mixture of both, but
 	 * in this test-cases, we have explicit 200ms delays which should be
--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-fix-spelling-mistakes
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -1528,7 +1528,7 @@ static void test_share_open(char *banner
 
 /*
  * Test sharing via fork()
- * Test whether seal-modifications work as expected with forked childs.
+ * Test whether seal-modifications work as expected with forked children.
  */
 static void test_share_fork(char *banner, char *b_suffix)
 {
_

Patches currently in -mm which might be from sauravshah.31@gmail.com are

selftests-memfd-fix-spelling-mistakes.patch

