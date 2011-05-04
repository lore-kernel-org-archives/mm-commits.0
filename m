From: akpm@linux-foundation.org
Subject: + kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch added to -mm tree
Date: Wed, 04 May 2011 14:50:30 -0700
Message-ID: <201105042150.p44LoUa4016416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876Ab1EDVub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 17:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com


The patch titled
     kernel/profile.c: remove some duplicate code from profile_hits()
has been added to the -mm tree.  Its filename is
     kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/profile.c: remove some duplicate code from profile_hits()
From: Rakib Mullick <rakib.mullick@gmail.com>

profile_hits() has a common check for prof_on and prof_buffer regardless
of SMP or !SMP.  So, remove some duplicate code by splitting profile_hits
into two.

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
+void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
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
+void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
-
-	if (prof_on != type || !prof_buffer)
-		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
 }
 #endif /* !CONFIG_SMP */
+
+void profile_hits(int type, void *__pc, unsigned int nr_hits)
+{
+	if (prof_on != type || !prof_buffer)
+		return;
+	do_profile_hits(type, __pc, nr_hits);
+}
 EXPORT_SYMBOL_GPL(profile_hits);
 
 void profile_tick(int type)
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch
kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch

