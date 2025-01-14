Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682723D3DC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837086; cv=none; b=eCZx54nF4TcNShwjpOmS3zv7mf/tmkAEtbm1RCCIcgbkPX8h9wbJvXWZlH1RE9K1inKcqZpr7CF9yiqH5mRREXanT4reWFVbbkqC7woqIOEEQsC0MOlNzFI4Euj8gUZRkdle6tHafkbH33uLonk5IKTjZim/xewcnrkTDvvRUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837086; c=relaxed/simple;
	bh=utU9Opp4S+a8QyeLVdY30twOsFXIH2jc+i+Pu6O2HSQ=;
	h=Date:To:From:Subject:Message-Id; b=eVa2KEfTbF615l1eXqbwr86usby2y6QhihB2oV+5bIlNbc7Zz8r8ZlT6bWws/Xb2zhSj/+otmlxJdv9+ou9EaTVKdf7dvs2RMWrUgejirbMXCGXD/N7uEF5Mt2ciDQkWc0a8s5Y4RV/rujT8FMebVsME/fCasE29JwsKaXQOp1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bQQRGW3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bQQRGW3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8937CC4CEDD;
	Tue, 14 Jan 2025 06:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837086;
	bh=utU9Opp4S+a8QyeLVdY30twOsFXIH2jc+i+Pu6O2HSQ=;
	h=Date:To:From:Subject:From;
	b=bQQRGW3SLxvJq6gM8lc93lxqJ02cZpawjDzBkoRZ9uMgQtDOaEuRbTvL8ILgpQlgm
	 Q5KNJoEGoCtAuOuLRtDJhTFpACsPCkXAfrTMoHfOzQMVOyQMkNv37PSOr9jOJ6ihB+
	 GANJenESozWdhzUwcpyWwW99N8/rsZJDABAMGad0=
Date: Mon, 13 Jan 2025 22:44:46 -0800
To: mm-commits@vger.kernel.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_idle-constify-struct-bin_attribute.patch removed from -mm tree
Message-Id: <20250114064446.8937CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_idle: constify 'struct bin_attribute'
has been removed from the -mm tree.  Its filename was
     mm-page_idle-constify-struct-bin_attribute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


