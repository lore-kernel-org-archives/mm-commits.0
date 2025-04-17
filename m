Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F51204583
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744932377; cv=none; b=PTxdTXA+L4mtXW8BTQaoUUiA+U+Y4BmQzZuAhGNBqDVmlp0SzEU7rmlBKDQ7Wjxpd1xPHbIrl4ADCJkzLaEAh24fKgrtxMOR1HnLZojQmJX9fq/liu8kLH4Q19HPR4rvBKc+q+nx/d8PUvGx5NAYywturLp8MQdAwMJegUrxpC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744932377; c=relaxed/simple;
	bh=9HbEfWEGAj5Gmu+bWaoKvbMH+v6VF3ml6UvmnZQEY7k=;
	h=Date:To:From:Subject:Message-Id; b=Zav184uwd/fK/1VzjbDmksAu2N3VkfGp4r+7OqUNQNSTwMswz/6aOc+F9LeBntGUx8Z47Bedsq0R1xIEm3G2ao6UurcdG5V7nHrw+7a8j3KgHAizouzfyTCMxnjb44UD9mqYZkDl1GG1w5nwZV+qpi1SaSTe0CfN0OwuHPjf6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h47k0sSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h47k0sSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30BDC4CEE4;
	Thu, 17 Apr 2025 23:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744932376;
	bh=9HbEfWEGAj5Gmu+bWaoKvbMH+v6VF3ml6UvmnZQEY7k=;
	h=Date:To:From:Subject:From;
	b=h47k0sSahdqy/Q3vX7nZkq0rawzhEbY1iyt7mlASZMhb83O8sd7u+zmEbxJFLmdJa
	 lz5gJEirUzdwaDgLBJs+h4HimcAA4dDcUT4B9HyhEa50OH2YjfErVrX5HxpbtGeg3v
	 ynCLGaZptbKh7VDuNT0CGiILUYe6dLVkccmnzaSU=
Date: Thu, 17 Apr 2025 16:26:16 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,andrii@kernel.org,yatsenko@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch removed from -mm tree
Message-Id: <20250417232616.D30BDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maccess: fix strncpy_from_user_nofault empty string handling
has been removed from the -mm tree.  Its filename was
     maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Mykyta Yatsenko <yatsenko@meta.com>
Subject: maccess: fix strncpy_from_user_nofault empty string handling
Date: Thu, 17 Apr 2025 16:28:08 +0100

strncpy_from_user_nofault() should return the length of the copied string
including the trailing NUL, but if the argument unsafe_addr points to an
empty string ({'\0'}), the return value is 0.

This happens as strncpy_from_user() copies terminal symbol into dst and
returns 0 (as expected), but strncpy_from_user_nofault does not modify ret
as it is not equal to count and not greater than 0, so 0 is returned,
which contradicts the contract.

Link: https://lkml.kernel.org/r/20250417152808.722409-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_events_filter.c |   10 ++++++++--
 mm/maccess.c                       |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_events_filter.c~maccess-fix-strncpy_from_user_nofault-empty-string-handling
+++ a/kernel/trace/trace_events_filter.c
@@ -800,6 +800,7 @@ static __always_inline char *test_string
 {
 	struct ustring_buffer *ubuf;
 	char *kstr;
+	int cnt;
 
 	if (!ustring_per_cpu)
 		return NULL;
@@ -808,7 +809,9 @@ static __always_inline char *test_string
 	kstr = ubuf->buffer;
 
 	/* For safety, do not trust the string pointer */
-	if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
+	cnt = strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE);
+	/* Return null if empty string or error */
+	if (cnt <= 1)
 		return NULL;
 	return kstr;
 }
@@ -818,6 +821,7 @@ static __always_inline char *test_ustrin
 	struct ustring_buffer *ubuf;
 	char __user *ustr;
 	char *kstr;
+	int cnt;
 
 	if (!ustring_per_cpu)
 		return NULL;
@@ -827,7 +831,9 @@ static __always_inline char *test_ustrin
 
 	/* user space address? */
 	ustr = (char __user *)str;
-	if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
+	cnt = strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE);
+	/* Return null if empty string or error */
+	if (cnt <= 1)
 		return NULL;
 
 	return kstr;
--- a/mm/maccess.c~maccess-fix-strncpy_from_user_nofault-empty-string-handling
+++ a/mm/maccess.c
@@ -196,7 +196,7 @@ long strncpy_from_user_nofault(char *dst
 	if (ret >= count) {
 		ret = count;
 		dst[ret - 1] = '\0';
-	} else if (ret > 0) {
+	} else if (ret >= 0) {
 		ret++;
 	}
 
_

Patches currently in -mm which might be from yatsenko@meta.com are


