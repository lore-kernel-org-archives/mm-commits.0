From: akpm@linux-foundation.org
Subject: + brk-compat_brk-fix-detection-of-randomized-brk.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:42:09 -0700
Message-ID: <201104112342.p3BNg94l011161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab1DKXmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, geert@linux-m68k.org


The patch titled
     brk: COMPAT_BRK: fix detection of randomized brk
has been added to the -mm tree.  Its filename is
     brk-compat_brk-fix-detection-of-randomized-brk.patch

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
Subject: brk: COMPAT_BRK: fix detection of randomized brk
From: Jiri Kosina <jkosina@suse.cz>

5520e89 ("brk: fix min_brk lower bound computation for COMPAT_BRK") tried
to get the whole logic of brk randomization for legacy (libc5-based)
applications finally right.

It turns out that the way to detect whether brk has actually been
randomized in the end or not introduced by that patch still doesn't work
for those binaries, as reported by Geert.

I don't like it, but currently see no better option than a bit flag in
task_struct to catch the CONFIG_COMPAT_BRK && randomize_va_space == 2
case.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    6 +++++-
 include/linux/sched.h |    3 +++
 mm/mmap.c             |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~brk-compat_brk-fix-detection-of-randomized-brk fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~brk-compat_brk-fix-detection-of-randomized-brk
+++ a/fs/binfmt_elf.c
@@ -941,9 +941,13 @@ static int load_elf_binary(struct linux_
 	current->mm->start_stack = bprm->p;
 
 #ifdef arch_randomize_brk
-	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1))
+	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
+#ifdef CONFIG_COMPAT_BRK
+		current->brk_randomized = 1;
+#endif
+	}
 #endif
 
 	if (current->personality & MMAP_PAGE_ZERO) {
diff -puN include/linux/sched.h~brk-compat_brk-fix-detection-of-randomized-brk include/linux/sched.h
--- a/include/linux/sched.h~brk-compat_brk-fix-detection-of-randomized-brk
+++ a/include/linux/sched.h
@@ -1253,6 +1253,9 @@ struct task_struct {
 #endif
 
 	struct mm_struct *mm, *active_mm;
+#ifdef CONFIG_COMPAT_BRK
+	unsigned brk_randomized:1;
+#endif
 #if defined(SPLIT_RSS_COUNTING)
 	struct task_rss_stat	rss_stat;
 #endif
diff -puN mm/mmap.c~brk-compat_brk-fix-detection-of-randomized-brk mm/mmap.c
--- a/mm/mmap.c~brk-compat_brk-fix-detection-of-randomized-brk
+++ a/mm/mmap.c
@@ -263,7 +263,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * randomize_va_space to 2, which will still cause mm->start_brk
 	 * to be arbitrarily shifted
 	 */
-	if (mm->start_brk > PAGE_ALIGN(mm->end_data))
+	if (current->brk_randomized)
 		min_brk = mm->start_brk;
 	else
 		min_brk = mm->end_data;
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
brk-compat_brk-fix-detection-of-randomized-brk.patch
jbd-remove-dependency-on-__gfp_nofail.patch

