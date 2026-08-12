Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4D525771
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505213; cv=none; b=Gog+XPrfMYq9fYKfKTYB3cXgOvYGX4K8JR/PNRuH4fpSCy7N6rizReW7l7RfuXFGFkkJEvmXoH6WeH10opRLl/tGS7CQ5tff6n2QkB+CMKBU2Tsio0pJ1wzAkSJKzKy3i6CRc3xFQ3osG3WPaRoedKmJtw0UDjmhvlPiWiPPS5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505213; c=relaxed/simple;
	bh=5ySjSu5oSOTe4ZjGakkhJ6ZUZqTkZ6v7gFNt0ihuQHI=;
	h=Date:To:From:Subject:Message-Id; b=HYbMIYjZXI/PxJkncIgywH1fVvH1TeaH/1NTtBjGerfPPmEBqaU3ceayOsEjmY4XLgtknpMZbkeZQdqZRh9o7Uvcg/jmeafbstnZ/gU/pd653lrfOW+4VPa0LUhW12TxX9aAMEDxdoPWAPjaUwYs5n1R+rJ1Am0Ybr2Sq6sHcZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rse0imTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rse0imTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3501F000E9;
	Wed, 12 Aug 2026 03:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786505211;
	bh=sY7eFkpX9EKXOpnMoqcX4T5F6OwTgT1+ggHMRdWGbXk=;
	h=Date:To:From:Subject;
	b=Rse0imTrrafmgVRxVIYTroq9wWIlJIXdeuf4agp5j/DKrzYlLbAduSZmmafU0N6Ky
	 F2zLbhLsM7vEEwPvCB3W5CqsGc7eoldbcysq5nUsqcoOOtfqoaA9I97VZwTHFcH0cn
	 MGjzGl9/YZ/T3Ou79wkasJMQSaFYl6thC7xfuz4w=
Date: Tue, 11 Aug 2026 20:26:51 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch removed from -mm tree
Message-Id: <20260812032651.BF3501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag-add-accuracy-based-filtering-to-ioctl-fix
has been removed from the -mm tree.  Its filename was
     alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch

This patch was dropped because it was folded into alloc_tag-add-accuracy-based-filtering-to-ioctl.patch

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

alloc_tag-expose-boot-time-compression-configuration.patch
alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch
alloc_tag-add-size-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch
kselftest-alloc_tag-extend-the-allocinfo-ioctl-kselftest.patch

