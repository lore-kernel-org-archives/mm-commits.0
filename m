From: akpm@linux-foundation.org
Subject: + take-the-segment-adding-out-of-locate_mem_hole-functions.patch
 added to -mm tree
Date: Wed, 10 Sep 2014 12:22:18 -0700
Message-ID: <5410a4ea.OBctybfF7k4mvx5Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaIJTWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 15:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: take the segment adding out of locate_mem_hole functions
has been added to the -mm tree.  Its filename is
     take-the-segment-adding-out-of-locate_mem_hole-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/take-the-segment-adding-out-of-locate_mem_hole-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/take-the-segment-adding-out-of-locate_mem_hole-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: take the segment adding out of locate_mem_hole functions

In locate_mem_hole functions, a memory hole is located and added as
kexec_segment.  But from the name of locate_mem_hole, it should only take
responsibility of searching a available memory hole to contain data of a
specified size.

So in this patch add a new field 'mem' into kexec_buf, then take that
kexec segment adding code out of locate_mem_hole_top_down and
locate_mem_hole_bottom_up.  This make clear of the functionality of
locate_mem_hole just like it declars to do.  And by this
locate_mem_hole_callback chould be used later if anyone want to locate a
memory hole for other use.

Meanwhile Vivek suggested opening code function __kexec_add_segment(),
that way we have to retreive ksegment pointer once and it is easy to read.
 So just do it in this patch and remove __kexec_add_segment() since no one
use it anymore.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    1 +
 kernel/kexec.c        |   29 ++++++++---------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff -puN include/linux/kexec.h~take-the-segment-adding-out-of-locate_mem_hole-functions include/linux/kexec.h
--- a/include/linux/kexec.h~take-the-segment-adding-out-of-locate_mem_hole-functions
+++ a/include/linux/kexec.h
@@ -178,6 +178,7 @@ struct kexec_buf {
 	struct kimage *image;
 	char *buffer;
 	unsigned long bufsz;
+	unsigned long mem;
 	unsigned long memsz;
 	unsigned long buf_align;
 	unsigned long buf_min;
diff -puN kernel/kexec.c~take-the-segment-adding-out-of-locate_mem_hole-functions kernel/kexec.c
--- a/kernel/kexec.c~take-the-segment-adding-out-of-locate_mem_hole-functions
+++ a/kernel/kexec.c
@@ -2016,22 +2016,6 @@ static int __init crash_save_vmcoreinfo_
 subsys_initcall(crash_save_vmcoreinfo_init);
 
 #ifdef CONFIG_KEXEC_FILE
-static int __kexec_add_segment(struct kimage *image, char *buf,
-			       unsigned long bufsz, unsigned long mem,
-			       unsigned long memsz)
-{
-	struct kexec_segment *ksegment;
-
-	ksegment = &image->segment[image->nr_segments];
-	ksegment->kbuf = buf;
-	ksegment->bufsz = bufsz;
-	ksegment->mem = mem;
-	ksegment->memsz = memsz;
-	image->nr_segments++;
-
-	return 0;
-}
-
 static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 				    struct kexec_buf *kbuf)
 {
@@ -2064,8 +2048,7 @@ static int locate_mem_hole_top_down(unsi
 	} while (1);
 
 	/* If we are here, we found a suitable memory range */
-	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
-			    kbuf->memsz);
+	kbuf->mem = temp_start;
 
 	/* Success, stop navigating through remaining System RAM ranges */
 	return 1;
@@ -2099,8 +2082,7 @@ static int locate_mem_hole_bottom_up(uns
 	} while (1);
 
 	/* If we are here, we found a suitable memory range */
-	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
-			    kbuf->memsz);
+	kbuf->mem = temp_start;
 
 	/* Success, stop navigating through remaining System RAM ranges */
 	return 1;
@@ -2187,7 +2169,12 @@ int kexec_add_buffer(struct kimage *imag
 	}
 
 	/* Found a suitable memory range */
-	ksegment = &image->segment[image->nr_segments - 1];
+	ksegment = &image->segment[image->nr_segments];
+	ksegment->kbuf = kbuf->buffer;
+	ksegment->bufsz = kbuf->bufsz;
+	ksegment->mem = kbuf->mem;
+	ksegment->memsz = kbuf->memsz;
+	image->nr_segments++;
 	*load_addr = ksegment->mem;
 	return 0;
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
take-the-segment-adding-out-of-locate_mem_hole-functions.patch
check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
kexec-remove-the-unused-function-parameter.patch

