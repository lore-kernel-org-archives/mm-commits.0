From: akpm@linux-foundation.org
Subject: + oprofile-dont-request-cache-line-alignment-for-cpu_buffer.patch added to -mm tree
Date: Tue, 13 May 2008 08:14:45 -0700
Message-ID: <200805131514.m4DFEjbr018405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbYEMPP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 11:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, travis@sgi.com


The patch titled
     oprofile: don't request cache line alignment for cpu_buffer
has been added to the -mm tree.  Its filename is
     oprofile-dont-request-cache-line-alignment-for-cpu_buffer.patch

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
Subject: oprofile: don't request cache line alignment for cpu_buffer
From: Eric Dumazet <dada1@cosmosbay.com>

Alignment was previously requested because cpu_buffer was an [NR_CPUS]
array, to avoid cache line sharing between CPUS.

After commit 608dfddd845da5ab6accef70154c8910529699f7 (oprofile: change
cpu_buffer from array to per_cpu variable ), we dont need to force an
alignement anymore since cpu_buffer sits in per_cpu zone.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/cpu_buffer.c |    2 +-
 drivers/oprofile/cpu_buffer.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/oprofile/cpu_buffer.c~oprofile-dont-request-cache-line-alignment-for-cpu_buffer drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~oprofile-dont-request-cache-line-alignment-for-cpu_buffer
+++ a/drivers/oprofile/cpu_buffer.c
@@ -27,7 +27,7 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer);
+DEFINE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
 
diff -puN drivers/oprofile/cpu_buffer.h~oprofile-dont-request-cache-line-alignment-for-cpu_buffer drivers/oprofile/cpu_buffer.h
--- a/drivers/oprofile/cpu_buffer.h~oprofile-dont-request-cache-line-alignment-for-cpu_buffer
+++ a/drivers/oprofile/cpu_buffer.h
@@ -46,7 +46,7 @@ struct oprofile_cpu_buffer {
 	unsigned long sample_invalid_eip;
 	int cpu;
 	struct delayed_work work;
-} ____cacheline_aligned;
+};
 
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

oprofile-dont-request-cache-line-alignment-for-cpu_buffer.patch
linux-next.patch

