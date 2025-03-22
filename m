Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD17B7081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620253; cv=none; b=BIKDy/eYHAkBJSVTkLbstIfSRWj6OE6qoV33xA3D40Z7RlIlI7lPyOmxyQBc7Lxx/KcjVlvSjHnLupb1sRRsA2P3FN/Ilp/D/ZGlWiweJgPJhiVOf7l5C6RyMbiTLNFb/aIG8UPKyabNNCA4lRhSpNSfP+990AWAbghQNdkmxn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620253; c=relaxed/simple;
	bh=Na9evFmTqA5m3DeXBR1E7G6vUh03MGrNq/EkMari+g0=;
	h=Date:To:From:Subject:Message-Id; b=hR2AX6itzoVwf7XGSbrodjjJ+tf+yy2P907sbb243o6fUAKhtRfAfq/Xjx+aPkpIK/hUPf2oQkn7Ah1Zqy8n5rpz1ySsWpktgP4KYSTrHbn8Oe9XVq8UkUxWm6bZb4X8m4FQQMVIsTz0mgc0WkayDZk+ny85k5ZMkRgXHygD5NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=COJ9r7uA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="COJ9r7uA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3227EC4CEE7;
	Sat, 22 Mar 2025 05:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620253;
	bh=Na9evFmTqA5m3DeXBR1E7G6vUh03MGrNq/EkMari+g0=;
	h=Date:To:From:Subject:From;
	b=COJ9r7uAdB4OvYInmEoRb5UPdNMwoRyX85VW5BxGPuGMCeM58z6acXOTftzsp0ikY
	 lHjJG29fpyJnyVm+RtVaE+aBMDcLswt8MncCYft4FPEeg75wzdJ2g+MTM5r8PY2uyO
	 SkFYRH31MGoZ1Os2n6uNS391iZY40+5LJQMmw3Qs=
Date: Fri, 21 Mar 2025 22:10:52 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relay-use-kasprintf-instead-of-fixed-buffer-formatting.patch removed from -mm tree
Message-Id: <20250322051053.3227EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: relay: use kasprintf() instead of fixed buffer formatting
has been removed from the -mm tree.  Its filename was
     relay-use-kasprintf-instead-of-fixed-buffer-formatting.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: relay: use kasprintf() instead of fixed buffer formatting
Date: Mon, 17 Mar 2025 23:29:47 +0200

Improve readability and maintainability by replacing a hard coded string
allocation and formatting by using the kasprintf() helper.

It also eliminates the GCC compiler warning (with CONFIG_WERROR=y, which
is default, it becomes an error:

kernel/relay.c:357:42: error: `snprintf' output may be truncated before the last format character [-Werror=format-truncation=]

Link: https://lkml.kernel.org/r/20250317212948.1811176-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/relay.c~relay-use-kasprintf-instead-of-fixed-buffer-formatting
+++ a/kernel/relay.c
@@ -351,10 +351,9 @@ static struct dentry *relay_create_buf_f
 	struct dentry *dentry;
 	char *tmpname;
 
-	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+	tmpname = kasprintf(GFP_KERNEL, "%s%d", chan->base_filename, cpu);
 	if (!tmpname)
 		return NULL;
-	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
 
 	/* Create file in fs */
 	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


