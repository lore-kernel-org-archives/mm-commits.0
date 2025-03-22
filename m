Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A843153836
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619845; cv=none; b=A6/Uj2H/PGtViJuR3a4vBFgSpWzJWvAj4sK1BiOjaGzIn+49gG55wP6IC8eMXFZk5bbL6ej8Xh/wQ8f5uUJ/8SZuo+f6t9M8Ogh/4w9TK/wlfoIbGZBZytYG2gK5zKTQsL6yF9FTF0tsSTiepVQWynBlCI+kHpRHCgCVMCywHWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619845; c=relaxed/simple;
	bh=vbXnP935VMxFqru9WLlzD14lm/8I8f8XnGw0CbxOabw=;
	h=Date:To:From:Subject:Message-Id; b=PmzYqoDQYVjlWDQcvmd9j1IVnVPDj8W83mD3Lc5x45bGr5p/D+/SuIWPYuZ0XfYiM5ZT872HQ3yn3U8M1e/t94zQslYLflGy9Rh1afDTV6uIgHHQHCFS61L0hjvbZkWdpCkNimHVA0Atw5ApG1rpG1evyQgKlEHGuf9GB1I/79c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QQ9Dshf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QQ9Dshf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD316C4CEDD;
	Sat, 22 Mar 2025 05:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619844;
	bh=vbXnP935VMxFqru9WLlzD14lm/8I8f8XnGw0CbxOabw=;
	h=Date:To:From:Subject:From;
	b=QQ9Dshf+fF6LB6sMckVm9DxivrgtRNB8JU84G4CHCqbcDi4yp79yHPPhx1t4OWSpn
	 E5R3vnC9Jgej8silfUoygPmsgvrC7HNphbx/TNiwloJGXmlnXjMTfe9oM3WEw+D8Tl
	 oJn4jeLACMOU/jyrZQnAHBMol2SXot16ntQhpTLU=
Date: Fri, 21 Mar 2025 22:04:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-commentary-about-9pfs-bugs.patch removed from -mm tree
Message-Id: <20250322050404.DD316C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add commentary about 9pfs bugs
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-commentary-about-9pfs-bugs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


