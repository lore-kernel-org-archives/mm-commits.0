Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19517D2
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160083; cv=none; b=ZrVAEbBqpWyWtGlB2Ax5jAC4G59NykjDXPnRDKWk/eYeFv6cGcpm67ipzETKhhfQxwd9uT8ZEUk8GsVMwYN9GWwoWeVSfHknOCy1dYdrEYR08ccCJHITIMfVjdU07HZXiY2MqcMW4/hD0YzCzs/b/tS4rvXaMC4MyHraYro1IAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160083; c=relaxed/simple;
	bh=3sa222Xagco97VEZuj8UhZkBtU/N2opXJjv4Ym3PLRo=;
	h=Date:To:From:Subject:Message-Id; b=J/v8sDW/gposN41Ksxp22+qawNavV1T9y8WH32VnJ9RxGyTed+FtGmg5ANs7cde5k0Ru4eJP5TrRn0t6HyVD6KgINzJ5kkL5q70/+N5DofO8JJLhl3x/YLDwi831i80al4FGtwEDgfFM1s2rTmIBBNIQckm5GgTJi9wM26xbyU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bp/wjuot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bp/wjuot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CE3C4CECD;
	Tue, 29 Oct 2024 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160082;
	bh=3sa222Xagco97VEZuj8UhZkBtU/N2opXJjv4Ym3PLRo=;
	h=Date:To:From:Subject:From;
	b=bp/wjuot6vAi8+2IObVA1ml7Zh0PVoYgKQ+56uKptGBQp/sdtRvJLfdYYhRgP01Nt
	 SGyXQCdaZ5nmy2mY3t+3fd0MtCGzY8yZt6QJ3MUO/EQMUkCjQGy/X8X7F9vGSbPUMz
	 cdu1hXI8W2IzdvolO/GzjsocXAQcV6RSsdqAEDxk=
Date: Mon, 28 Oct 2024 17:01:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read.patch added to mm-unstable branch
Message-Id: <20241029000122.77CE3C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/huge_count_read_write: provide sufficiently large buffer for DEPRECATED file read
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read.patch

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

selftests-damon-huge_count_read_write-provide-sufficiently-large-buffer-for-deprecated-file-read.patch

