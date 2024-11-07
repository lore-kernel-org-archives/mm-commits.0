Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00AC21832F
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019127; cv=none; b=uPtFy0LtB5NkSyDLvzCmKj1g8qMiyzQrqe9t12Sz6gTtSL141DIS9Luzx3S5a6oZQhGWOtnZAMtEOftOXQCEGiY7fGt55ucTvavY2PdtbfDT+2Sv2y4K6iP5aK2PnaR9sQ2pwjwxVM9bTqj1mBpFok3YiNG8NUzR9HjP0QQZjTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019127; c=relaxed/simple;
	bh=ooVWUtvorqoQLGdpOH5ptCn3BjNx9b6InMA0gYzUJY4=;
	h=Date:To:From:Subject:Message-Id; b=JWRkgd+2n+JFDrzMEqOKSRHy/Oaj4WJTerqmSEbxY+vsNZ0/ZMSJ+1wav86qG8q59A7AcXaV0Mbb3EQz5I0fq1EH0LxJm/J+aznxWK/pST1pols2QaSQGTGAvongjaM2VtzQNKYk/U3JGilbShbJ+7qryxQgwylHJ9phzflM5eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMIng9TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMIng9TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95925C4CECC;
	Thu,  7 Nov 2024 22:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019127;
	bh=ooVWUtvorqoQLGdpOH5ptCn3BjNx9b6InMA0gYzUJY4=;
	h=Date:To:From:Subject:From;
	b=IMIng9TACXFwd4XU8+lYv7VitS3Loi6nXe14+w11aFM5l8RklqLyby6y59IOmD3EB
	 IqgYqDh/Lq0w5V1k6CERouXjjrWzJu/0wGlXYIM+jtf/86aVxZs1jEK4SWAKNDtfFb
	 MrlCjid4TbB03r7FZnH1nqRZO6271ZCCajVdYtZg=
Date: Thu, 07 Nov 2024 14:38:47 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read.patch removed from -mm tree
Message-Id: <20241107223847.95925C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/huge_count_read_write: provide sufficiently large buffer for DEPRECATED file read
has been removed from the -mm tree.  Its filename was
     selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Paniakin <apanyaki@amazon.com>
Subject: selftests/damon/huge_count_read_write: provide sufficiently large buffer for DEPRECATED file read
Date: Mon, 28 Oct 2024 16:30:53 -0700

Patch series "damon/{self,kunit}tests: minor fixups for DAMON debugfs
interface tests".

Fixup small broken window panes in DAMON selftests and kunit tests.

First four patches clean up DAMON debugfs interface selftests output, by
fixing segmentation fault of a test program (patch 1), removing
unnecessary debugging messages (patch 2), and hiding error messages from
expected failures (patches 3 and 4).

Following two patches fix copy-paste mistakes in DAMON Kconfig help
message that copied from debugfs kunit test (patch 5) and a comment on the
debugfs kunit test code (patch 6).


This patch (of 6):

'huge_count_read_write' crashes with segmentation fault when reading
DEPRECATED file of DAMON debugfs interface.  This is not causing any
problem for users or other tests because the purpose of the test is just
ensuring the read is not causing kernel warning messages.  Nonetheless, it
makes the output unnecessarily noisy, and the DEPRECATED file is not
properly being tested.

It happens because the size of the content of the file is larger than the
size of the buffer for the read.  The file contains about 170 characters. 
Increase the buffer size to 256 characters.

Link: https://lkml.kernel.org/r/20241028233058.283381-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20241028233058.283381-2-sj@kernel.org
Fixes: b4a002889d24 ("selftests/damon: test debugfs file reads/writes with huge count")
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Panyakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/huge_count_read_write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/huge_count_read_write.c~selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read
+++ a/tools/testing/selftests/damon/huge_count_read_write.c
@@ -18,7 +18,7 @@
 void write_read_with_huge_count(char *file)
 {
 	int filedesc = open(file, O_RDWR);
-	char buf[25];
+	char buf[256];
 	int ret;
 
 	printf("%s %s\n", __func__, file);
_

Patches currently in -mm which might be from apanyaki@amazon.com are


