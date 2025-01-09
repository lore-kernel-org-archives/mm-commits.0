Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7282F2F
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 04:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736397343; cv=none; b=SbZBAagR87/Lgqk2DdEY00XCYZ1BSWHbUrSTNIAqndQjcR7/YRXaWziHftxaiMcBsRgDN8ob1ie4D1IGEmNXx1oWY7+pTpGKAXmMyJxgvWN19rxV9lNHU8u1/YGn55dzHbhrlEgn/d5mdBrRzByzRRVzUSj26c1EbxGwkwAKzi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736397343; c=relaxed/simple;
	bh=VLcPQx3i7I5JH8tKYYkjuzEqD3nSMJafI9KhXrO4EVU=;
	h=Date:To:From:Subject:Message-Id; b=JYu50ZTgunRKCjSJnZ8mup/SvniZwUIld+OKUkU7PjwavOzMQ1l7nOrsa4v0GY3aeS9z442GlWgnTVYkJOC1juzWVUmnmx37EDqewLz3zfFFNZf/i5dTum0yIU/kA8+82rW/uK6evn13825MbKJ55FPQtuOfr8AdRWdxlznWzag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1JTusLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1JTusLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C4DC4CED2;
	Thu,  9 Jan 2025 04:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736397343;
	bh=VLcPQx3i7I5JH8tKYYkjuzEqD3nSMJafI9KhXrO4EVU=;
	h=Date:To:From:Subject:From;
	b=o1JTusLPaifBGMGD7QiAVHXr6gvupe/8CQ4mbSZilgsZ9mdffsVflwGKghaP6FjvX
	 WEyKdhYukR1EtoQKQ9aY+mnYS7m+7Kjg+z2j/QSBef5EjSbdKcNBRrM5UojgZw3mUz
	 ALtUDU5hPUNFNUkPT8mEQKTf6y4oZjFx9vaphIBI=
Date: Wed, 08 Jan 2025 20:35:42 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,dev.jain@arm.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] selftests-mm-virtual_address_range-dump-to-dev-null.patch removed from -mm tree
Message-Id: <20250109043543.09C4DC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: dump to /dev/null
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-dump-to-dev-null.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: dump to /dev/null
Date: Tue, 07 Jan 2025 16:14:47 +0100

During the execution of validate_complete_va_space() a lot of memory is on
the VM subsystem.  When running on a low memory subsystem an OOM may be
triggered, when writing to the dump file as the filesystem may also
require memory.

On my test system with 1100MiB physical memory:

	Tasks state (memory values in pages):
	[  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
	[     57]     0    57 34359215953      695      256        0       439 1064390656        0             0 virtual_address

	Out of memory: Killed process 57 (virtual_address) total-vm:137436863812kB, anon-rss:1024kB, file-rss:0kB, shmem-rss:1756kB, UID:0 pgtables:1039444kB oom_score_adj:0
	<snip>
	fault_in_iov_iter_readable+0x4a/0xd0
	generic_perform_write+0x9c/0x280
	shmem_file_write_iter+0x86/0x90
	vfs_write+0x29c/0x480
	ksys_write+0x6c/0xe0
	do_syscall_64+0x9e/0x1a0
	entry_SYSCALL_64_after_hwframe+0x77/0x7f

Write the dumped data into /dev/null instead which does not require
additional memory during write(), making the code simpler as a
side-effect.

Link: https://lkml.kernel.org/r/20250107-virtual_address_range-tests-v1-3-3834a2fb47fe@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-dump-to-dev-null
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -103,10 +103,9 @@ static int validate_complete_va_space(vo
 	FILE *file;
 	int fd;
 
-	fd = open("va_dump", O_CREAT | O_WRONLY, 0600);
-	unlink("va_dump");
+	fd = open("/dev/null", O_WRONLY);
 	if (fd < 0) {
-		ksft_test_result_skip("cannot create or open dump file\n");
+		ksft_test_result_skip("cannot create or open /dev/null\n");
 		ksft_finished();
 	}
 
@@ -152,7 +151,6 @@ static int validate_complete_va_space(vo
 		while (start_addr + hop < end_addr) {
 			if (write(fd, (void *)(start_addr + hop), 1) != 1)
 				return 1;
-			lseek(fd, 0, SEEK_SET);
 
 			hop += MAP_CHUNK_SIZE;
 		}
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch
selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch

