Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC9017550
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560089; cv=none; b=gYzvjW/hf/vKy6g4emCb90lOdhfpTpNcnGHUpN+MzCTwE8P8lI1LDkxIiHI2/MrH2S3LsHfjHBrkbJkVvQXIH0LBeGvuakUNv4LxU+dxCkbEzUsmpTPNfTr5t2ZIKMYalYlHVYi3Nq9XXT7LmTXw4NG6nrUjug+Kbja0mQxnrPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560089; c=relaxed/simple;
	bh=2vXA7Sx59Cks7mts1viiwA6UG6Ru55VCN1sWV2BAvC0=;
	h=Date:To:From:Subject:Message-Id; b=M2NwrckWyBY1PkGpIV2xskKKvfWHjrYKh3IzS52iAI46p/zdqpmYGomakv0m/jYM43Y21XgsqQ+vVSJ2USbVDIck3MHU9FGyY2HbNMwovGfvQ4+CIqxqQSrSr0f1phOCJ65BhMe5a7uvPNRhqTZd2xcnmJgLWIjntLsYjBN7YjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kSYPQkGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kSYPQkGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414C7C43394;
	Thu, 22 Feb 2024 00:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560089;
	bh=2vXA7Sx59Cks7mts1viiwA6UG6Ru55VCN1sWV2BAvC0=;
	h=Date:To:From:Subject:From;
	b=kSYPQkGGkgYzC8SrsIHnB42NHfkLGf/3gtyFoc2Xwhjr3ysOX/tjRQWqehfVO6dRY
	 40B+jjTLIADqgq7VSki3dsYY8Zr4h9Ey2luD0dkvK+VIZvVaK0nVzVp8sE2f5hkwvM
	 yRy4iwf+qxNzh0wGac0H0Ds0lZcvnegW6w0IKhfQ=
Date: Wed, 21 Feb 2024 16:01:28 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,keescook@chromium.org,jeffxu@google.com,dverkamp@chromium.org,cyphar@cyphar.com,gthelen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-delete-unused-declarations.patch removed from -mm tree
Message-Id: <20240222000129.414C7C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: delete unused declarations
has been removed from the -mm tree.  Its filename was
     selftests-memfd-delete-unused-declarations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


