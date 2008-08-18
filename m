From: akpm@linux-foundation.org
Subject: + proc-self-maps-doesnt-display-the-real-file-offset.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:12:12 -0700
Message-ID: <200808182112.m7ILCDet012960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYHRVMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cboulte@gmail.com


The patch titled
     Subject: [PATCH] /proc/self/maps doesn't display the real file offset
has been added to the -mm tree.  Its filename is
     proc-self-maps-doesnt-display-the-real-file-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Subject: [PATCH] /proc/self/maps doesn't display the real file offset
From: Clement Calmels <cboulte@gmail.com>

2.6.26 kernel on i386 platform.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11318

In function show_map (file: fs/proc/task_mmu.c), if vma->vm_pgoff > 2^20
than (vma->vm_pgoff << PAGE_SIZE) is greater than 2^32 (with PAGE_SIZE
equal to 4096 (i.e.  2^12).  The next seq_printf use an unsigned long for
the conversion of (vma->vm_pgoff << PAGE_SIZE), as a result the offset
value displayed in /proc/self/maps is truncated if the page offset is
greater than 2^20.

A test that shows this issue:

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define PAGE_SIZE (getpagesize())

#if __i386__
#   define U64_STR "%llx"
#elif __x86_64
#   define U64_STR "%lx"
#else
#   error "Architecture Unsupported"
#endif

int main(int argc, char *argv[])
{
	int fd;
	char *addr;
	off64_t offset = 0x10000000;
	char *filename = "/dev/zero";

	fd = open(filename, O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	offset *= 0x10;
	printf("offset = " U64_STR "\n", offset);

	addr = (char*)mmap64(NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd,
			     offset);
	if ((void*)addr == MAP_FAILED) {
		perror("mmap64");
		return 1;
	}

	{
		FILE *fmaps;
		char *line = NULL;
		size_t len = 0;
		ssize_t read;
		size_t filename_len = strlen(filename);

		fmaps = fopen("/proc/self/maps", "r");
		if (!fmaps) {
			perror("fopen");
			return 1;
		}
		while ((read = getline(&line, &len, fmaps)) != -1) {
			if ((read > filename_len + 1)
			    && (strncmp(&line[read - filename_len - 1], filename,
filename_len) == 0))
				printf("%s", line);
		}

		if (line)
			free(line);

		fclose(fmaps);
	}

	close(fd);
	return 0;
}

Signed-off-by: Clement Calmels <cboulte@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/nommu.c    |    4 ++--
 fs/proc/task_mmu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/nommu.c~proc-self-maps-doesnt-display-the-real-file-offset fs/proc/nommu.c
--- a/fs/proc/nommu.c~proc-self-maps-doesnt-display-the-real-file-offset
+++ a/fs/proc/nommu.c
@@ -52,14 +52,14 @@ int nommu_vma_show(struct seq_file *m, s
 	}
 
 	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 		   vma->vm_start,
 		   vma->vm_end,
 		   flags & VM_READ ? 'r' : '-',
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   vma->vm_pgoff << PAGE_SHIFT,
+		   ((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
diff -puN fs/proc/task_mmu.c~proc-self-maps-doesnt-display-the-real-file-offset fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-self-maps-doesnt-display-the-real-file-offset
+++ a/fs/proc/task_mmu.c
@@ -219,14 +219,14 @@ static int show_map(struct seq_file *m, 
 		ino = inode->i_ino;
 	}
 
-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			vma->vm_start,
 			vma->vm_end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
-			vma->vm_pgoff << PAGE_SHIFT,
+		        ((loff_t) vma->vm_pgoff) << PAGE_SHIFT,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
 	/*
_

Patches currently in -mm which might be from cboulte@gmail.com are

proc-self-maps-doesnt-display-the-real-file-offset.patch

