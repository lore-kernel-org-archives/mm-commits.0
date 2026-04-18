Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9963264FD
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499085; cv=none; b=ddv1IoMD7QOrmGqf9psSTb/jifLg3Gxd6DpzVl4xDdfl3HDna6l7VvZyrh/qhxSsoBCbcsu0YtQ5V8uYuSo15ZWe9jk8+5v8rVRlQa6v9EM4hJtmFUbhKnwh69cDh0Xp2iQwybm2OH7ZxmaTPwrj6GS3Pr3uhDicLPD71xsNKHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499085; c=relaxed/simple;
	bh=E1RDcuDFR7ET4x+8Nv7MJ7iUaTTwPPKkbdv/wNOOeQo=;
	h=Date:To:From:Subject:Message-Id; b=oqFKhnvF+qTqFYNZXqp2gvNmijuk+KOq84FVHP5QXYEVjZTk8v53Qahmxe/ly+I7XiMxSyPNSVf18/EpUhIPcWSiI+zeN5+aaPTaGhhsBX1aiYmoLGqfOgM3GwA72ua9NTCiWzZ+tx3uP1XH9KSVWslMe86eWh1rLqFrUSK6Tr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0ohUFI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0ohUFI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DED6C19424;
	Sat, 18 Apr 2026 07:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499084;
	bh=E1RDcuDFR7ET4x+8Nv7MJ7iUaTTwPPKkbdv/wNOOeQo=;
	h=Date:To:From:Subject:From;
	b=J0ohUFI8fn0UPPsZvsnZFUk3bOy7TaQkQmxPGYIfZzMNAMOIA0H06lJN5gCgnZ1o3
	 OznZwYMnAdLdTnEoNdkAY6vB4o+plAqvMZUnEohVP4q+FzafgkgFjNpHaLLGUgPE5J
	 U59K9jV8oDFNpK9xjiZjSkXiULXJafjPfsSToKTU=
Date: Sat, 18 Apr 2026 00:57:59 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,ljs@kernel.org,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-vm_util-robust-write_file.patch removed from -mm tree
Message-Id: <20260418075803.8DED6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/vm_util: robust write_file()
has been removed from the -mm tree.  Its filename was
     selftests-mm-vm_util-robust-write_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260402014543.1671131-5-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
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


