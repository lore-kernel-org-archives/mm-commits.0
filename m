From: akpm@linux-foundation.org
Subject: [merged] kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:09 -0700
Message-ID: <201105271957.p4RJvEon017647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab1E0UHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:07:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/profile.c: remove some duplicate code from profile_hits()
has been removed from the -mm tree.  Its filename was
     kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/profile.c: remove some duplicate code from profile_hits()
From: Rakib Mullick <rakib.mullick@gmail.com>

profile_hits() has a common check for prof_on and prof_buffer regardless
of SMP or !SMP.  So, remove some duplicate code by splitting profile_hits
into two.

[akpm@linux-foundation.org: make do_profile_hits static]
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-remove-some-duplicate-code-from-profile_hits kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-remove-some-duplicate-code-from-profile_hits
+++ a/kernel/profile.c
@@ -303,14 +303,12 @@ static void profile_discard_flip_buffers
 	mutex_unlock(&profile_flip_mutex);
 }
 
-void profile_hits(int type, void *__pc, unsigned int nr_hits)
+static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
-		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
 	secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -417,16 +415,20 @@ out_free:
 #define profile_discard_flip_buffers()	do { } while (0)
 #define profile_cpu_callback		NULL
 
-void profile_hits(int type, void *__pc, unsigned int nr_hits)
+static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
