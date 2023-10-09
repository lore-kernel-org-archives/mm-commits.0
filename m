Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD4FE9371F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 23:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379038AbjJIXbt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 19:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379014AbjJIXbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 19:31:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA20EA6
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 16:31:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273A6C433C9;
        Mon,  9 Oct 2023 23:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696894307;
        bh=7/9yZ1w/m58/lI7+Na4TRb/2ZFLh6z3YmzddlcOtito=;
        h=Date:To:From:Subject:From;
        b=M33HBFPs13hEoLDl/QCYwZok7SPghCEmqWNaFnqC8vy6/jPtCjNxPd9kCkRKysKhV
         vsiLPmVUMk0n2fGmj9M/q4GcWqokfVdgMhkXU92JpCDYGlSMScOxGF2goaUJhwQpc3
         adpCIB3mz33eHNw4N6jqVd3pigw9ViP05TNwRHEE=
Date:   Mon, 09 Oct 2023 16:31:33 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        swarupkotikalapudi@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-test-proc-pid-statm.patch added to mm-nonmm-unstable branch
Message-Id: <20231009233145.273A6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: test /proc/${pid}/statm
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-test-proc-pid-statm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-test-proc-pid-statm.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Subject: proc: test /proc/${pid}/statm
Date: Mon, 9 Oct 2023 14:07:14 +0300


My original comment lied, output can be "0 A A B 0 0 0\n"
(see comment in the code).

I don't quite understand why

	get_mm_counter(mm, MM_FILEPAGES) + get_mm_counter(mm, MM_SHMEMPAGES)

can stay positive but get_mm_counter(mm, MM_ANONPAGES) is always 0 after
everything is unmapped but that's just me.

[adobriyan@gmail.com: more or less rewritten]
Link: https://lkml.kernel.org/r/0721ca69-7bb4-40aa-8d01-0c5f91e5f363@p183
Signed-off-by: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   97 ++++++++++++++++-
 1 file changed, 92 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-test-proc-pid-statm
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -303,6 +303,95 @@ static int test_proc_pid_smaps_rollup(pi
 	}
 }
 
+static const char *parse_u64(const char *p, const char *const end, uint64_t *rv)
+{
+	*rv = 0;
+	for (; p != end; p += 1) {
+		if ('0' <= *p && *p <= '9') {
+			assert(!__builtin_mul_overflow(*rv, 10, rv));
+			assert(!__builtin_add_overflow(*rv, *p - '0', rv));
+		} else {
+			break;
+		}
+	}
+	assert(p != end);
+	return p;
+}
+
+/*
+ * There seems to be 2 types of valid output:
+ * "0 A A B 0 0 0\n" for dynamic exeuctables,
+ * "0 0 0 B 0 0 0\n" for static executables.
+ */
+static int test_proc_pid_statm(pid_t pid)
+{
+	char buf[4096];
+	snprintf(buf, sizeof(buf), "/proc/%u/statm", pid);
+	int fd = open(buf, O_RDONLY);
+	if (fd == -1) {
+		perror("open /proc/${pid}/statm");
+		return EXIT_FAILURE;
+	}
+
+	ssize_t rv = read(fd, buf, sizeof(buf));
+	close(fd);
+
+	assert(rv >= 0);
+	assert(rv <= sizeof(buf));
+	if (0) {
+		write(1, buf, rv);
+	}
+
+	const char *p = buf;
+	const char *const end = p + rv;
+
+	/* size */
+	assert(p != end && *p++ == '0');
+	assert(p != end && *p++ == ' ');
+
+	uint64_t resident;
+	p = parse_u64(p, end, &resident);
+	assert(p != end && *p++ == ' ');
+
+	uint64_t shared;
+	p = parse_u64(p, end, &shared);
+	assert(p != end && *p++ == ' ');
+
+	uint64_t text;
+	p = parse_u64(p, end, &text);
+	assert(p != end && *p++ == ' ');
+
+	assert(p != end && *p++ == '0');
+	assert(p != end && *p++ == ' ');
+
+	/* data */
+	assert(p != end && *p++ == '0');
+	assert(p != end && *p++ == ' ');
+
+	assert(p != end && *p++ == '0');
+	assert(p != end && *p++ == '\n');
+
+	assert(p == end);
+
+	/*
+	 * "text" is "mm->end_code - mm->start_code" at execve(2) time.
+	 * munmap() doesn't change it. It can be anything (just link
+	 * statically). It can't be 0 because executing to this point
+	 * implies at least 1 page of code.
+	 */
+	assert(text > 0);
+
+	/*
+	 * These two are always equal. Always 0 for statically linked
+	 * executables and sometimes 0 for dynamically linked executables.
+	 * There is no way to tell one from another without parsing ELF
+	 * which is too much for this test.
+	 */
+	assert(resident == shared);
+
+	return EXIT_SUCCESS;
+}
+
 int main(void)
 {
 	int rv = EXIT_SUCCESS;
@@ -389,11 +478,9 @@ int main(void)
 		if (rv == EXIT_SUCCESS) {
 			rv = test_proc_pid_smaps_rollup(pid);
 		}
-		/*
-		 * TODO test /proc/${pid}/statm, task_statm()
-		 * ->start_code, ->end_code aren't updated by munmap().
-		 * Output can be "0 0 0 2 0 0 0\n" where "2" can be anything.
-		 */
+		if (rv == EXIT_SUCCESS) {
+			rv = test_proc_pid_statm(pid);
+		}
 
 		/* Cut the rope. */
 		int wstatus;
_

Patches currently in -mm which might be from swarupkotikalapudi@gmail.com are

proc-test-proc-pid-statm.patch
selftests-proc-add-proc-pid-statm-output-validation.patch

