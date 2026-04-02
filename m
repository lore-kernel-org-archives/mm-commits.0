Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B06235AC06
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100503; cv=none; b=KBTfVfbrrPtAiarRe2yMlE/Q8UsP5KeysFm/l3QusFRao0PT8T8wCmmdEAlxc08NEI5+dH1UsBA2xyDPEwjjKhysssSyA0nqyVZbAAQEy1Ot+BQn0NUIxmEnyQjkazOc6A5+vugM3hKVFalDyS8gjQfxwWAo0Q7p1ekUAdneGa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100503; c=relaxed/simple;
	bh=FCn1E55Jh+XnNaR+sq4sCf7Pqcbq5SCPLhjhMftupAo=;
	h=Date:To:From:Subject:Message-Id; b=t2a11RG0MIrwrolCwoj4N8IDFv/tlUJYhGyIn74Sb9jfCF4OwPX+6oXv5VXzDY4djqL1hPrNB/h0WF1cxp81dTBx24zswWSyzzqvZNFME5pXjs7Wl4Q6P8vSJCa9inmBB3P09B86Jc7WE+7vd71u7IpUvvUtZsoJuEZn3P+EaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RyiZXK8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RyiZXK8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DBCC4CEF7;
	Thu,  2 Apr 2026 03:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100503;
	bh=FCn1E55Jh+XnNaR+sq4sCf7Pqcbq5SCPLhjhMftupAo=;
	h=Date:To:From:Subject:From;
	b=RyiZXK8SyefrsDTyAs67HnPwXHnsBCtDtxxZ37zppUQ/voCkbdXWYQ7zu8kpnuPNi
	 jBfGwxxlKghj415ceZfxgF50qg8COu9XR8K2H1HdEC9gxnINI0WcLQAP6NPoxVXqJL
	 03mIkvxW7qoAweXN8SVCXJVEoJOmQjtm8OQ65FXo=
Date: Wed, 01 Apr 2026 20:28:22 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-vm_util-robust-write_file.patch removed from -mm tree
Message-Id: <20260402032823.01DBCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/vm_util: robust write_file()
has been removed from the -mm tree.  Its filename was
     selftests-mm-vm_util-robust-write_file.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm/vm_util: robust write_file()
Date: Mon, 30 Mar 2026 23:15:01 +0800

Add three more checks for buflen and numwritten. The buflen should be at
least two, that means at least one char and the null-end. The error case
check is added by checking numwriten < 0 instead of numwritten < 1. And the
truncate case is checked. The test will exit if any of these conditions
aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Link: https://lkml.kernel.org/r/20260330151503.670415-6-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-robust-write_file
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -779,15 +779,24 @@ int unpoison_memory(unsigned long pfn)
 
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
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+		ksft_exit_fail_perror("%s open failed", path);
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+	errno = saved_errno;
+	if (numwritten < 0)
+		ksft_exit_fail_perror("%s write(%.*s) failed", path, (int)(buflen - 1),
+				buf);
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

