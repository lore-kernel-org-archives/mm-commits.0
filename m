Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832469;
	b=cs+or7fO8L4uljRYcLSMQApMjCxB7EbrOlm8rAtMUQlvR+o83su8iLYxJs36xcZE/Z5L
	 DNoNXV2lH7pkHN/BnxXT99oX2J5/ginHiPVlqPpkDRxC5aS7NUhykQ9/RGtmvIfCLNuUW
	 hBSsb+mjk4KY86h3BnQ1GsLzcoGibFaE7xdA+hfR8xIBsPRbw9kQ1sliDnzLMPS1i3jKQ
	 q2pVwHBY2TbAk7RMmYmUolmhzAcIhbMMOeNLtdb2d+zFvf82Auc97gz0Bxyuj3UGYbgsE
	 N1NwI63+KvcWL1bg8btdgyZVwuPy1/B1zIg7IVCdxR3ykd62oUFaLKzuPhk5vQxtnyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832469;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dF8lCnCGn1DmLJGz1M5IW40Px4NCQRjLmzqt2Av5Wgo=;
	b=oF8V7N43WrTvkwIrHJVBPztu9OihAOC0PYmBsl8R4cYGarp0+5QwIImq0HeacQmTw8XR
	 HXPGZnZEguNH5oofAst3WR48F1u5S7AZFZZR40fkSrSCUwL9K/86BYj8H74tVzf/Fs9CW
	 ljm86/4L1cq4dDA/R8I6UMaij719b2MYD0p6efxSGbgz9UYY2U4AO7iTTsOUuJIhy5t0v
	 NBLgdz22PpHZpmXWwuqQUhtcFQzN193psef5X4IaQ4TLqddfm2fsPowTgdtmSUBUUQuHg
	 +wJuzzcelCmfFH94+90Q5vksPNKIsdfUroRr3PTbPZkvktZXTEK42CPDcGo1LWGZESw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T5NyN95Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCCA606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T5NyN95Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE141F01825;
	Sat, 24 Oct 2026 09:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832468;
	bh=dF8lCnCGn1DmLJGz1M5IW40Px4NCQRjLmzqt2Av5Wgo=;
	h=Date:To:From:Subject;
	b=T5NyN95Y4MQNTVHZtIibWPqAOpfYilGqsCktRZ8EZjt4/JeNiiT/Oa5LEvY8q7wHG
	 jEVFvj9ropuQpMvgo4Oa+upnqh7guOtEYy99tFqX8kn1PNoNHqJzxXwEgp+lCTZ9Wk
	 sqBOgK+HE9Lh3JMbVH02jicOYGo8Z+iDWteVdpRk=
Date: Sat, 24 Oct 2026 02:01:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,azpijr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-mremap_dontunmap-mlock-accounting.patch removed from -mm tree
Message-Id: <20261024090108.CDE141F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: check MREMAP_DONTUNMAP mlock accounting
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-mremap_dontunmap-mlock-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
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


