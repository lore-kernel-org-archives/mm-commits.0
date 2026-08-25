Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC112371D1F
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622878; cv=none; b=bO2qg/OkkAl1lqbTCgXTnXb8z6iyqZxPdytFvPdNDY891Hmhfr4bfZkxD6MKHmiyji9hRUD19SpJ6AAUc25NVukgmKbp3+9YRdSNfFktTJZlWCJecv7tNxoj7ku4TVRDhg1IfdUqKzBH2XCg+hIhWfb9qDeQemMTuxPiQMa1aOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622878; c=relaxed/simple;
	bh=1McOqhz8VgKAPzCacYAgBM1quXVJC+lz4Sb5WZc9rGw=;
	h=Date:To:From:Subject:Message-Id; b=SidAoUgcHNefTTBVEWf9qYOav1czgDnyYoaZTW2wN3yJULd91e+EDM/CRPsyLccuaGs8qOyNB7kOiEJhxl7hjt7CaelUyGvWOntmf/YjHS0N2/ML4nG81/4hq1d69R2RY5SKylM7O9AGja67yw8cDyEGhz3XhyHvptoCRRVpkaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXpKyyKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXpKyyKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC451F00A3D;
	Tue, 25 Aug 2026 01:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622876;
	bh=mjPNl7CU50og++o5dbIZVbMplNImls1MT060D4ahPxI=;
	h=Date:To:From:Subject;
	b=IXpKyyKzmZJhGAGtvdOIC8C3f+1MRPNePZFpb276WCxRf6kBf9VS8PgnRDGcU/A9s
	 ybpvrxVoe9rgLMCC4yNYrrpIkQGVnCdNNP2DvaKJo0undimV0XGn0pkqD7xafzZFgu
	 q+wO+IHRbiPGCgebpg6KSup5PdFTZRRIC+uU1igk=
Date: Mon, 24 Aug 2026 18:54:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-read_file-return-value-check.patch removed from -mm tree
Message-Id: <20260825015436.5CC451F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix read_file() return value check
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-read_file-return-value-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -141,8 +141,8 @@ static void get_finfo(const char *dir)
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
@@ -942,7 +942,7 @@ unsigned long read_num(const char *path)
 {
 	char buf[21];
 
-	if (read_file(path, buf, sizeof(buf)) < 0)
+	if (!read_file(path, buf, sizeof(buf)))
 		ksft_exit_fail_perror("read_file()");
 
 	return strtoul(buf, NULL, 10);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

