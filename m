Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88593B42D1
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785870259; cv=none; b=ZYRxsawP1Hf9k0EFOI600UA/qjmFa0NnHPyz8Bu4+Xzpdz0vgazGU8Vjr912BloitTyEx6gzQZ90H1Tx/1GZObNB6GEf5NyNNgFzgGU145DLc7OG1WDI8pbYpsFmkKQUEYLRYcfcJdE8hrVrPy8awvLZam93rQDljFHtb5UpMak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785870259; c=relaxed/simple;
	bh=T+2QbSAMWxq1nmPk9P4352E9hiE8xcwk4HxOFHn6GwM=;
	h=Date:To:From:Subject:Message-Id; b=pOCvZQF+8gibOywP6F5Bot2XO8R+IWHKNkoYcKmGddB98JpnNkNgYyiygvO67Aap52tcCcmNP7YM8q+CFuJy7mlDphIHaLm6D2iLvLNJ9DElDSvcZ/uygCRXRe1IbXvVKZqrOa4iuW2Tm63WW7VmF7dmbgUaoOxkK2Klola3HEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A2oSeZy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A2oSeZy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C151F000E9;
	Tue,  4 Aug 2026 19:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785870257;
	bh=JM+lWCxT16/d0VtQqnd2KXv6lX5R1tKvfFjA722LEUY=;
	h=Date:To:From:Subject;
	b=A2oSeZy/jQcpsMVSlVyguY7tnMwVKK0MIiN54xtjt3l6nz02MXoNQBliGgdwNtDeR
	 XZGfGk/APnbwEIZZZ3mu0WY+z2cbPoJsgVL7UKx5xKzr70k8apGHVT5Jr12c8uibi7
	 LHiH6hId8tsWctwsYgkaK3JbAufEdrYi8GceJGzo=
Date: Tue, 04 Aug 2026 12:04:16 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch added to mm-unstable branch
Message-Id: <20260804190417.61C151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag-add-accuracy-based-filtering-to-ioctl-fix
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag-add-accuracy-based-filtering-to-ioctl-fix
Date: Tue, 4 Aug 2026 18:24:14 +0000

Move the `inaccurate` filtering criteria from `struct allocinfo_tag` to
`struct allocinfo_filter`.  validate the introduced feature.

Link: https://lore.kernel.org/e4e49ec4a5960292aeeb9e196526c18dc95228a2.1785867739.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/alloc_tag.h |    4 ++--
 mm/alloc_tag.c                 |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-add-accuracy-based-filtering-to-ioctl-fix
+++ a/include/uapi/linux/alloc_tag.h
@@ -31,8 +31,6 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
-	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
-	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -74,6 +72,8 @@ struct allocinfo_filter {
 	struct allocinfo_tag fields;
 	__u64 min_size;
 	__u64 max_size;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 struct allocinfo_get_at {
--- a/mm/alloc_tag.c~alloc_tag-add-accuracy-based-filtering-to-ioctl-fix
+++ a/mm/alloc_tag.c
@@ -291,7 +291,7 @@ static bool matches_filter(struct codeta
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
 		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
-		if (inaccurate != !!(filter->fields.inaccurate))
+		if (inaccurate != !!(filter->inaccurate))
 			return false;
 	}
 
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch
alloc_tag-add-size-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch
kselftest-alloc_tag-extend-the-allocinfo-ioctl-kselftest.patch

