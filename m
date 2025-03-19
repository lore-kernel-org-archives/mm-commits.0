Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714BE2AEE2
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 04:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742357227; cv=none; b=OdJhDo9/zzXeWJdaOjMdaotssMshyeuZ7BZKXE48L88ofLtKr5/kz9uIN76q/GKzuhD7iTc9O84bnA+8ew7DPXJybBlSdM3ju/yKzkAqWDpPLsGERs2GdJ/MoBArNCPdGwra96mEsSJTQdHZpYLR+vAwlShqr6AoapvpM1c7pFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742357227; c=relaxed/simple;
	bh=SYDNeYum5vx95z41BfMwgTprFtqdzEorZpxuhgTXKfY=;
	h=Date:To:From:Subject:Message-Id; b=lVxABBt9AqnS4YIRpHw52WVTA0jq0wuN+3ccFP95SFQqg/+mC67RUs8UGVyHP7dLX7edBX5fHu4Ywkcc+lDNF7M158/59xlxul2PaegBajU1wlesRpFopJB4ebKm2/d8+PiN0cEPtPQa4E6wliZlMQQanCavB/620/agXFnS3Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0nxTU4Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0nxTU4Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA1BC4CEEC;
	Wed, 19 Mar 2025 04:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742357226;
	bh=SYDNeYum5vx95z41BfMwgTprFtqdzEorZpxuhgTXKfY=;
	h=Date:To:From:Subject:From;
	b=0nxTU4GdhJynKkMX5BjdKW3XaLXm94Qy3n/XbJgBgkAfGzTBTU0+OrOEQLLGtyXKz
	 e16o/P6xfwvgDXblOChMIuy/Gj9ZocNj1n5UZvkVVBIFKUaS3thnq+L0kGCK20Kl8+
	 dgwdmMY/fwwpotwjQKvELx5+QBJIB8ssdRd2aQ/o=
Date: Tue, 18 Mar 2025 21:07:06 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + relay-use-kasprintf-instead-of-fixed-buffer-formatting.patch added to mm-nonmm-unstable branch
Message-Id: <20250319040706.CCA1BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: relay: use kasprintf() instead of fixed buffer formatting
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relay-use-kasprintf-instead-of-fixed-buffer-formatting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relay-use-kasprintf-instead-of-fixed-buffer-formatting.patch

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

resource-split-define_res_named_desc-out-of-define_res_named.patch
resource-replace-open-coded-variant-of-define_res_named_desc.patch
resource-replace-open-coded-variants-of-define_res__named.patch
resource-replace-open-coded-variant-of-define_res.patch
relay-use-kasprintf-instead-of-fixed-buffer-formatting.patch

