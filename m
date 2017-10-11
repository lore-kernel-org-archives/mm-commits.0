From: akpm@linux-foundation.org
Subject: + kcov-update-documentation.patch added to -mm tree
Date: Wed, 11 Oct 2017 16:15:18 -0700
Message-ID: <59dea606.yaqjSf+qj0HnI5Og%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdJKXPT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 19:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tchibo@google.com, alex.popov@linux.com, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, keescook@chromium.org, mark.rutland@arm.com, quentin.casasnovas@oracle.com, syzkaller@googlegroups.com, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: update documentation
has been added to the -mm tree.  Its filename is
     kcov-update-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-update-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-update-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Victor Chibotaru <tchibo@google.com>
Subject: kcov: update documentation

The updated documentation describes new KCOV mode for collecting
comparison operands.

Link: http://lkml.kernel.org/r/20171011095459.70721-3-glider@google.com
Signed-off-by: Victor Chibotaru <tchibo@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |   99 +++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 4 deletions(-)

diff -puN Documentation/dev-tools/kcov.rst~kcov-update-documentation Documentation/dev-tools/kcov.rst
--- a/Documentation/dev-tools/kcov.rst~kcov-update-documentation
+++ a/Documentation/dev-tools/kcov.rst
@@ -12,19 +12,30 @@ To achieve this goal it does not collect
 and instrumentation of some inherently non-deterministic parts of kernel is
 disabled (e.g. scheduler, locking).
 
-Usage
------
+kcov is also able to collect comparison operands from the instrumented code
+(this feature currently requires that the kernel is compiled with clang).
+
+Prerequisites
+-------------
 
 Configure the kernel with::
 
         CONFIG_KCOV=y
 
 CONFIG_KCOV requires gcc built on revision 231296 or later.
+
+If the comparison operands need to be collected, set::
+
+	CONFIG_KCOV_ENABLE_COMPARISONS=y
+
 Profiling data will only become accessible once debugfs has been mounted::
 
         mount -t debugfs none /sys/kernel/debug
 
-The following program demonstrates kcov usage from within a test program:
+Coverage collection
+-------------------
+The following program demonstrates coverage collection from within a test
+program using kcov:
 
 .. code-block:: c
 
@@ -44,6 +55,9 @@ The following program demonstrates kcov
     #define KCOV_DISABLE			_IO('c', 101)
     #define COVER_SIZE			(64<<10)
 
+    #define KCOV_TRACE_PC  0
+    #define KCOV_TRACE_CMP 1
+
     int main(int argc, char **argv)
     {
 	int fd;
@@ -64,7 +78,7 @@ The following program demonstrates kcov
 	if ((void*)cover == MAP_FAILED)
 		perror("mmap"), exit(1);
 	/* Enable coverage collection on the current thread. */
-	if (ioctl(fd, KCOV_ENABLE, 0))
+	if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_PC))
 		perror("ioctl"), exit(1);
 	/* Reset coverage from the tail of the ioctl() call. */
 	__atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
@@ -111,3 +125,80 @@ The interface is fine-grained to allow e
 That is, a parent process opens /sys/kernel/debug/kcov, enables trace mode,
 mmaps coverage buffer and then forks child processes in a loop. Child processes
 only need to enable coverage (disable happens automatically on thread end).
+
+Comparison operands collection
+------------------------------
+Comparison operands collection is similar to coverage collection:
+
+.. code-block:: c
+
+    /* Same includes and defines as above. */
+
+    /* Number of 64-bit words per record. */
+    #define KCOV_WORDS_PER_CMP 4
+
+    /*
+     * The format for the types of collected comparisons.
+     *
+     * Bit 0 shows whether one of the arguments is a compile-time constant.
+     * Bits 1 & 2 contain log2 of the argument size, up to 8 bytes.
+     */
+
+    #define KCOV_CMP_CONST          (1 << 0)
+    #define KCOV_CMP_SIZE(n)        ((n) << 1)
+    #define KCOV_CMP_MASK           KCOV_CMP_SIZE(3)
+
+    int main(int argc, char **argv)
+    {
+	int fd;
+	uint64_t *cover, type, arg1, arg2, is_const, size;
+	unsigned long n, i;
+
+	fd = open("/sys/kernel/debug/kcov", O_RDWR);
+	if (fd == -1)
+		perror("open"), exit(1);
+	if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
+		perror("ioctl"), exit(1);
+	/*
+	* Note that the buffer pointer is of type uint64_t*, because all
+	* the comparison operands are promoted to uint64_t.
+	*/
+	cover = (uint64_t *)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
+				     PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if ((void*)cover == MAP_FAILED)
+		perror("mmap"), exit(1);
+	/* Note KCOV_TRACE_CMP instead of KCOV_TRACE_PC. */
+	if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_CMP))
+		perror("ioctl"), exit(1);
+	__atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
+	read(-1, NULL, 0);
+	/* Read number of comparisons collected. */
+	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
+	for (i = 0; i < n; i++) {
+		type = cover[i * KCOV_WORDS_PER_CMP + 1];
+		/* arg1 and arg2 - operands of the comparison. */
+		arg1 = cover[i * KCOV_WORDS_PER_CMP + 2];
+		arg2 = cover[i * KCOV_WORDS_PER_CMP + 3];
+		/* ip - caller address. */
+		ip = cover[i * KCOV_WORDS_PER_CMP + 4];
+		/* size of the operands. */
+		size = 1 << ((type & KCOV_CMP_MASK) >> 1);
+		/* is_const - true if either operand is a compile-time constant.*/
+		is_const = type & KCOV_CMP_CONST;
+		printf("ip: 0x%lx type: 0x%lx, arg1: 0x%lx, arg2: 0x%lx, "
+			"size: %lu, %s\n",
+			ip, type, arg1, arg2, size,
+		is_const ? "const" : "non-const");
+	}
+	if (ioctl(fd, KCOV_DISABLE, 0))
+		perror("ioctl"), exit(1);
+	/* Free resources. */
+	if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
+		perror("munmap"), exit(1);
+	if (close(fd))
+		perror("close"), exit(1);
+	return 0;
+    }
+
+Note that the kcov modes (coverage collection or comparison operands) are
+mutually exclusive.
_

Patches currently in -mm which might be from tchibo@google.com are

kcov-support-comparison-operands-collection.patch
makefile-support-flag-fsanitizer-coverage=trace-cmp.patch
kcov-update-documentation.patch

