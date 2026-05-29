Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ABA36F420
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027614; cv=none; b=evOwsJUCMhwT7ZVE1xny/gTYPt360a+T4XkRHP4kxNSsF+m9Cl1LYYDsF+Z04a7TDViSQGlnufTCOJp12cA463SBxWdWzgmdBVSCwlF9jjHNQ7UkAvwI8lTHCC0VO7Fo8YjPDRwvwyOcrnReeRm4nwcK6jrKOUNwL5Wf0YXIgW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027614; c=relaxed/simple;
	bh=H5qdyTs7IgswQJUjt91UFbeUn/7ymZVy732EJZguk4Y=;
	h=Date:To:From:Subject:Message-Id; b=r501YzKFz1ouYhLuCaw1yd9Ln7vI8SjrPJCP7rrfgeSW/lqBDUdVTwahNRJtcefxIHCXaNxjaXU1Rpzk9nkCSjTtqV2/u4oyaHmnF1JTO3lWY8bXZdsFyHNJMu3nseX8x092DeWLQIo98lTAgLsrrjmBAqFoEozgNr4GBzV4pJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jwtcACZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jwtcACZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBA11F00893;
	Fri, 29 May 2026 04:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027613;
	bh=SIKiIEaaAoJs3/aQ9PiL6ZelWP8Vlh3CGXzPn8vWbkQ=;
	h=Date:To:From:Subject;
	b=jwtcACZmi47KA6jX7+vEwRPiflj6580Y7OZj95WNHSO3CoEo8BVjig4MCKkCk6tXz
	 Vpy7FOIW/PXoZhYU2jpK2+/oVcViaEfgP0SiyvWMZSSQOCE8M4cid/zFADDebhWXhF
	 pNFr5xIOxTIFgvIWmgu4zyqipxOAyaPg6pjdc7ks=
Date: Thu, 28 May 2026 21:06:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch removed from -mm tree
Message-Id: <20260529040652.DBBA11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: refactor defrag_show() to use defrag_flags[]
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: huge_memory: refactor defrag_show() to use defrag_flags[]
Date: Wed, 08 Apr 2026 08:47:01 -0700

Replace the hardcoded if/else chain of test_bit() calls and string
literals in defrag_show() with a loop over defrag_flags[] and
defrag_mode_strings[] arrays introduced in the previous commit.

This makes defrag_show() consistent with defrag_store() and eliminates the
duplicated mode name strings.

Link: https://lore.kernel.org/20260408-thp_defrag-v2-2-bc544c1bde4e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-defrag_show-to-use-defrag_flags
+++ a/mm/huge_memory.c
@@ -455,24 +455,30 @@ static const enum transparent_hugepage_f
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
-	const char *output;
+	int active = DEFRAG_NEVER;
+	int len = 0;
+	int i;
 
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
-		     &transparent_hugepage_flags))
-		output = "[always] defer defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always [defer] defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer [defer+madvise] madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer defer+madvise [madvise] never";
-	else
-		output = "always defer defer+madvise madvise [never]";
+	for (i = 0; i < ARRAY_SIZE(defrag_flags); i++) {
+		if (test_bit(defrag_flags[i], &transparent_hugepage_flags)) {
+			active = i;
+			break;
+		}
+	}
 
-	return sysfs_emit(buf, "%s\n", output);
+	for (i = 0; i < ARRAY_SIZE(defrag_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     defrag_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     defrag_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
+
+	return len;
 }
 
 static ssize_t defrag_store(struct kobject *kobj,
_

Patches currently in -mm which might be from leitao@debian.org are


