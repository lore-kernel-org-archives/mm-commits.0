From: akpm@linux-foundation.org
Subject: + selftests-vm-add-tests-for-lock-on-fault-v9.patch added to -mm
 tree
Date: Fri, 11 Sep 2015 15:12:12 -0700
Message-ID: <55f351bc.2HzfWr590UHMRbrM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbIKWMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, treding@nvidia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-add-tests-for-lock-on-fault-v9
has been added to the -mm tree.  Its filename is
     selftests-vm-add-tests-for-lock-on-fault-v9.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-tests-for-lock-on-fault-v9.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-tests-for-lock-on-fault-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: selftests-vm-add-tests-for-lock-on-fault-v9

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |  170 ++++++++++++++------
 1 file changed, 125 insertions(+), 45 deletions(-)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-v9 tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-v9
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -112,7 +112,7 @@ static uint64_t get_pageflags(unsigned l
 	return pfn;
 }
 
-static unsigned long get_kpageflags(unsigned long pfn)
+static uint64_t get_kpageflags(unsigned long pfn)
 {
 	uint64_t flags;
 	FILE *file;
@@ -137,16 +137,63 @@ static unsigned long get_kpageflags(unsi
 	return flags;
 }
 
+static FILE *seek_to_smaps_entry(unsigned long addr)
+{
+	FILE *file;
+	char *line = NULL;
+	size_t size = 0;
+	unsigned long start, end;
+	char perms[5];
+	unsigned long offset;
+	char dev[32];
+	unsigned long inode;
+	char path[BUFSIZ];
+
+	file = fopen("/proc/self/smaps", "r");
+	if (!file) {
+		perror("fopen smaps");
+		_exit(1);
+	}
+
+	while (getline(&line, &size, file) > 0) {
+		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
+			   &start, &end, perms, &offset, dev, &inode, path) < 6)
+			goto next;
+
+		if (start <= addr && addr < end)
+			goto out;
+
+next:
+		free(line);
+		line = NULL;
+		size = 0;
+	}
+
+	fclose(file);
+	file = NULL;
+
+out:
+	free(line);
+	return file;
+}
+
 #define VMFLAGS "VmFlags:"
 
