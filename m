Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488717A2EB
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230342; cv=none; b=uYKWrWqKCsz1XSlH9Xf/3cHy7/QA4xNJ4a+1+EQcYf7YKjZBxHpXgPAebfvj1fQ1rp8jid2vnjFphhJuH7D8fnGdghxV3oEl3f/F7zZWAjGMexP1o3DO9g3DgIxnKSTwI0siRzppyOh3C19Q52sQ12R8J0x2stHS8F6AdFCxPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230342; c=relaxed/simple;
	bh=HhtkFxrx+gUpOYBStE12Qv0r2RZD2KomhfF1jr3LAD0=;
	h=Date:To:From:Subject:Message-Id; b=Sv32VTHfI28fu8rm7yG9ahgY8pCyVZ6/cs1t3WkQqRy9G5Mh1qhxj9YxXnLWXRXRsHARNFSHqGF+2RcfQiBboUd1+5l4JeitCyAX/9WUEyR9xofY/UwZEbUBn3tD/8U06Xkk3znwSQEmqDP6G9P1zraIq0GVg2Z1a+B+BMaCca4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTjhdLUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTjhdLUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FA1C4CEE3;
	Mon, 17 Mar 2025 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742230342;
	bh=HhtkFxrx+gUpOYBStE12Qv0r2RZD2KomhfF1jr3LAD0=;
	h=Date:To:From:Subject:From;
	b=fTjhdLUBne6nC2VzIzsF+8QEIrSaBk68ydG8cRFmFdbZ4sof4VK9ENJNJY/+rWC42
	 CIajReem2xUjkyUbQHcxq29EZcQP+MGnGP7kAAGMGyBo5qX6JP0ixtsY1t3keiZOc2
	 sQQkZhwykj73dLqD+OHfYuYANipH2ejGa+0GqUrc=
Date: Mon, 17 Mar 2025 09:52:21 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-commentary-about-9pfs-bugs.patch added to mm-unstable branch
Message-Id: <20250317165221.E8FA1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add commentary about 9pfs bugs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-commentary-about-9pfs-bugs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-commentary-about-9pfs-bugs.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: add commentary about 9pfs bugs
Date: Mon, 17 Mar 2025 10:20:34 +0000

As discussed here:

https://lore.kernel.org/lkml/Z9RRkL1hom48z3Tt@google.com/

This code could benefit from some more commentary.

To avoid needing to comment the same thing in multiple places (I guess
more of these SKIPs will need to be added over time, for now I am only
like 20% of the way through Project Run run_vmtests.sh Successfully), add
a dummy "skip tests for this specific reason" function that basically just
serves as a hook to hang comments on.

Link: https://lkml.kernel.org/r/20250317-9pfs-comments-v1-1-9ac96043e146@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    6 +-----
 tools/testing/selftests/mm/map_populate.c |    8 +++-----
 tools/testing/selftests/mm/vm_util.h      |   18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-add-commentary-about-9pfs-bugs
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -97,11 +97,7 @@ static void do_test(int fd, size_t size,
 
 	if (ftruncate(fd, size)) {
 		if (errno == ENOENT) {
-			/*
-			 * This can happen if the file has been unlinked and the
-			 * filesystem doesn't support truncating unlinked files.
-			 */
-			ksft_test_result_skip("ftruncate() failed with ENOENT\n");
+			skip_test_dodgy_fs("ftruncate()");
 		} else {
 			ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
 		}
--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-add-commentary-about-9pfs-bugs
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -18,6 +18,8 @@
 #include <unistd.h>
 #include "../kselftest.h"
 
+#include "vm_util.h"
+
 #define MMAP_SZ		4096
 
 #define BUG_ON(condition, description)						\
@@ -88,11 +90,7 @@ int main(int argc, char **argv)
 
 	ret = ftruncate(fileno(ftmp), MMAP_SZ);
 	if (ret < 0 && errno == ENOENT) {
-		/*
-		 * This probably means tmpfile() made a file on a filesystem
-		 * that doesn't handle temporary files the way we want.
-		 */
-		ksft_exit_skip("ftruncate(fileno(tmpfile())) gave ENOENT, weird filesystem?\n");
+		skip_test_dodgy_fs("ftruncate()");
 	}
 	BUG_ON(ret, "ftruncate()");
 
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-commentary-about-9pfs-bugs
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -5,6 +5,7 @@
 #include <err.h>
 #include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
+#include "../kselftest.h"
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
@@ -32,6 +33,23 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+/*
+ * Plan 9 FS has bugs (at least on QEMU) where certain operations fail with
+ * ENOENT on unlinked files. See
+ * https://gitlab.com/qemu-project/qemu/-/issues/103 for some info about such
+ * bugs. There are rumours of NFS implementations with similar bugs.
+ *
+ * Ideally, tests should just detect filesystems known to have such issues and
+ * bail early. But 9pfs has the additional "feature" that it causes fstatfs to
+ * pass through the f_type field from the host filesystem. To avoid having to
+ * scrape /proc/mounts or some other hackery, tests can call this function when
+ * it seems such a bug might have been encountered.
+ */
+static inline void skip_test_dodgy_fs(const char *op_name)
+{
+	ksft_test_result_skip("%s failed with ENOENT. Filesystem might be buggy (9pfs?)\n", op_name);
+}
+
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
 bool pagemap_is_swapped(int fd, char *start);
_

Patches currently in -mm which might be from jackmanb@google.com are

selftests-mm-add-commentary-about-9pfs-bugs.patch

