From: akpm@linux-foundation.org
Subject: [merged] profile-hide-unused-functions-when-config_proc_fs.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:25 -0700
Message-ID: <56f2d581.iTXPvyBCOAz2Y8+1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbcCWRm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, cl@linux.com, hannes@cmpxchg.org, robinmholt@gmail.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: profile: hide unused functions when !CONFIG_PROC_FS
has been removed from the -mm tree.  Its filename was
     profile-hide-unused-functions-when-config_proc_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: profile: hide unused functions when !CONFIG_PROC_FS

A couple of functions and variables in the profile implementation are used
only on SMP systems by the procfs code, but are unused if either procfs is
disabled or in uniprocessor kernels.  gcc prints a harmless warning about
the unused symbols:

kernel/profile.c:243:13: error: 'profile_flip_buffers' defined but not used [-Werror=unused-function]
 static void profile_flip_buffers(void)
             ^
kernel/profile.c:266:13: error: 'profile_discard_flip_buffers' defined but not used [-Werror=unused-function]
 static void profile_discard_flip_buffers(void)
             ^
kernel/profile.c:330:12: error: 'profile_cpu_callback' defined but not used [-Werror=unused-function]
 static int profile_cpu_callback(struct notifier_block *info,
            ^

This adds further #ifdef to the file, to annotate exactly in which cases
they are used.  I have done several thousand ARM randconfig kernels with
this patch applied and no longer get any warnings in this file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/profile.c~profile-hide-unused-functions-when-config_proc_fs kernel/profile.c
--- a/kernel/profile.c~profile-hide-unused-functions-when-config_proc_fs
+++ a/kernel/profile.c
@@ -44,7 +44,7 @@ int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
 
 static cpumask_var_t prof_cpu_mask;
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_PROC_FS)
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
 static DEFINE_PER_CPU(int, cpu_profile_flip);
 static DEFINE_MUTEX(profile_flip_mutex);
@@ -202,7 +202,7 @@ int profile_event_unregister(enum profil
 }
 EXPORT_SYMBOL_GPL(profile_event_unregister);
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_PROC_FS)
 /*
  * Each cpu has a pair of open-addressed hashtables for pending
  * profile hits. read_profile() IPI's all cpus to request them
_

Patches currently in -mm which might be from arnd@arndb.de are

staging-goldfish-use-6-arg-get_user_pages.patch

