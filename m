Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1A2175A6A
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100779; cv=none; b=avNh7IEZkZhDz608PsQnnTMLz+J/Vj4YHx/1DXAUsMTzeNcKKFK0TdwJboYn5FGQA0xc/DB5S89GGylp6PJHWLY3KoYUjh60CCIpmBix4axg5PIaOOMrUmYuCaaU0G9eTYVxEB0HQj+B1CgE/PhW0nZiUIyOOqZoAVOYVJyrqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100779; c=relaxed/simple;
	bh=FOZZHK2tatkozJGiPanD86Bn17Dm4ZsQ94+IQG95pH8=;
	h=Date:To:From:Subject:Message-Id; b=J233Koa9GP5TymFsx01EbqDfXzBKqKcvWEEZLFICxwssZKy4HCNgk5dldN4v7wFQw889JLoakGMKqwog8FjFcC/BXSeAVFa8J4H7fMmVF0zXc1ix23+i/hH7pu3TeVfRW7ajiisVycksiAYsaP1yfniemUi7xjcLoRgQYPc4DcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S6W2Deap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S6W2Deap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC88C4CEF7;
	Thu,  2 Apr 2026 03:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100778;
	bh=FOZZHK2tatkozJGiPanD86Bn17Dm4ZsQ94+IQG95pH8=;
	h=Date:To:From:Subject:From;
	b=S6W2DeapXF0N/FXw0hfWB5Muki1XYQk5cK0/C72MlRxf4DEdaoPkbW9BR171FrDSh
	 WUujfCgnxS1i1+DyEV75kVp2mOGGRbh89qURTf1fOR87GsFEaDHbdEkMGlJDBnL0IC
	 Us7izUPxlMryifWchCJ76GQe6t3A6WtkVQExAoss=
Date: Wed, 01 Apr 2026 20:32:57 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-vm_util-robust-write_file.patch added to mm-unstable branch
Message-Id: <20260402033258.8AC88C4CEF7@smtp.kernel.org>
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
Date: Thu, 2 Apr 2026 09:45:41 +0800

Add three more checks for buflen and numwritten.  The buflen should be at
least two, that means at least one char and the null-end.  The error case
check is added by checking numwriten < 0 instead of numwritten < 1.  And
the truncate case is checked.  The test will exit if any of these
conditions aren't met.

Additionally, add more print information when a write failure occurs or a
truncated write happens, providing clearer diagnostics.

Link: https://lkml.kernel.org/r/20260402014543.1671131-5-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-robust-write_file
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -767,15 +767,24 @@ int unpoison_memory(unsigned long pfn)
 
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
 		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+	errno = saved_errno;
+	if (numwritten < 0)
+		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
+				buf, strerror(errno));
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

