Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859843;
	b=fLlYzjdMcyRoqTdkjFXysIdWX/8nMuIe0IInYmhIiCQpX37LU4Ymu2NvSGkEsVOJMamH
	 zXuq/DGtw6RlOHmO0El0TvbPAwyzWJUa85lrMU/lOIBPI4NlG+2ElJe+3hXSwrjpaf++z
	 y9Bqh57G4gMf+H/iaPEDEGbOHci4UPsdomdTkRIaB0srq+AaLK3L+yS4cheZwiFo0fP2F
	 3PzRmBNz0w+QguGHK3GiQENGJweDyEK3Ot9+e9Srjq0oh+jI4h0oA30/DzLtGKa2bpp4f
	 P6wB20GBZrwCzb7knhzZbiLPIMmAb7Bvb6tu8jeZ7Js60hEgplnmAcNf5avFPnJvzZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859843;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wibrfQAWcGMVaStgkco3gg46MlfqUZuqrEZbt0ZB9Zg=;
	b=PUjEekefRp3GoxgCEVMM5yZ3ZHy8ZT3PYY8znGOQEpqocjTZWVJbzW7rEdCNhBYI86A1
	 Y8h+mGev2IjTqyEmLIa4rW9otgBFylu3Xjwwc2TKdIg0Zp8wKcjomf4Wv5sGgPkCEIcqo
	 Z+nV/wbTWQM+elm/Nd/abGAPqPhA3UvQNh4utzj2Hms4sPbkmvmfDioBuQqAa+IQ6fQ+I
	 qlXKR0LDnB1MTNhG8CmCiagQ9EkLrOeGArLy9Bw+WVFuxipJliKZDGkIJmlmBz/N4jYds
	 O4GqWSoYFmLFZ6R2bROiAdi+9xBy8SqSINVPV6lbPmzaIc5sU5B3MggooZVgTnZuuMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JL7biYT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ABD606A32F
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 20:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JL7biYT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D201F000C5;
	Mon, 16 Nov 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794859842;
	bh=wibrfQAWcGMVaStgkco3gg46MlfqUZuqrEZbt0ZB9Zg=;
	h=Date:To:From:Subject;
	b=JL7biYT5FE8MkdVV8aQjv083Dil7/cURnruF+IMH5iLI2A1TARoJCEIUK7v2AcksK
	 lV6dgT6SmEN/OTCPUoMTCC08nHaagegTY+H6s/FAcGJMSxE3669VoC9z6Z4/8speo2
	 7f9pbWxSdqPvdd4w3/SkXj///aYPCjl3/yqPZ+UM=
Date: Mon, 16 Nov 2026 12:10:41 -0800
To: mm-commits@vger.kernel.org,dmonakhov@openvz.org,axboe@kernel.dk,
	akinobu.mita@gmail.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch added to mm-nonmm-unstable branch
Message-Id: <20261116201042.61D201F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fault-inject: fix wrong unit of verbose_ratelimit_interval_ms
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: fault-inject: fix wrong unit of verbose_ratelimit_interval_ms
Date: Tue, 17 Nov 2026 01:16:12 +0900

The interval of ratelimit_state is in jiffies.  But
verbose_ratelimit_interval_ms is read and written without converting the
interval, so the value is in milliseconds only if HZ is 1000.

If HZ is 250, writing 1000 sets the interval to 4 seconds.

So use jiffies_to_msecs() and msecs_to_jiffies() when reading and writing.
Also clamp values which are too large for the interval.

Link: https://lore.kernel.org/20261116161613.3663822-1-ekffu200098@gmail.com
Fixes: 6adc4a22f20b ("fault-inject: add ratelimit option")
Fixes: 4668c7a2940d ("fault-inject: allow configuration via configfs")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>

 lib/fault-inject.c |   58 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

--- a/lib/fault-inject.c~fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms
+++ a/lib/fault-inject.c
@@ -199,6 +199,8 @@ bool should_fail(struct fault_attr *attr
 }
 EXPORT_SYMBOL_GPL(should_fail);
 
