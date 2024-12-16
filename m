Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E804A209689
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734368008; cv=none; b=b+TR4YI1QW9+JTQ9bwaSme80sGw9oEifJiLqpkPtGMf788MbIIWOZCCCxNuSOHV3qe0cau13y+jscAXLc/Kqx6npHtcqqLleaPMWySnx/3NS+ySBeNzBjibbV1WXyH+CZl4HkKTOZraYnHjWuSj//zlFM3BST7PUhu5VyHVGWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734368008; c=relaxed/simple;
	bh=Pvn5LT6Mqku1RVXTdGafn1t5Wp/Q+GDMmFZvGJfOVUY=;
	h=Date:To:From:Subject:Message-Id; b=K1D+7eR6OUtmByHDMt9ed0Mcw/Z8nwKZ1UsxrXnWBbEv7Bn2WAlrcEhcqX2YpnI2w9X/fHYSaf9bWGKPrGN8rj+jOzQeQQW1VQran5tOjXioVMtl0BXWF9JJWZ6lnwhdPi6l/1appMBoMC9w9FysSnVBzTS9hkCzcJp9PJ3pT+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zx54fhNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zx54fhNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37672C4CED0;
	Mon, 16 Dec 2024 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734368007;
	bh=Pvn5LT6Mqku1RVXTdGafn1t5Wp/Q+GDMmFZvGJfOVUY=;
	h=Date:To:From:Subject:From;
	b=Zx54fhNeQzyL/PDeMRNuAHMEgRkIxeJXZxNmNQu7raZzsf/YoNi0UA0WlCCBd74rJ
	 dyKHtZZ11hanB41q2LVYwP34kzT2YaaQHXOs8NJFMpYiSm9YWNZrKwQXQAP79u9k1E
	 B2GsFscBTrME/TjzOBOn5Qy+g5vDv63MwecqeWL8=
Date: Mon, 16 Dec 2024 08:53:26 -0800
To: mm-commits@vger.kernel.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_idle-constify-struct-bin_attribute.patch added to mm-unstable branch
Message-Id: <20241216165327.37672C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_idle: constify 'struct bin_attribute'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_idle-constify-struct-bin_attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_idle-constify-struct-bin_attribute.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: mm/page_idle: constify 'struct bin_attribute'
Date: Mon, 16 Dec 2024 13:20:25 +0100

The sysfs core now allows instances of 'struct bin_attribute' to be moved
into read-only memory.  Make use of that to protect them against
accidental or malicious modifications.

Link: https://lkml.kernel.org/r/20241216-sysfs-const-bin_attr-page_idle-v1-1-cc01ecc55196@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_idle.c~mm-page_idle-constify-struct-bin_attribute
+++ a/mm/page_idle.c
@@ -112,7 +112,7 @@ static void page_idle_clear_pte_refs(str
 }
 
 static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
-				     struct bin_attribute *attr, char *buf,
+				     const struct bin_attribute *attr, char *buf,
 				     loff_t pos, size_t count)
 {
 	u64 *out = (u64 *)buf;
@@ -157,7 +157,7 @@ static ssize_t page_idle_bitmap_read(str
 }
 
 static ssize_t page_idle_bitmap_write(struct file *file, struct kobject *kobj,
-				      struct bin_attribute *attr, char *buf,
+				      const struct bin_attribute *attr, char *buf,
 				      loff_t pos, size_t count)
 {
 	const u64 *in = (u64 *)buf;
@@ -193,17 +193,17 @@ static ssize_t page_idle_bitmap_write(st
 	return (char *)in - buf;
 }
 
-static struct bin_attribute page_idle_bitmap_attr =
+static const struct bin_attribute page_idle_bitmap_attr =
 		__BIN_ATTR(bitmap, 0600,
 			   page_idle_bitmap_read, page_idle_bitmap_write, 0);
 
-static struct bin_attribute *page_idle_bin_attrs[] = {
+static const struct bin_attribute *const page_idle_bin_attrs[] = {
 	&page_idle_bitmap_attr,
 	NULL,
 };
 
 static const struct attribute_group page_idle_attr_group = {
-	.bin_attrs = page_idle_bin_attrs,
+	.bin_attrs_new = page_idle_bin_attrs,
 	.name = "page_idle",
 };
 
_

Patches currently in -mm which might be from linux@weissschuh.net are

mm-page_idle-constify-struct-bin_attribute.patch

