Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4070A2D0C8B
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880381; cv=none; b=m+R8qvjLl8f7xdbCJMfzlWStvj1H4fSDulPkJcwBFNLRpcJtvud72N/3Zm1I8bqPhBf4vFZikgmjGpYNgCTAdkyssGO4q09YAoeTzRFtDkSYs6FbB542tAt/RkL1EoSX+PwSjvYKe9K0Bt0G4A3IoV2lie+Rn4SBeIDCpqKFqz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880381; c=relaxed/simple;
	bh=yJq20wX8Cq31T8vjZkkMw5JsgWr06Z2DEI+Xe28eG9M=;
	h=Date:To:From:Subject:Message-Id; b=rDEwE4omK/1ILbhDYIpxEifOHeymK9PJZcXOm3M2LMoyPNyEtUmwDpLmbHV63d6TRx1KJI2RJoW3+qrZSn7+5Cx40NP46kGHebWm/yiulvjifXbaHJGo/JN0ljkXNE8lzJ3rqR9RT/o85HnIA02gABULTveGKhNhNr7b6L5MaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sYmeo7yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sYmeo7yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1476CC4CEFD;
	Fri, 31 Oct 2025 03:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880381;
	bh=yJq20wX8Cq31T8vjZkkMw5JsgWr06Z2DEI+Xe28eG9M=;
	h=Date:To:From:Subject:From;
	b=sYmeo7yu0wIm+BICiP1ymGdAlNScPQDFYlRFiuO3LGgxbjbiRoSbzXC7k95GYgqJj
	 UkMflanzbDNHpxsKtm1e/irInBMrya6sx1rdWSZGcQmYSzKyzKC9BGuDbcsyaYEgqm
	 3SSGM/+Q8FrIKccxYaxgkqSHeJg+JJFrPg35oMg4=
Date: Thu, 30 Oct 2025 20:13:00 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-factor-out-read-and-write-handlers.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031301.1476CC4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: sys_info: factor out read and write handlers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-factor-out-read-and-write-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-factor-out-read-and-write-handlers.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: sys_info: factor out read and write handlers
Date: Thu, 30 Oct 2025 12:44:22 +0100

For the sake of the code readability and easier maintenance factor out
read and write sys_info handlers.

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
 
+static int sys_info_write_handler(struct ctl_table *table,
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
+static int sys_info_read_handler(struct ctl_table *table,
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

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch

