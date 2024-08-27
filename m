Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07C11D47AD
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802157; cv=none; b=H+E8f/FmGvJNGPLCMEkzT216g1nxQl1cv5m2m38PEJ0YkPwUst6ypMEwAg0LiR9X4Zc5NGOYMwGxp5r5NaCIGOWKZSTDkS3ilAAsHTMjZOHi4TCosrcoa2wOSRh3qb8JpldVSxG4eEL9J21i5NkbgiVtQPZX3KDancyCd+9CuXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802157; c=relaxed/simple;
	bh=pJ7AVI9e+WEEWDp3ec5VIFGlabp91cyZ3pFQSl837I0=;
	h=Date:To:From:Subject:Message-Id; b=ov9pQu/05i4GPMoxWVgQcE/UrBQPWwVEobUZYb9r8qv3jRIgfqAdo5sOQQGi9DUVzFtutOhGbwiPG/zu0QpnSKYUj6XuXdXfx3NRfVIafa9O5Umh4wQDXddvNzWvT4slBUGtqoYzcvRlWNuSui/ZlOaVyok8SrGj/FU7wufCZUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MkrvcMyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MkrvcMyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78481C4AF0E;
	Tue, 27 Aug 2024 23:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802156;
	bh=pJ7AVI9e+WEEWDp3ec5VIFGlabp91cyZ3pFQSl837I0=;
	h=Date:To:From:Subject:From;
	b=MkrvcMyd8jnp23RmaOOtzIiHzc+Q+pSpNOlkxF5eT8H9osxEABT7yK5Ec77ZDaBRj
	 zvFyrYCzETyTEdlapl+5ZvKO/2K12zutL6hGAVRWiguyY3iwE22nuQRo0BNlOfjVC2
	 9JNANI1ZG42AykpZTJs92iPLFWsd1LbemsP8w8Wo=
Date: Tue, 27 Aug 2024 16:42:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,trondmy@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,anna@kernel.org,andy@kernel.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-use-of-str_true_false-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20240827234236.78481C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make use of str_true_false helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-make-use-of-str_true_false-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-use-of-str_true_false-helper.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
@@ -939,8 +939,7 @@ bool numa_demotion_enabled = false;
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

lib-string_choices-add-str_true_false-str_false_true-helper.patch
mm-make-use-of-str_true_false-helper.patch
nfs-make-use-of-str_false_true-helper.patch

