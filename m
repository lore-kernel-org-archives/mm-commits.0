Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D14264617
	for <mm-commits@vger.kernel.org>; Sat,  8 Nov 2025 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625664; cv=none; b=nUrhQqQ9OXmRHqmg/tQb3Z4UcuzJ0W4wJNzzhj0QtUUia2AnwHcagW2dKn6WbIPvmdaIbXr7vtS2sFJMLy7J09TPSauvBQDm8TJSV2rcVYoa9nvvZs7IhC0vB9F26JuUpsla44KuH5F8R4GZc4CimrrEcCJJiFmrhCrP7N4zLSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625664; c=relaxed/simple;
	bh=5E4Pls2F0K0gCOxhhBnbc+aodOgB3TgMpunXTMigUxU=;
	h=Date:To:From:Subject:Message-Id; b=fLaeW/XyJIUYWBIq1dypYnuCcEaDKjFC7WeepL2Ke6MzJk1LPtzv0vNMGCmoER6dOTanKY5lv5GEHHc/lHPcJBqAKr8X7FMeZuY/Y++L+3XUdIjI5oEafEeuBLkcjyubSj8j4uUZMZTycJl39Vb9puOkJXD6hHld+5g/Za8gd4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZE6kX4KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZE6kX4KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BD9C4CEF7;
	Sat,  8 Nov 2025 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762625663;
	bh=5E4Pls2F0K0gCOxhhBnbc+aodOgB3TgMpunXTMigUxU=;
	h=Date:To:From:Subject:From;
	b=ZE6kX4KN/y+bwdAjuIErL7OkKaT8FDhkAqi0HgGKhkbdn1LhP74F7DwvIAZXfgwFQ
	 grXd2n0vCTb48mu7n7blcwfUTDx9Y/zJqJA6UCd9LMmIno2N/7AILqvhps9lIo4peZ
	 GmImQ5zurp7yRvo7ttZar1MRebAzLqSgVaxbLz0M=
Date: Sat, 08 Nov 2025 10:14:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,ankitkhushwaha.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-fix-pointer-comparison-in-mremap_test.patch added to mm-unstable branch
Message-Id: <20251108181423.B1BD9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: fix pointer comparison in mremap_test
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-fix-pointer-comparison-in-mremap_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-fix-pointer-comparison-in-mremap_test.patch

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
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch
selftest-mm-fix-pointer-comparison-in-mremap_test.patch

