Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EC41EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676250; cv=none; b=Tal3J0X1Ebi0OzRS34FwULP3otXonQKbrLyijXdT4i5Znz5ZmVg8v5AQnaYRZDpcpZlADZfv+QMj34xOXt3omW90wHC+sXYoZ3ZlX7+2Ms45nZ5wBCyfPAV4yriSFzb/jHlTWGxhJI8c6mqjW1Urlu8pCq4QGs2efAKqvq5dHf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676250; c=relaxed/simple;
	bh=ZlJEfjjPdhA78PCF3eEAf5YhwMbroYkEgBNjtpbMw64=;
	h=Date:To:From:Subject:Message-Id; b=NV7RdcScGOCebK4LcvQaQX2WbgVvtAb4XI7ei1cTi/IaSWjv81iwTlhzzfh1+Yt7slWNQ3s2rfTe8rH+kNsIMhPmS1g1TWR7buKDwbBvEu9ILxYKGb9LfXOvvdusCRto/egU3a0XrXf1+KJcO9Wz16DarHw3PEMMhvT4KdGqMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbOysErm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbOysErm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C12C4CEF1;
	Thu, 20 Nov 2025 22:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676250;
	bh=ZlJEfjjPdhA78PCF3eEAf5YhwMbroYkEgBNjtpbMw64=;
	h=Date:To:From:Subject:From;
	b=dbOysErm8h0LlIR2gJhMRLgO8pffLyMOUcT1G4s5vLDPnW9AqGFVGbZLSDLP73hdn
	 vj3WNQpfIALyja0hhCtOv4aOxg5zTsUEhergaGxfRFgmHim9eYO6rCVk8OAqlS/yVl
	 SW6GmgPhslLUOI9BCkwd5KtKYIJdYQC7ofe6ld1I=
Date: Thu, 20 Nov 2025 14:04:09 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch removed from -mm tree
Message-Id: <20251120220410.34C12C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: sys_info: capture si_bits_global before iterating over it
has been removed from the -mm tree.  Its filename was
     panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: sys_info: capture si_bits_global before iterating over it
Date: Thu, 30 Oct 2025 12:44:17 +0100

Patch series "panic: sys_info: Refactor and fix a potential issue", v3.

While targeting the compilation issue due to dangling variable, I have
noticed more opportunities for refactoring that helps to avoid above
mentioned compilation issue in a cleaner way and also fixes a potential
problem with global variable access.


This patch (of 6):

The for-loop might re-read the content of the memory the si_bits_global
points to on each iteration.  Instead, just capture it for the sake of
consistency and use that instead.

Link: https://lkml.kernel.org/r/20251030132007.3742368-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20251030132007.3742368-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-capture-si_bits_global-before-iterating-over-it
+++ a/lib/sys_info.c
@@ -58,11 +58,11 @@ int sysctl_sys_info_handler(const struct
 	char names[sizeof(sys_info_avail)];
 	struct ctl_table table;
 	unsigned long *si_bits_global;
+	unsigned long si_bits;
 
 	si_bits_global = ro_table->data;
 
 	if (write) {
-		unsigned long si_bits;
 		int ret;
 
 		table = *ro_table;
@@ -81,9 +81,12 @@ int sysctl_sys_info_handler(const struct
 		char *delim = "";
 		int i, len = 0;
 
+		/* The access to the global value is not synchronized. */
+		si_bits = READ_ONCE(*si_bits_global);
+
 		names[0] = '\0';
 		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
-			if (*si_bits_global & si_names[i].bit) {
+			if (si_bits & si_names[i].bit) {
 				len += scnprintf(names + len, sizeof(names) - len,
 					"%s%s", delim, si_names[i].name);
 				delim = ",";
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


