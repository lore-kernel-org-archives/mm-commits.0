Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036A5397E7D
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898771; cv=none; b=tyavskcd34hgRM/ZVMywFp+CIAlgZAmJ6IUyudJr+PMj4wbvGUinvATkNZFav9HTcXWsbwvOy6yftENXedwalFwvByEKh1CsMX/tmu4gaF52hrh6fj+L1syi0P2yElnzHRhch7x/6XgIUd6TALDR7XqdYWoO3oO1wz1Mr0y8gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898771; c=relaxed/simple;
	bh=5QyjXsACVjVqLfYZ2sp5blVK7i0rvEz5q2CsLhFWWmM=;
	h=Date:To:From:Subject:Message-Id; b=Ge6HggkbN6fWV8Kc34V1I5ZGh61wCdTH3mjvISMlrbGeLLXYpc9WrDjRfahE/01qj3Ds+9HXtgOKVXVyHO6H5wBzbM1z8RQLKLU4geFIBog3Qw8zvsEFa09offwjWnQk4XHsZZNscOSEZMBGiRyVZZ12/UK7XVbtqrPJMrueP+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rZ2LvHQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rZ2LvHQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C25EC2BC9E;
	Mon, 30 Mar 2026 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898770;
	bh=5QyjXsACVjVqLfYZ2sp5blVK7i0rvEz5q2CsLhFWWmM=;
	h=Date:To:From:Subject:From;
	b=rZ2LvHQ9MBqs5LNU8KAKB/Q9sC+jqZ27K4rp9XSkptQ7SORncyeqy7wI20ZCye+c5
	 P7Ydl9v6T57DmMGMh2dGR2KN1S2RWxVFN3bmlihV/nBUTolkqP0rI9Rya3X9orVtmE
	 GizyRbB5WAn+NJS1eojfOuCisWgL4oEqt6hXANak=
Date: Mon, 30 Mar 2026 12:26:10 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-vm_util-robust-write_file.patch added to mm-unstable branch
Message-Id: <20260330192610.9C25EC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/vm_util: robust write_file()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-vm_util-robust-write_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-vm_util-robust-write_file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm/vm_util: robust write_file()
Date: Mon, 30 Mar 2026 23:15:01 +0800

Add three more checks for buflen and numwritten. The buflen should be at
least two, that means at least one char and the null-end. The error case
check is added by checking numwriten < 0 instead of numwritten < 1. And the
truncate case is checked. The test will exit if any of these conditions
aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Link: https://lkml.kernel.org/r/20260330151503.670415-6-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-robust-write_file
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -779,15 +779,24 @@ int unpoison_memory(unsigned long pfn)
 
 void write_file(const char *path, const char *buf, size_t buflen)
 {
-	int fd;
+	int fd, saved_errno;
 	ssize_t numwritten;
 
+	if (buflen < 2)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
+
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+		ksft_exit_fail_perror("%s open failed", path);
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+	errno = saved_errno;
+	if (numwritten < 0)
+		ksft_exit_fail_perror("%s write(%.*s) failed", path, (int)(buflen - 1),
+				buf);
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

