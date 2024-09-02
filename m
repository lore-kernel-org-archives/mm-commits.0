Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB50145B14
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248849; cv=none; b=i6bL5UHjqLN3uTr/WdQ+eFUHuejhcArSygE2lJN0NPAp6gkFFsMiyzvIBYi7q0jfHS0eGQY/W1N9ljzrtqDCxwIph6xpc7jmuUhkNrJcCat3gPhOm2Mc/rrqT3m7yPK35spHNlPRrnr3m6MYOqv9SM0QmzJmXvPazLbyzVn/69o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248849; c=relaxed/simple;
	bh=E1jGBZyD6j1yo0gWapB5+FX/6ZfZCjmvUgMbPIjgRRg=;
	h=Date:To:From:Subject:Message-Id; b=jUKeqty6nmNdM7akNdDhq0/pMVnRTf40sNXrpF/zV3ogEP4lfSy64ymSCwvcDpLukgF1DSzHyuBkjMA6OGThxoOaaiHMIgVHotWyichZRxRwt/FQcc1x2XnX7g3KfMj5jSVlvnSMH8QFLIuFlVz1W6ZSeHQMDhkGUBUf8lGDJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yr8PIoRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yr8PIoRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EEFC4CEC2;
	Mon,  2 Sep 2024 03:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248849;
	bh=E1jGBZyD6j1yo0gWapB5+FX/6ZfZCjmvUgMbPIjgRRg=;
	h=Date:To:From:Subject:From;
	b=yr8PIoRUy+qI6L2xWvqOu1J18U178qf9OhwKPbChJ6tQiMmxr7aevntmubZkagbeN
	 bDlITqXnSReLwlUtw45VO+HRZ6kHU0DRwxRsYqZHsU0uecA/pSkKolfHL1R1s0Ub0V
	 Gl9IvlIg62chYGtlvaYw/c7EENQ2U/S7jbmmj0jI=
Date: Sun, 01 Sep 2024 20:47:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,trondmy@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,anna@kernel.org,andy@kernel.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-make-use-of-str_true_false-helper.patch removed from -mm tree
Message-Id: <20240902034729.46EEFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make use of str_true_false helper
has been removed from the -mm tree.  Its filename was
     mm-make-use-of-str_true_false-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongbo Li <lihongbo22@huawei.com>
Subject: mm: make use of str_true_false helper
Date: Tue, 27 Aug 2024 10:45:16 +0800

The helper str_true_false() was introduced to return "true/false" string
literal.  We can simplify this format by str_true_false.

Link: https://lkml.kernel.org/r/20240827024517.914100-3-lihongbo22@huawei.com
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-tiers.c~mm-make-use-of-str_true_false-helper
+++ a/mm/memory-tiers.c
@@ -921,8 +921,7 @@ bool numa_demotion_enabled = false;
 static ssize_t demotion_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%s\n",
-			  numa_demotion_enabled ? "true" : "false");
+	return sysfs_emit(buf, "%s\n", str_true_false(numa_demotion_enabled));
 }
 
 static ssize_t demotion_enabled_store(struct kobject *kobj,
_

Patches currently in -mm which might be from lihongbo22@huawei.com are

mm-make-use-of-the-helper-macro-list_head.patch

