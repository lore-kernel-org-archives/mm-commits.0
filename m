Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893813BD65D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439206; cv=none; b=Drmt5gPE1AnTN71qyH/FDMfcDXb4ovO20W95ScFx+3Zdq51ysL78xiy+93DMz0oNTza1ZazqT10J2sOVEuBXUjne1gZ01oFRFNtLQmKZWIiYM6UfWT/qJUbB2XaOtol5g34BAazRfE8OMthL3Voj/PKA8AGSnmC0YdL7FXKFyxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439206; c=relaxed/simple;
	bh=6DYaaIeGk2T+Q5u5oawz6oGe1PBvyJrHjVIham6hetQ=;
	h=Date:To:From:Subject:Message-Id; b=Yl2QFdzmtflLA1TxnWSKuSZiAkC3EzlJ3/xojar44EAYzzXMmx+GLkEycHLhgfH/uWt49u6Bk9PhG2822LyvgykW0xdrB0srLrvFuWwJYoUtLACAnwiL9EAcxfutvgsCkVSkOtbZ0SAiu6Z1otDo63cIP+4jq3ufde2zULgEums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PjA7KSvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PjA7KSvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFD91F00893;
	Tue,  2 Jun 2026 22:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439205;
	bh=VTabyLwl5TnCfz5yv70PgBBTC37uajW3ltq2E2vv6DU=;
	h=Date:To:From:Subject;
	b=PjA7KSvvenqbq+SpxxSfx57kMwhRNZxh2sq3Em6ej7sK6ov7riT9M2ncICKJ9HwI7
	 NxmgOc3tnX9Uvm897PVnuZ/NthwvRrB+Io7hPS0B7M9IxmMaEwxbPzSmGy1e60pxhH
	 p+dQKVxbnw6FCL2PT65BbxEbrNt2+BYfxr0pA12k=
Date: Tue, 02 Jun 2026 15:26:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch removed from -mm tree
Message-Id: <20260602222645.5DFD91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays
has been removed from the -mm tree.  Its filename was
     mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays
Date: Mon, 25 May 2026 10:27:00 +0000

Replace the hardcoded if/else chain of test_bit() calls and string
literals in thpsize_shmem_enabled_show() with a loop over
huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.

This makes thpsize_shmem_enabled_show() consistent with
thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.

Link: https://lore.kernel.org/20260525102700.68707-3-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/mm/shmem.c~mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays
+++ a/mm/shmem.c
@@ -5490,20 +5490,30 @@ static ssize_t thpsize_shmem_enabled_sho
 					  struct kobj_attribute *attr, char *buf)
 {
 	int order = to_thpsize(kobj)->order;
-	const char *output;
+	int active = HUGE_SHMEM_ENABLED_NEVER;
+	int len = 0;
+	int i;
 
-	if (test_bit(order, &huge_shmem_orders_always))
-		output = "[always] inherit within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_inherit))
-		output = "always [inherit] within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_within_size))
-		output = "always inherit [within_size] advise never";
-	else if (test_bit(order, &huge_shmem_orders_madvise))
-		output = "always inherit within_size [advise] never";
-	else
-		output = "always inherit within_size advise [never]";
+	for (i = 0; i < ARRAY_SIZE(huge_mode_orders); i++) {
+		if (test_bit(order, huge_mode_orders[i])) {
+			active = i;
+			break;
+		}
+	}
 
-	return sysfs_emit(buf, "%s\n", output);
+	for (i = 0; i < ARRAY_SIZE(huge_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     huge_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     huge_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
+
+	return len;
 }
 
 static bool set_shmem_enabled_mode(int order, enum huge_mode mode)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


