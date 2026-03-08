Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C53927FD5D
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773003972; cv=none; b=VvgDMgY9WIfuPu3m4S8ODVgdUjZXenLeDgPqO5wucGIN6qKgxpPZf10TGL0EmKxEY+YFGMtS/5EApXDC4mbiNu+TP3OfNj1FgwWWDYiQHKXw+qmyQkhaDl1Dk0TngtCQrtiM4IV6yyypatrlLfDqaRLgKpi9w56lTL0I8IT7zpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773003972; c=relaxed/simple;
	bh=DCF0SKqFOqJ6btquXGVJZ6iZi6VfbwZE2oazAS+X9so=;
	h=Date:To:From:Subject:Message-Id; b=FW14cjq/K6341yNeHY5jJF6K70qKsYPUnyZYGLZ/Xjz84EUbLHdVziEDijmpcClb0xe9AYdPj3NoDrEJA6A4p5EZ3u8fKGBk49vx4tSiwTbX03NShi6+JtU4cZkdu9W3rACS+T/Kke1WJ6EiYUE7Bb5FwVIn/QRm5DVMvY9RGzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5LTX4Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5LTX4Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F3BC116C6;
	Sun,  8 Mar 2026 21:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773003971;
	bh=DCF0SKqFOqJ6btquXGVJZ6iZi6VfbwZE2oazAS+X9so=;
	h=Date:To:From:Subject:From;
	b=u5LTX4MfGrzwr1jkzZn+3W6+NAXxmdmzOHHlShi48ucXPPSqMr51kx/0+yhR933Cj
	 6nS1cOYQZS4FwG2rLzR1jr6ZT+W2w9ssUB2MxySD2EGLfkEE67qCx+0yf2uuClknBC
	 HQcFm4bo47MjaoqUxjKa5YhXdqCDOhXJqOdRlFeA=
Date: Sun, 08 Mar 2026 14:06:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch added to mm-new branch
Message-Id: <20260308210611.A2F3BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
Date: Sat, 07 Mar 2026 08:08:06 -0800

Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
anon_enabled_store() into a new change_anon_orders() helper that loops
over an orders[] array, setting the bit for the selected mode and clearing
the others.

Introduce enum anon_enabled_mode and anon_enabled_mode_strings[] for the
per-order anon THP setting.

Use sysfs_match_string() with the anon_enabled_mode_strings[] table to
replace the if/else chain of sysfs_streq() calls.

The helper uses test_and_set_bit()/test_and_clear_bit() to track whether
the state actually changed, so start_stop_khugepaged() is only called when
needed.  When the mode is unchanged, set_recommended_min_free_kbytes() is
called directly to preserve the watermark recalculation behavior of the
original code.

Link: https://lkml.kernel.org/r/20260307-thp_logs-v3-2-a45d2c8f3685@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   84 +++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders
+++ a/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobje
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum anon_enabled_mode {
+	ANON_ENABLED_ALWAYS,
+	ANON_ENABLED_MADVISE,
+	ANON_ENABLED_INHERIT,
+	ANON_ENABLED_NEVER,
+};
+
+static const char * const anon_enabled_mode_strings[] = {
+	[ANON_ENABLED_ALWAYS]	= "always",
+	[ANON_ENABLED_MADVISE]	= "madvise",
+	[ANON_ENABLED_INHERIT]	= "inherit",
+	[ANON_ENABLED_NEVER]	= "never",
+};
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
@@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool change_anon_orders(int order, enum anon_enabled_mode mode)
+{
+	static unsigned long *orders[] = {
+		&huge_anon_orders_always,
+		&huge_anon_orders_madvise,
+		&huge_anon_orders_inherit,
+	};
+	bool changed = false;
+	int i;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (i = 0; i < ARRAY_SIZE(orders); i++) {
+		if (i == mode)
+			changed |= !test_and_set_bit(order, orders[i]);
+		else
+			changed |= test_and_clear_bit(order, orders[i]);
+	}
+	spin_unlock(&huge_anon_orders_lock);
+
+	return changed;
+}
+
 static ssize_t anon_enabled_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_always);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_inherit);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		set_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(anon_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
-		int err;
+	if (change_anon_orders(order, mode)) {
+		int err = start_stop_khugepaged();
 
-		err = start_stop_khugepaged();
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+
+	return count;
 }
 
 static struct kobj_attribute anon_enabled_attr =
_

Patches currently in -mm which might be from leitao@debian.org are

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch
mm-huge_memory-refactor-enabled_store-with-change_enabled.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch

