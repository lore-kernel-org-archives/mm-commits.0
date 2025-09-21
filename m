Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEB12C08CA
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489984; cv=none; b=GDa+IrnIVfLUIYKmnWp3TzrH7yy6PB3aAFLkttS26uRAkTqwxmllsVfRB7Us6C/929G5/Av4wLlhpSQCO9Y/MhCZ+sVtvqjW0qjH8soPg4RuKC6i47y+UlgR2xxklNBZ4TiokL6+Hdwi7IG1/DJzyiRoeejZQR32L52bdQlom2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489984; c=relaxed/simple;
	bh=7CRDLYdT8tQIY580vuqnj0hRKr4CIc3RhOeqjuNA7xQ=;
	h=Date:To:From:Subject:Message-Id; b=kDsCI2H/P/9c9s1p9I2Pr8GOcN6ldVxg+AMdQ5rej689U9ZRxPx8HwnzMqyyCjdtlKtU2+XpOS7qsVh0clWmXOh3wLlS/xZDyhSV8RmjdGdQ805PqUpTsMj/2bkAStU5lUIWLSpf41I2EqMjf6zFSaEue8WBJ+9PkXqde42yHFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SahXf50l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SahXf50l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C667FC4CEE7;
	Sun, 21 Sep 2025 21:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489983;
	bh=7CRDLYdT8tQIY580vuqnj0hRKr4CIc3RhOeqjuNA7xQ=;
	h=Date:To:From:Subject:From;
	b=SahXf50l+ixXlRbaZ3rrbnBHBlV9SaNNSNz4KM2pwWWfpwouvXIRtDsn+TzTynOuD
	 lL0VaBejWXNjWKQSZyr/N9mQebrR6Ji09OYgneHuQ7OA4jkI+Yas5UMD59XLuudsdO
	 rNQhuxaxVmHlFQ8qyFvvju1pgNljzcu3qt/PJMyM=
Date: Sun, 21 Sep 2025 14:26:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch removed from -mm tree
Message-Id: <20250921212623.C667FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: prevent enabling memory profiling if it was shut down
has been removed from the -mm tree.  Its filename was
     alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: prevent enabling memory profiling if it was shut down
Date: Mon, 15 Sep 2025 14:27:55 -0700

Memory profiling can be shut down due to reasons like a failure during
initialization.  When this happens, the user should not be able to
re-enable it.  Current sysctrl interface does not handle this properly and
will allow re-enabling memory profiling.  Fix this by checking for this
condition during sysctrl write operation.

Link: https://lkml.kernel.org/r/20250915212756.3998938-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down
+++ a/lib/alloc_tag.c
@@ -766,6 +766,20 @@ struct page_ext_operations page_alloc_ta
 EXPORT_SYMBOL(page_alloc_tagging_ops);
 
 #ifdef CONFIG_SYSCTL
+/*
+ * Not using proc_do_static_key() directly to prevent enabling profiling
+ * after it was shut down.
+ */
+static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!mem_profiling_support && write)
+		return -EINVAL;
+
+	return proc_do_static_key(table, write, buffer, lenp, ppos);
+}
+
+
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
@@ -775,7 +789,7 @@ static struct ctl_table memory_allocatio
 #else
 		.mode		= 0644,
 #endif
-		.proc_handler	= proc_do_static_key,
+		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
 
_

Patches currently in -mm which might be from surenb@google.com are


