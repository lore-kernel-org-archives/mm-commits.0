From: akpm@linux-foundation.org
Subject: + lockstat-better-class-name-representation.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:58:56 -0700
Message-ID: <200706122058.l5CKwuca021037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbXFLU7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     lockstat: better class name representation
has been added to the -mm tree.  Its filename is
     lockstat-better-class-name-representation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockstat: better class name representation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

optionally add class->name_version and class->subclass to the class name

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletion(-)

diff -puN kernel/lockdep_proc.c~lockstat-better-class-name-representation kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockstat-better-class-name-representation
+++ a/kernel/lockdep_proc.c
@@ -421,8 +421,30 @@ static void seq_stats(struct seq_file *m
 	class = data->class;
 	stats = &data->stats;
 
-	snprintf(name, 38, "%s", class->name);
+	namelen = 38;
+	if (class->name_version > 1)
+		namelen -= 2; /* XXX truncates versions > 9 */
+	if (class->subclass)
+		namelen -= 2;
+
+	if (!class->name) {
+		char str[KSYM_NAME_LEN];
+		const char *key_name;
+
+		key_name = __get_key_name(class->key, str);
+		snprintf(name, namelen, "%s", key_name);
+	} else {
+		snprintf(name, namelen, "%s", class->name);
+	}
 	namelen = strlen(name);
+	if (class->name_version > 1) {
+		snprintf(name+namelen, 3, "#%d", class->name_version);
+		namelen += 2;
+	}
+	if (class->subclass) {
+		snprintf(name+namelen, 3, "/%d", class->subclass);
+		namelen += 2;
+	}
 
 	if (stats->write_holdtime.nr) {
 		if (stats->read_holdtime.nr)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
