Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01BB1CDFCA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 19:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402241; cv=none; b=igEtQDhCr7v5eI0hbbfppK5FCKkI10B/1RZ0/VH3tDD6RG7OrThjK9p7x1yZjhvr58G4MVa0auRvezmyXDP+3RfXvSHsoG15P7qWcm6fY5NWRZN7pDbELT0cPqjtXAjIEgbt9JshAoZQFuW+7tLoUGg6brHFICZiMp8ZyAFwOyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402241; c=relaxed/simple;
	bh=t9tRLtE6VLRgEhJdOgwzApDC9T1bQT07sMJK9Gpb8UI=;
	h=Date:To:From:Subject:Message-Id; b=MZ+RYuVavSAosFdNa6HN5Z7rv9pXzm/iXq6lN9P61feZxsWkI7XaG15mkQEwQ7Ec3Z4QEcnS9CZKvbtZ71Llzy59mHaRjqBXwd2GbVm/BiUj/oZgPOzAzfCopcdwSl3OtJ29fFB59lPNx1axHBXevZAZhNfW5VFMxwFWDOxII3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aEdsAoyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aEdsAoyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5826E1F000FF;
	Wed,  7 Oct 2026 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791402239;
	bh=kg/G7XucgHcTS8pqdjdfYXOrcBk5AuvJAZjaHjgS/ro=;
	h=Date:To:From:Subject;
	b=aEdsAoybWhzuxuZJQ/AcBLM2M5GW+vERK6vmCrVkFqqrf71h+piHZaBItuw6/B8hP
	 /QUsv8YjJHunoYzJQkh4AOlrk7bhWuZfyYod/6C57wFMDha9G4gjUAWspbgxZNoffl
	 Ton94KxkFLl7CGQ6/kyZ1VC6yr/vvyxz6V96PKOI=
Date: Wed, 07 Oct 2026 12:43:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,azpijr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-mremap_dontunmap-mlock-accounting.patch added to mm-new branch
Message-Id: <20261007194359.5826E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check MREMAP_DONTUNMAP mlock accounting
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-mremap_dontunmap-mlock-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-mremap_dontunmap-mlock-accounting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: selftests/mm: check MREMAP_DONTUNMAP mlock accounting
Date: Tue,  6 Oct 2026 08:39:01 +0200

MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
while setting them on the destination VMA.  The "mm/mremap: fix two issues
with MREMAP_DONTUNMAP" series fixed two cases where this leaked
mm->locked_vm:

 - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
   single resulting VMA loses the flags without the accounting being
   dropped;

 - a partial mremap() moves only part of the range, leaving the pages which
   are not moved accounted as locked in a VMA whose flags were cleared.

Add a test which mlock2()s a source mapping, moves all or part of it with
MREMAP_DONTUNMAP, unmaps everything and checks that VmLck is back to its
value from before, and run it for the self-merge case and for a partial
move with and without MLOCK_ONFAULT.

Verified on x86_64: the three cases fail on mm-unstable with the two fixes
reverted and pass with them applied.

Link: https://lore.kernel.org/20261006064120.6796-1-azpijr@gmail.com
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/mremap_dontunmap.c |   63 +++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_dontunmap.c~selftests-mm-check-mremap_dontunmap-mlock-accounting
+++ a/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -7,6 +7,7 @@
  */
 #define _GNU_SOURCE
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <linux/mman.h>
 #include <errno.h>
 #include <stdio.h>
@@ -15,6 +16,7 @@
 #include <unistd.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 
 unsigned long page_size;
 char *page_buffer;
@@ -335,6 +337,62 @@ static void mremap_dontunmap_partial_map
 	ksft_test_result_pass("%s\n", __func__);
 }
 
+/* VmLck from /proc/self/status, which is mm->locked_vm in kB. */
+static unsigned long locked_vm_kb(void)
+{
+	unsigned long kb;
+	char buf[256];
+	FILE *fp;
+
+	fp = fopen("/proc/self/status", "r");
+	BUG_ON(!fp, "unable to open /proc/self/status");
+	BUG_ON(!check_for_pattern(fp, "VmLck:", buf, sizeof(buf)) ||
+	       sscanf(buf, "VmLck: %lu kB", &kb) != 1, "unable to read VmLck");
+	fclose(fp);
+
+	return kb;
+}
+
+/*
+ * MREMAP_DONTUNMAP clears the mlock flags of the source VMA and sets them on
+ * the destination, and mm->locked_vm has to follow.  mlock2() a source of
+ * num_pages and move its first move_pages to gap pages past its end:
+ *
+ *  |------ source ------|... gap ...|-- dest --|
+ *
+ * then unmap everything and check that VmLck is back where it started.  With
+ * no gap the destination is adjacent to the source and could merge with it,
+ * otherwise the gap is left PROT_NONE so that it cannot.
+ */
+static void mremap_dontunmap_mlock(const char *desc, unsigned long num_pages,
+				   unsigned long move_pages, unsigned long gap,
+				   int mlock_flags)
+{
+	unsigned long size = (num_pages + gap + move_pages) * page_size;
+	unsigned long locked = locked_vm_kb();
+	void *source, *dest;
+
+	source = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	BUG_ON(source == MAP_FAILED, "mmap");
+	BUG_ON(mprotect(source, num_pages * page_size,
+			PROT_READ | PROT_WRITE) == -1, "mprotect");
+	dest = source + (num_pages + gap) * page_size;
+
+	if (syscall(__NR_mlock2, source, num_pages * page_size, mlock_flags)) {
+		ksft_test_result_skip("%s: %s: mlock2: %s\n", __func__, desc,
+				      strerror(errno));
+		BUG_ON(munmap(source, size) == -1, "unable to unmap mappings");
+		return;
+	}
+
+	BUG_ON(mremap(source, move_pages * page_size, move_pages * page_size,
+		      MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED,
+		      dest) != dest, "mremap");
+
+	BUG_ON(munmap(source, size) == -1, "unable to unmap mappings");
+	ksft_test_result(locked_vm_kb() == locked, "%s: %s\n", __func__, desc);
+}
+
 int main(void)
 {
 	ksft_print_header();
@@ -348,7 +406,7 @@ int main(void)
 		ksft_finished();
 	}
 
-	ksft_set_plan(5);
+	ksft_set_plan(8);
 
 	// Keep a page sized buffer around for when we need it.
 	page_buffer =
@@ -361,6 +419,9 @@ int main(void)
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
 	mremap_dontunmap_partial_mapping_overwrite();
+	mremap_dontunmap_mlock("onfault self-merge", 1, 1, 0, MLOCK_ONFAULT);
+	mremap_dontunmap_mlock("partial", 3, 2, 1, 0);
+	mremap_dontunmap_mlock("onfault partial", 3, 2, 1, MLOCK_ONFAULT);
 
 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");
_

Patches currently in -mm which might be from azpijr@gmail.com are

selftests-mm-check-mremap_dontunmap-mlock-accounting.patch
percpu_counter-annotate-lockless-read-in-_limited_add.patch

