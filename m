Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AA02673AA
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676255; cv=none; b=TVNv//FCdKQZ4IAdvxjAkBXLvetIsscfPaV4gRxhsL+1CKl8q5FaZssZi7qybPXveNJ1xSMGnciKAjbsn6prQnvAftQUYqz8OGhsHUyQtgKglpHJZ19HsFb3+jCYQF8x//LgiA9/cqQSoxFYO/WrVoBP8gxVyRqareHrCFi0UsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676255; c=relaxed/simple;
	bh=xMVe6KpNKqU8FZP8DhKyskA+MYsWE4Av6eHya8bxlag=;
	h=Date:To:From:Subject:Message-Id; b=DfHUDUBnw4hrB0UgkCNcV1bBPPXyXNgmrgE/FoUOk+ZzkqkhrxCFuO0S1ePSsubdLLCToOx40tWw/FqyOD7F5Qxffpz8tXGKRFWwL7qVpSdabKd8zT4QdFkNkv1b9b8ks7njxWlaWkTDxTGZilGvjqg3BX0dUrUFGgGLs7yLTgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kVXjTrip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kVXjTrip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30414C4CEF1;
	Thu, 20 Nov 2025 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676255;
	bh=xMVe6KpNKqU8FZP8DhKyskA+MYsWE4Av6eHya8bxlag=;
	h=Date:To:From:Subject:From;
	b=kVXjTripMdNif78lJ/HnCUWUNllOA2IEVB7yxqRjIBxs7YEl/E6Tqz5virYXci90h
	 mclByGT0lkOOyKLtSWgJGjroKT3c2y+hGLwi+dwC4LzqNHBV9oayDPCZ4llDRAeIAK
	 BE6tUfhh2PJYqp1+LAth9fHk7rZbWIcZhTv+H7sQ=
Date: Thu, 20 Nov 2025 14:04:14 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-sys_info-factor-out-read-and-write-handlers.patch removed from -mm tree
Message-Id: <20251120220415.30414C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: sys_info: factor out read and write handlers
has been removed from the -mm tree.  Its filename was
     panic-sys_info-factor-out-read-and-write-handlers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: sys_info: factor out read and write handlers
Date: Thu, 30 Oct 2025 12:44:22 +0100

For the sake of the code readability and easier maintenance factor out
read and write sys_info handlers.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20251030132007.3742368-7-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |   79 +++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-factor-out-read-and-write-handlers
+++ a/lib/sys_info.c
@@ -43,18 +43,56 @@ unsigned long sys_info_parse_param(char
 
 #ifdef CONFIG_SYSCTL
 
+static int sys_info_write_handler(const struct ctl_table *table,
+				  void *buffer, size_t *lenp, loff_t *ppos,
+				  unsigned long *si_bits_global)
+{
+	unsigned long si_bits;
+	int ret;
+
+	ret = proc_dostring(table, 1, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+
+	si_bits = sys_info_parse_param(table->data);
+
+	/* The access to the global value is not synchronized. */
+	WRITE_ONCE(*si_bits_global, si_bits);
+
+	return 0;
+}
+
+static int sys_info_read_handler(const struct ctl_table *table,
+				 void *buffer, size_t *lenp, loff_t *ppos,
+				 unsigned long *si_bits_global)
+{
+	unsigned long si_bits;
+	unsigned int len = 0;
+	char *delim = "";
+	unsigned int i;
+
+	/* The access to the global value is not synchronized. */
+	si_bits = READ_ONCE(*si_bits_global);
+
+	for_each_set_bit(i, &si_bits, ARRAY_SIZE(si_names)) {
+		if (*si_names[i]) {
+			len += scnprintf(table->data + len, table->maxlen - len,
+					 "%s%s", delim, si_names[i]);
+			delim = ",";
+		}
+	}
+
+	return proc_dostring(table, 0, buffer, lenp, ppos);
+}
+
 int sysctl_sys_info_handler(const struct ctl_table *ro_table, int write,
 					  void *buffer, size_t *lenp,
 					  loff_t *ppos)
 {
 	struct ctl_table table;
-	unsigned long *si_bits_global;
-	unsigned long si_bits;
 	unsigned int i;
 	size_t maxlen;
 
-	si_bits_global = ro_table->data;
-
 	maxlen = 0;
 	for (i = 0; i < ARRAY_SIZE(si_names); i++)
 		maxlen += strlen(si_names[i]) + 1;
@@ -67,35 +105,10 @@ int sysctl_sys_info_handler(const struct
 	table.data = names;
 	table.maxlen = maxlen;
 
-	if (write) {
-		int ret;
-
-		ret = proc_dostring(&table, write, buffer, lenp, ppos);
-		if (ret)
-			return ret;
-
-		si_bits = sys_info_parse_param(names);
-		/* The access to the global value is not synchronized. */
-		WRITE_ONCE(*si_bits_global, si_bits);
-		return 0;
-	} else {
-		/* for 'read' operation */
-		unsigned int len = 0;
-		char *delim = "";
-
-		/* The access to the global value is not synchronized. */
-		si_bits = READ_ONCE(*si_bits_global);
-
-		for_each_set_bit(i, &si_bits, ARRAY_SIZE(si_names)) {
-			if (*si_names[i]) {
-				len += scnprintf(names + len, maxlen - len,
-						 "%s%s", delim, si_names[i]);
-				delim = ",";
-			}
-		}
-
-		return proc_dostring(&table, write, buffer, lenp, ppos);
-	}
+	if (write)
+		return sys_info_write_handler(&table, buffer, lenp, ppos, ro_table->data);
+	else
+		return sys_info_read_handler(&table, buffer, lenp, ppos, ro_table->data);
 }
 #endif
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


