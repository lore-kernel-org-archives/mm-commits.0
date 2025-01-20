Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800F1EAE7
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337159; cv=none; b=CcOSHwYS7NvojL7qza3QLMsK0X1Z6cvIpk4FfLsQDEKJJJwEHwRmQQ2Ezzbj+0GjT1u02Juy7KtBT+XIBQTRRO3ctZ4YNd2SFnBJgeDWDMmTWBVspyhoMtHnAfmJ7Vzopqd3bnFlNgF25xekTlXID28IpP3hHwaLwpFef/tE+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337159; c=relaxed/simple;
	bh=F18MsGMSqj3LyhSqQ4vbQ+xtLj0imvKEBW38JWmGy4U=;
	h=Date:To:From:Subject:Message-Id; b=tXJ8ZBiTZkACbY6fWHWDKLa0AgswoTwI9i2cndoAD56gDAt57ktGYwhp/6nCTKCuaPX9GLWJ6A8p0hOpdFsg6qK3+R6NBV65rX9Cr1B8yuefyesq8M6dmVXFzzDXGou5GLEXMeVXO9FcdPoGeTpKDtX+w/eBjuwU+ZJEV2b48C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qoshqmcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qoshqmcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D0CC4CEE0;
	Mon, 20 Jan 2025 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337159;
	bh=F18MsGMSqj3LyhSqQ4vbQ+xtLj0imvKEBW38JWmGy4U=;
	h=Date:To:From:Subject:From;
	b=Qoshqmcl0ISxh18D8aA0S/QxDUH9W7/6vPM9whbdiyNAlkWx/U2GjgTNHGo6w9fUk
	 uZN0ugbMoU1e5qXk6URs6Ol/CjpGMsJ9wS2rfVCAviiPCEELAZGZuHoPPFcdfRcgd4
	 NoPerVB9aIFxmieu5yJHwtMNRZeZ6eYHRAfoHd7I=
Date: Sun, 19 Jan 2025 17:39:18 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,khandual@linux.vnet.ibm.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch removed from -mm tree
Message-Id: <20250120013919.03D0CC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: vm_util: split up /proc/self/smaps parsing
has been removed from the -mm tree.  Its filename was
     selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: vm_util: split up /proc/self/smaps parsing
Date: Tue, 14 Jan 2025 17:06:47 +0100

Upcoming changes want to reuse the /proc/self/smaps parsing logic to parse
the VmFlags field.

As that works differently from the currently parsed HugePage counters,
split up the logic so common functionality can be shared.

While reworking this code, also use the correct sscanf placeholder for the
"uint64_t thp" variable.

Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-3-6fd7269934a5@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
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
+	char *entry = NULL;
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


