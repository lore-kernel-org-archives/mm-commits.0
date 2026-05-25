Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5562833ADAF
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779737820; cv=none; b=sygZALRYCICmWGKX4aU+zL8HM79l0N38MEZQbcyTUfUD9IsQiap3lrBXhUgSl8OeniGn/BxKutZlYQem/FPObEWU9y80eE6qK/FW2s5gYid6lY7o115O7kAjHdoZUUGErgfrkIyLwpuFmj9+D02h5C0iisZXX/SKA/p/Dn7Grk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779737820; c=relaxed/simple;
	bh=gq5Vy4Wy7SE/YyLV7blfIR1faygVn73iHvfAhMqWRo8=;
	h=Date:To:From:Subject:Message-Id; b=f8FFY+CtM80h3QbyskuHHKhnBCZTIn6EnuLatKuvQWGuaPEDJhASTyu/la4+gChKVpXZ3LxnnnxXHPT2rJX/EaP9ag22BLBs84aBnLpLRkD7XPedqr8wRxQqGI3TGXKHhXQOJjg7CSdtXCGapPrmx8/JzQX3dseghNBoQ9oAdmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zdgBYTkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zdgBYTkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71251F00A3A;
	Mon, 25 May 2026 19:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779737819;
	bh=IYZ0YqjIkDNcWWvpI9pfulfD5IUREMr05eFfveXPlCc=;
	h=Date:To:From:Subject;
	b=zdgBYTkh2J7c3aozu4oPqwuFuK38IuzCkwzsV9h/YcW79DgPiK2bYVPGaacnPnB1b
	 e9z1AyEoFIZe/7lzKzp+gyK3flxqKr4jWjYsRPOEWijdJ9ukJmzDy1IGP6nniVh1EP
	 B7MUkxOJy7xwbjusIiKSIPfasvDWBB6R7GfPeT10=
Date: Mon, 25 May 2026 12:36:58 -0700
To: mm-commits@vger.kernel.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch removed from -mm tree
Message-Id: <20260525193658.E71251F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays
has been removed from the -mm tree.  Its filename was
     mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays
Date: Mon, 18 May 2026 12:32:38 +0000

Replace the hardcoded if/else chain of test_bit() calls and string
literals in thpsize_shmem_enabled_show() with a loop over
huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.

This makes thpsize_shmem_enabled_show() consistent with
thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.

Link: https://lore.kernel.org/20260518123238.56344-3-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
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
+	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
+		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
+			active = i;
+			break;
+		}
+	}
 
-	return sysfs_emit(buf, "%s\n", output);
+	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     huge_shmem_enabled_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     huge_shmem_enabled_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
+
+	return len;
 }
 
 static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


