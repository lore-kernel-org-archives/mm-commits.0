Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E65345CAF
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779218576; cv=none; b=cqiq+Bp8MAwMRkQkdhZvNqZHKuKeDLIgMUgVdO/bLbVp1AP0WIahJPodiLsbm1QKVAJOROL+Wkdtd0JfzwtJPxHBOncLxk59eHxln4OjvdmjkY0Jyt4zoMulmtpiL7OGN+76BFSGwg9DlO5oNh85RAb8eXaAXQR9oA994+hX6Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779218576; c=relaxed/simple;
	bh=qTO/Gl5QaX+pFINDlpsHfMcLHtidSqcaHnxWQuuVPhQ=;
	h=Date:To:From:Subject:Message-Id; b=YYp/x4ITv3/QH3KcGGoU6U++Fjz42fNcZ9vxo5NcOO/+kAN8KzNgn0a4XcDtcU/jDoXB6QL3oMPvbJkks57+TlGRnSUVEjgb3DV08Re9Citr1QUK95Jr4J7G8Pc6q8WrpeTWqaxsv/1SuaRQjZg+OnxppQk6ZW3nHa/BprpEuiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0uzj0v/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0uzj0v/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384731F000E9;
	Tue, 19 May 2026 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779218574;
	bh=I+cTzsCw3+XzdbHav5l/JL8260I73GHTFAnPskyHGDM=;
	h=Date:To:From:Subject;
	b=0uzj0v/hWG1Acxe9Aqwkd8MNmhxeg35iBKRVXpAbLuCArv5jXVLSmdfKQ4M2anp0D
	 35BACzgMT4j+bXOJDFOVGKbgoDdXlhrOMeXunu+erixDK+7B48OkG1vRdmc/facidD
	 erDGDTcWYCw8Ypz6bepC8TWrvpiVwJUVgQc6GZzU=
Date: Tue, 19 May 2026 12:22:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch added to mm-new branch
Message-Id: <20260519192254.384731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch

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
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
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

mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch
mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch

