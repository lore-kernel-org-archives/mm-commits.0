Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E130BF77
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675076; cv=none; b=a72J2WCOwWLrCAQwN1sufBd9xNIwxYZVFm5F40bKtV1y4JKhmddooYukzQkoW0C0CV6MJUypukyjbIuDLOhoJeg+P/O6pSK9KQpMTUp+1rYtUuXRG5SeriSzGy76S87TsiRRUFz9HTMOGOsZThi+7rW4e9Uxrx8DOk4zXEZgTeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675076; c=relaxed/simple;
	bh=QDR+9SqpPj1m6rE/VjU2U8vBXtm2dthHHi4Y3iYZdJk=;
	h=Date:To:From:Subject:Message-Id; b=CSi+UfjmSpVZ2kGQusxoe9tNQ+5nLNDkGtnV1vqiLcok0AcVq39nL2CJhKl5mLUnEZoyyPcd6eEIiR0r6EGTHDctLVAX6tj+AtN5DWTlyaaTBxJ8/YAafR12q9DxNqRcQGhYjPuSbVa9VtMydRfy40DIHWaQDYaZ2JdjrakbLhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nVIsBwr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nVIsBwr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50C2C4CEF1;
	Thu, 20 Nov 2025 21:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675075;
	bh=QDR+9SqpPj1m6rE/VjU2U8vBXtm2dthHHi4Y3iYZdJk=;
	h=Date:To:From:Subject:From;
	b=nVIsBwr/ZG9n1TRockN+tlMDaVNbfZUZe8nG4rzs7ZPfHL8nTWMZcAmvdNQkmYJcS
	 PZ6xwfd1FqTW4glFCzb/xLmF20SCWOdtHpAq1PnRreattBotnR4TOniim5FJnoVzf/
	 l3L8RMaBLf3ETyUKu3NbtD+E6PaSukDB2VMBsbNM=
Date: Thu, 20 Nov 2025 13:44:35 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,ankitkhushwaha.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-fix-pointer-comparison-in-mremap_test.patch removed from -mm tree
Message-Id: <20251120214435.C50C2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: fix pointer comparison in mremap_test
has been removed from the -mm tree.  Its filename was
     selftest-mm-fix-pointer-comparison-in-mremap_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: selftest/mm: fix pointer comparison in mremap_test
Date: Sat, 8 Nov 2025 21:48:29 +0530

Pointer arthemitic with 'void * addr' and 'ulong dest_alignment' triggers
following warning:

mremap_test.c:1035:31: warning: pointer comparison always evaluates to
false [-Wtautological-compare]
 1035 |                 if (addr + c.dest_alignment < addr) {
      |                                             ^

this warning is raised from clang version 20.1.8 (Fedora 20.1.8-4.fc42).

use 'void *tmp_addr' to do the pointer arthemitic.

Link: https://lkml.kernel.org/r/20251108161829.25105-1-ankitkhushwaha.linux@gmail.com
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftest-mm-fix-pointer-comparison-in-mremap_test
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -994,7 +994,7 @@ static void mremap_move_multi_invalid_vm
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
 {
-	void *addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
+	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	unsigned long long t, d;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
@@ -1032,7 +1032,8 @@ static long long remap_region(struct con
 	/* Don't destroy existing mappings unless expected to overlap */
 	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
 		/* Check for unsigned overflow */
-		if (addr + c.dest_alignment < addr) {
+		tmp_addr = addr + c.dest_alignment;
+		if (tmp_addr < addr) {
 			ksft_print_msg("Couldn't find a valid region to remap to\n");
 			ret = -1;
 			goto clean_up_src;
_

Patches currently in -mm which might be from ankitkhushwaha.linux@gmail.com are


