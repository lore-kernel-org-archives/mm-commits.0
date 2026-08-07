Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96523D2B1
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 21:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786139699; cv=none; b=YoMay1YmNJDgwDGIOaprwVTC2KRUDtNn3vcYOYwq8YxvbLeBGeGnkveHdh7Q8ag7Iv90V14yPkOhkd4E5Ir5IR0LofQGSg3oex9nYdoS1EIM1ZFw2oAhut3Att8Uap5+PNTKhFcfEm0/tTq+qricmjNKfvs/J/uVeuHFimYQ9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786139699; c=relaxed/simple;
	bh=+bVqzrGehJuDEtYEoTyDZD+UU+9qTxhA5AIExGZnG+g=;
	h=Date:To:From:Subject:Message-Id; b=ZFkL0eOmbBVewCIFCPMktwO4kNGBWPSXjn9RpfEHq2JGCVX63Quyy1ReGQC6V592wD1IBdhd3anempp8zF6/eos6pUs2k2LAidQ4CE9ztGxFnw4qLeFv+GThlZxBvACHCUD2wHjG2rXONgfwpYcOTGGVV3aewe0+QR6wDXYqges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHrVH5uS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHrVH5uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F301F000E9;
	Fri,  7 Aug 2026 21:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786139697;
	bh=yc3QumXdirbzlmR2Dg+bXUVPp1+/C8Kv6ktGCYdnQPQ=;
	h=Date:To:From:Subject;
	b=sHrVH5uS4D9doogBVPwyS7MmKKXr5ryjOSI8iXZafV2wMlvK1xqdQic1ZmdABxJv5
	 TQIeOOWNFFfOPRAXYH+2H/qD7TO6dCpV+ovD+2ctOnUXtPfsnC9rN14y/cKWKdAx2F
	 i+KS1qS7byTPn2d9+atOVRrezMpYE3lwadp1/0Y0=
Date: Fri, 07 Aug 2026 14:54:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-read_file-return-value-check.patch added to mm-new branch
Message-Id: <20260807215457.50F301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix read_file() return value check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-read_file-return-value-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-read_file-return-value-check.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix read_file() return value check
Date: Fri, 7 Aug 2026 09:35:55 +0800

read_file() returns 0 on open/read failures and never returns negative
values.  Existing < 0 error checks never trigger, so read failures are
silently ignored.  Check for zero return to detect read_file() failures.

Also fix misleading error message in get_finfo().  The error string
incorrectly references read_num when reading uevent files.

Link: https://lore.kernel.org/20260807013555.36525-1-hongfu.li@linux.dev
Fixes: e0c13f9761df ("khugepaged: add self test")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    4 ++--
 tools/testing/selftests/mm/vm_util.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-fix-read_file-return-value-check
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -163,8 +163,8 @@ static void get_finfo(const char *dir)
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
 	    >= sizeof(path))
 		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
-	if (read_file(path, buf, sizeof(buf)) < 0)
-		ksft_exit_fail_perror("read_file(read_num)");
+	if (!read_file(path, buf, sizeof(buf)))
+		ksft_exit_fail_perror("read_file(uevent)");
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-read_file-return-value-check
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -946,7 +946,7 @@ unsigned long read_num(const char *path)
 {
 	char buf[21];
 
-	if (read_file(path, buf, sizeof(buf)) < 0)
+	if (!read_file(path, buf, sizeof(buf)))
 		ksft_exit_fail_perror("read_file()");
 
 	return strtoul(buf, NULL, 10);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
ksm-update-comments-and-docs-to-reference-folio-mapping.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