-static bool find_flag(FILE *file, const char *vmflag)
+static bool is_vmflag_set(unsigned long addr, const char *vmflag)
 {
 	char *line = NULL;
 	char *flags;
 	size_t size = 0;
 	bool ret = false;
+	FILE *smaps;
 
-	while (getline(&line, &size, file) > 0) {
+	smaps = seek_to_smaps_entry(addr);
+	if (!smaps) {
+		printf("Unable to parse /proc/self/smaps\n");
+		goto out;
+	}
+
+	while (getline(&line, &size, smaps) > 0) {
 		if (!strstr(line, VMFLAGS)) {
 			free(line);
 			line = NULL;
@@ -161,47 +208,71 @@ static bool find_flag(FILE *file, const
 
 out:
 	free(line);
+	fclose(smaps);
 	return ret;
 }
 
-static bool is_vmflag_set(unsigned long addr, const char *vmflag)
+#define SIZE "Size:"
+#define RSS  "Rss:"
+#define LOCKED "lo"
+
+static bool is_vma_lock_on_fault(unsigned long addr)
 {
-	FILE *file;
+	bool ret = false;
+	bool locked;
+	FILE *smaps = NULL;
+	unsigned long vma_size, vma_rss;
 	char *line = NULL;
+	char *value;
 	size_t size = 0;
-	bool ret = false;
-	unsigned long start, end;
-	char perms[5];
-	unsigned long offset;
-	char dev[32];
-	unsigned long inode;
-	char path[BUFSIZ];
 
-	file = fopen("/proc/self/smaps", "r");
-	if (!file) {
-		perror("fopen smaps");
-		_exit(1);
+	locked = is_vmflag_set(addr, LOCKED);
+	if (!locked)
+		goto out;
+
+	smaps = seek_to_smaps_entry(addr);
+	if (!smaps) {
+		printf("Unable to parse /proc/self/smaps\n");
+		goto out;
 	}
 
-	while (getline(&line, &size, file) > 0) {
-		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
-			   &start, &end, perms, &offset, dev, &inode, path) < 6)
-			goto next;
+	while (getline(&line, &size, smaps) > 0) {
+		if (!strstr(line, SIZE)) {
+			free(line);
+			line = NULL;
+			size = 0;
+			continue;
+		}
 
-		if (start <= addr && addr < end) {
-			ret = find_flag(file, vmflag);
+		value = line + strlen(SIZE);
+		if (sscanf(value, "%lu kB", &vma_size) < 1) {
+			printf("Unable to parse smaps entry for Size\n");
 			goto out;
 		}
+		break;
+	}
 
-next:
-		free(line);
-		line = NULL;
-		size = 0;
+	while (getline(&line, &size, smaps) > 0) {
+		if (!strstr(line, RSS)) {
+			free(line);
+			line = NULL;
+			size = 0;
+			continue;
+		}
+
+		value = line + strlen(RSS);
+		if (sscanf(value, "%lu kB", &vma_rss) < 1) {
+			printf("Unable to parse smaps entry for Rss\n");
+			goto out;
+		}
+		break;
 	}
 
+	ret = locked && (vma_rss < vma_size);
 out:
 	free(line);
-	fclose(file);
+	if (smaps)
+		fclose(smaps);
 	return ret;
 }
 
@@ -209,9 +280,6 @@ out:
 #define PFN_MASK        0x007FFFFFFFFFFFFF
 #define UNEVICTABLE_BIT (1UL << 18)
 
-#define LOCKED "lo"
-#define LOCKEDONFAULT "lf"
-
 static int lock_check(char *map)
 {
 	unsigned long page_size = getpagesize();
@@ -237,9 +305,13 @@ static int lock_check(char *map)
 		return 1;
 	}
 
-	if (!is_vmflag_set((unsigned long)map, LOCKED) ||
-	    !is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
-		printf("VMA flag %s is missing\n", LOCKED);
+	if (!is_vmflag_set((unsigned long)map, LOCKED)) {
+		printf("VMA flag %s is missing on page 1\n", LOCKED);
+		return 1;
+	}
+
+	if (!is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
+		printf("VMA flag %s is missing on page 2\n", LOCKED);
 		return 1;
 	}
 
@@ -261,9 +333,13 @@ static int unlock_lock_check(char *map)
 		return 1;
 	}
 
-	if (is_vmflag_set((unsigned long)map, LOCKED) ||
-	    is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
-		printf("VMA flag %s is still set after unlock\n", LOCKED);
+	if (is_vmflag_set((unsigned long)map, LOCKED)) {
+		printf("VMA flag %s is present on page 1 after unlock\n", LOCKED);
+		return 1;
+	}
+
+	if (is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
+		printf("VMA flag %s is present on page 2 after unlock\n", LOCKED);
 		return 1;
 	}
 
@@ -344,9 +420,13 @@ static int onfault_check(char *map)
 		return 1;
 	}
 
-	if (!is_vmflag_set((unsigned long)map, LOCKEDONFAULT) ||
-	    !is_vmflag_set((unsigned long)map + page_size, LOCKEDONFAULT)) {
-		printf("VMA flag %s is missing\n", LOCKEDONFAULT);
+	if (!is_vma_lock_on_fault((unsigned long)map)) {
+		printf("VMA is not marked for lock on fault\n");
+		return 1;
+	}
+
+	if (!is_vma_lock_on_fault((unsigned long)map + page_size)) {
+		printf("VMA is not marked for lock on fault\n");
 		return 1;
 	}
 
@@ -366,9 +446,9 @@ static int unlock_onfault_check(char *ma
 		return 1;
 	}
 
-	if (is_vmflag_set((unsigned long)map, LOCKEDONFAULT) ||
-	    is_vmflag_set((unsigned long)map + page_size, LOCKEDONFAULT)) {
-		printf("VMA flag %s is still set after unlock\n", LOCKEDONFAULT);
+	if (is_vma_lock_on_fault((unsigned long)map) ||
+	    is_vma_lock_on_fault((unsigned long)map + page_size)) {
+		printf("VMA is still lock on fault after unlock\n");
 		return 1;
 	}
 
@@ -453,9 +533,9 @@ static int test_lock_onfault_of_present(
 		goto unmap;
 	}
 
-	if (!is_vmflag_set((unsigned long)map, LOCKEDONFAULT) ||
-	    !is_vmflag_set((unsigned long)map + page_size, LOCKEDONFAULT)) {
-		printf("VMA flag %s is missing for one of the pages\n", LOCKEDONFAULT);
+	if (!is_vma_lock_on_fault((unsigned long)map) ||
+	    !is_vma_lock_on_fault((unsigned long)map + page_size)) {
+		printf("VMA with present pages is not marked lock on fault\n");
 		goto unmap;
 	}
 	ret = 0;
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-introduce-vm_lockonfault-v9.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v9.patch
mips-add-entry-for-new-mlock2-syscall.patch