+#define FAULT_RATELIMIT_INTERVAL_MAX_MS	(INT_MAX / DIV_ROUND_UP(HZ, MSEC_PER_SEC))
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
 static int debugfs_ul_set(void *data, u64 val)
@@ -221,6 +223,29 @@ static void debugfs_create_ul(const char
 	debugfs_create_file(name, mode, parent, value, &fops_ul);
 }
 
+static int debugfs_ratelimit_interval_set(void *data, u64 val)
+{
+	val = min_t(u64, val, FAULT_RATELIMIT_INTERVAL_MAX_MS);
+	*(int *)data = msecs_to_jiffies(val);
+
+	return 0;
+}
+
+static int debugfs_ratelimit_interval_get(void *data, u64 *val)
+{
+	*val = jiffies_to_msecs(*(int *)data);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_ratelimit_interval, debugfs_ratelimit_interval_get,
+			debugfs_ratelimit_interval_set, "%llu\n");
+
+static void debugfs_create_ratelimit_interval(const char *name, umode_t mode,
+					      struct dentry *parent, int *value)
+{
+	debugfs_create_file(name, mode, parent, value, &fops_ratelimit_interval);
+}
+
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
 static int debugfs_stacktrace_depth_set(void *data, u64 val)
@@ -260,8 +285,8 @@ struct dentry *fault_create_debugfs_attr
 	debugfs_create_atomic_t("times", mode, dir, &attr->times);
 	debugfs_create_atomic_t("space", mode, dir, &attr->space);
 	debugfs_create_ul("verbose", mode, dir, &attr->verbose);
-	debugfs_create_u32("verbose_ratelimit_interval_ms", mode, dir,
-			   &attr->ratelimit_state.interval);
+	debugfs_create_ratelimit_interval("verbose_ratelimit_interval_ms", mode,
+					  dir, &attr->ratelimit_state.interval);
 	debugfs_create_u32("verbose_ratelimit_burst", mode, dir,
 			   &attr->ratelimit_state.burst);
 	debugfs_create_bool("task-filter", mode, dir, &attr->task_filter);
@@ -394,12 +419,37 @@ FAULT_CONFIGFS_ATTR(interval, ulong);
 FAULT_CONFIGFS_ATTR(times, atomic_t);
 FAULT_CONFIGFS_ATTR(space, atomic_t);
 FAULT_CONFIGFS_ATTR(verbose, ulong);
-FAULT_CONFIGFS_ATTR_NAMED(ratelimit_interval, "verbose_ratelimit_interval_ms",
-		ratelimit_state.interval, uint);
 FAULT_CONFIGFS_ATTR_NAMED(ratelimit_burst, "verbose_ratelimit_burst",
 		ratelimit_state.burst, uint);
 FAULT_CONFIGFS_ATTR_NAMED(task_filter, "task-filter", task_filter, bool);
 
+static ssize_t fault_ratelimit_interval_show(struct config_item *item, char *page)
+{
+	struct fault_config *config = to_fault_config(item);
+	unsigned int msecs = jiffies_to_msecs(config->attr.ratelimit_state.interval);
+
+	return fault_uint_attr_show(msecs, page);
+}
+
+static ssize_t fault_ratelimit_interval_store(struct config_item *item, const char *page,
+		size_t count)
+{
+	struct fault_config *config = to_fault_config(item);
+	unsigned int msecs;
+	int result;
+
+	result = kstrtouint(page, 0, &msecs);
+	if (result < 0)
+		return result;
+
+	msecs = min_t(unsigned int, msecs, FAULT_RATELIMIT_INTERVAL_MAX_MS);
+	config->attr.ratelimit_state.interval = msecs_to_jiffies(msecs);
+
+	return count;
+}
+
+CONFIGFS_ATTR_NAMED(fault_, ratelimit_interval, "verbose_ratelimit_interval_ms");
+
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
 static ssize_t fault_stacktrace_depth_show(struct config_item *item, char *page)
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch

