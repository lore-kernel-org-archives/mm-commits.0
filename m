Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B0024024E
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736818115; cv=none; b=E0RvldtGZhgzHvDJAvn3BqVqk+mUMXg8XB/jlyhkjYHXa42WhO8d0aa8VnBbG6V9r0NbHiPuyuZUhxTjoeLkGj+eI7NSj0qc5fOYxi6X0OtnSTl3jTGNgWMiTUvHhW4SIno0DEBqwDXVk7Zu1luNZ+hIm7RcIPkmDMJtZkcH8MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736818115; c=relaxed/simple;
	bh=knw3TVeIbSIpTbCZ0woiAJM/Ln58IU+jTbkyGIVQTpE=;
	h=Date:To:From:Subject:Message-Id; b=AYiviASIN3ZzjSJfmgqpiLNStK1eExmly8tPKSjHSgmGMRHCBqVVvkDHNRrE78TTPEh2AdJP37oEbFEfZDDouQGTnEYcDo6B9WlPeG/mbtEOBUeKjGX9E0r7hzvAaObXdAp+SefYteD6sKxesWFuoJ2PhjzuqSb4gAo68PKcSxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RChj54SU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RChj54SU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63F7C4CED6;
	Tue, 14 Jan 2025 01:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736818114;
	bh=knw3TVeIbSIpTbCZ0woiAJM/Ln58IU+jTbkyGIVQTpE=;
	h=Date:To:From:Subject:From;
	b=RChj54SUuw+BztUUu9GWsB8s61fA/teeC+JDbQlodw7iu/rokY6rzxLNq36MMpXIa
	 rK0PK0gZTNxBKGFLbCpvEcpbrJn5mSf+dK2ghs//X3UZgYuhPqy6GaZJdZrn1RO/BQ
	 QwOVCdUehYKezZLTXLk3V6bzvkOU97vkyCOYAFRU=
Date: Mon, 13 Jan 2025 17:28:34 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch added to mm-unstable branch
Message-Id: <20250114012834.D63F7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: vm_util: split up /proc/self/smaps parsing
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch

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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: vm_util: split up /proc/self/smaps parsing
Date: Mon, 13 Jan 2025 14:15:37 +0100

Upcoming changes want to reuse the /proc/self/smaps parsing logic to parse
the VmFlags field.

As that works differently from the currently parsed HugePage counters,
split up the logic so common functionality can be shared.

While reworking this code, also use the correct sscanf placeholder for the
"uint64_t thp" variable.

Link: https://lkml.kernel.org/r/20250113-virtual_address_range-tests-v3-3-f4a8e6b7feed@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   42 +++++++++++++++++--------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-split-up-proc-self-smaps-parsing
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -2,6 +2,7 @@
 #include <string.h>
 #include <fcntl.h>
 #include <dirent.h>
+#include <inttypes.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>
 #include <linux/fs.h>
@@ -193,13 +194,11 @@ err_out:
 	return rss_anon;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
-		  uint64_t hpage_size)
+char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 {
-	uint64_t thp = -1;
 	int ret;
 	FILE *fp;
-	char buffer[MAX_LINE_LENGTH];
+	char *entry;
 	char addr_pattern[MAX_LINE_LENGTH];
 
 	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
@@ -211,23 +210,40 @@ bool __check_huge(void *addr, char *patt
 	if (!fp)
 		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, SMAP_FILE_PATH);
 
-	if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
+	if (!check_for_pattern(fp, addr_pattern, buf, len))
 		goto err_out;
 
-	/*
-	 * Fetch the pattern in the same block and check the number of
-	 * hugepages.
-	 */
-	if (!check_for_pattern(fp, pattern, buffer, sizeof(buffer)))
+	/* Fetch the pattern in the same block */
+	if (!check_for_pattern(fp, pattern, buf, len))
 		goto err_out;
 
-	snprintf(addr_pattern, MAX_LINE_LENGTH, "%s%%9ld kB", pattern);
+	/* Trim trailing newline */
+	entry = strchr(buf, '\n');
+	if (entry)
+		*entry = '\0';
 
-	if (sscanf(buffer, addr_pattern, &thp) != 1)
-		ksft_exit_fail_msg("Reading smap error\n");
+	entry = buf + strlen(pattern);
 
 err_out:
 	fclose(fp);
+	return entry;
+}
+
+bool __check_huge(void *addr, char *pattern, int nr_hpages,
+		  uint64_t hpage_size)
+{
+	char buffer[MAX_LINE_LENGTH];
+	uint64_t thp = -1;
+	char *entry;
+
+	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
+	if (!entry)
+		goto err_out;
+
+	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
+		ksft_exit_fail_msg("Reading smap error\n");
+
+err_out:
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-mmap-without-prot_write.patch
selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch
selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch
selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

