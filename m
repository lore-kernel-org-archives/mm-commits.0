Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B921E486
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616174; cv=none; b=agqriAsYj5Jui1LBWCUkEmhveXXJCu4XYWcrFbZMrJWQBegwmwZVjt08DvKzANNPxaPAXqbLpSkrXRP0e6Cfkc0OSZc/mNn+SLuc1aRY22FscKfv82Jt/jEN3ys31bHGZ6gPJOU/Dct9jPZdANSoBQBhokk0CSMTdzqJ8Qgp6uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616174; c=relaxed/simple;
	bh=gFO0gIpsuGCDgMaBd7xInN/oF4csmlv8NglYTe2bCgE=;
	h=Date:To:From:Subject:Message-Id; b=F+ET4TlkkblsGYxY+LFXm3Sxcc4iQ1BsX9WSRjbWk7DBPG+A6OFmnK7C0gKk+UjXx/GVCe9udsDqqlqQMHC6QQAqp0tkG2hBTm5nfwWocRdb3w9a/hhFS+XvtvYfJi4l5XyK+0p4P1IHuVBMAGcp5i/VoyVsu3PU8zcUJAznVLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jwa2XnVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jwa2XnVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD19C433C7;
	Thu, 18 Jan 2024 22:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616174;
	bh=gFO0gIpsuGCDgMaBd7xInN/oF4csmlv8NglYTe2bCgE=;
	h=Date:To:From:Subject:From;
	b=jwa2XnVJn2rraXc/oO+Qoy6DxQ2iD5fNdM5FwNeHDE1JMj5eRHkLUYMZUJw46dA2l
	 DEfCqdrKZtRkv36SfjXeLrVXZdbS2JYAB/IhOk6GPBtFrDwsM+/xGRRUdRXN+j+KVf
	 3IqD5b2yMdl1mz9mAenbZ9hIDxPnm8+3nosp3U1s=
Date: Thu, 18 Jan 2024 14:16:12 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,keescook@chromium.org,jeffxu@google.com,dverkamp@chromium.org,cyphar@cyphar.com,gthelen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-delete-unused-declarations.patch added to mm-unstable branch
Message-Id: <20240118221614.2AD19C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd: delete unused declarations
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-delete-unused-declarations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-delete-unused-declarations.patch

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
From: Greg Thelen <gthelen@google.com>
Subject: selftests/memfd: delete unused declarations
Date: Thu, 18 Jan 2024 01:50:57 -0800

Commit 32d118ad50a5 ("selftests/memfd: add tests for F_SEAL_EXEC"):
- added several unused 'nbytes' local variables

Commit 6469b66e3f5a ("selftests: improve vm.memfd_noexec sysctl tests"):
- orphaned 'newpid_thread_fn2()' forward declaration
- orphaned 'join_newpid_thread()' forward declaration
- added unused 'pid' local in sysctl_simple_child()
- orphaned 'fd' local in sysctl_simple_child()
- added unused 'fd' in sysctl_nested_child()

Delete the unused locals and forward declarations.

Link: https://lkml.kernel.org/r/20240118095057.677544-1-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-delete-unused-declarations
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -44,8 +44,6 @@
  */
 static size_t mfd_def_size = MFD_DEF_SIZE;
 static const char *memfd_str = MEMFD_STR;
-static int newpid_thread_fn2(void *arg);
-static void join_newpid_thread(pid_t pid);
 
 static ssize_t fd2name(int fd, char *buf, size_t bufsize)
 {
@@ -194,7 +192,6 @@ static unsigned int mfd_assert_get_seals
 static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
 	char buf[PATH_MAX];
-	int nbytes;
 	unsigned int s;
 	fd2name(fd, buf, PATH_MAX);
 
@@ -696,7 +693,6 @@ static void mfd_assert_mode(int fd, int
 {
 	struct stat st;
 	char buf[PATH_MAX];
-	int nbytes;
 
 	fd2name(fd, buf, PATH_MAX);
 
@@ -715,7 +711,6 @@ static void mfd_assert_mode(int fd, int
 static void mfd_assert_chmod(int fd, int mode)
 {
 	char buf[PATH_MAX];
-	int nbytes;
 
 	fd2name(fd, buf, PATH_MAX);
 
@@ -731,7 +726,6 @@ static void mfd_fail_chmod(int fd, int m
 {
 	struct stat st;
 	char buf[PATH_MAX];
-	int nbytes;
 
 	fd2name(fd, buf, PATH_MAX);
 
@@ -1254,9 +1248,6 @@ static void test_sysctl_set_sysctl2(void
 
 static int sysctl_simple_child(void *arg)
 {
-	int fd;
-	int pid;
-
 	printf("%s sysctl 0\n", memfd_str);
 	test_sysctl_set_sysctl0();
 
@@ -1321,7 +1312,6 @@ static void test_sysctl_sysctl2_failset(
 
 static int sysctl_nested_child(void *arg)
 {
-	int fd;
 	int pid;
 
 	printf("%s nested sysctl 0\n", memfd_str);
_

Patches currently in -mm which might be from gthelen@google.com are

selftests-memfd-delete-unused-declarations.patch

