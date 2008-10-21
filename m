From: akpm@linux-foundation.org
Subject: + profiling-fix-up-config_proc_fs=n-build.patch added to -mm tree
Date: Tue, 21 Oct 2008 09:17:06 -0700
Message-ID: <200810211617.m9LGH6lG031207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbYJUQRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 12:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org


The patch titled
     profiling: fix up CONFIG_PROC_FS=n build
has been added to the -mm tree.  Its filename is
     profiling-fix-up-config_proc_fs=n-build.patch

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
Subject: profiling: fix up CONFIG_PROC_FS=n build
From: Paul Mundt <lethal@linux-sh.org>

In the case where procfs is disabled, create_proc_profile() does not
exist. Stub it in with the others.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/profile.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/profile.h~profiling-fix-up-config_proc_fs=n-build include/linux/profile.h
--- a/include/linux/profile.h~profiling-fix-up-config_proc_fs=n-build
+++ a/include/linux/profile.h
@@ -19,10 +19,16 @@ struct notifier_block;
 
 #if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
 void create_prof_cpu_mask(struct proc_dir_entry *de);
+int create_proc_profile(void);
 #else
 static inline void create_prof_cpu_mask(struct proc_dir_entry *de)
 {
 }
+
+static inline int create_proc_profile(void)
+{
+	return 0;
+}
 #endif
 
 enum profile_type {
@@ -37,7 +43,6 @@ extern int prof_on __read_mostly;
 /* init basic kernel profiler */
 int profile_init(void);
 int profile_setup(char *str);
-int create_proc_profile(void);
 void profile_tick(int type);
 
 /*
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch
profiling-fix-up-config_proc_fs=n-build.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch

