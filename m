Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C773FF8B0
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508178; cv=none; b=fIsq2XBg3GmF+7j4PCcHftNTavgB3jZLErZuoVYsVQCzK6xSmBGwPLcxPT1Qh++hCxBETtNooHm3qLIr9MnK5Kt202SF3OtPSRNU9SNhOYurKZQqDh0FbTr3DtlmXpbd763ONZP+fsBHMkaM6s+CFCBafl5R+iBS+EphrPV0iMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508178; c=relaxed/simple;
	bh=W0v8qzEG19SOOdZnU3FTXgguVuP/VC4dN/ym16RFxx8=;
	h=Date:To:From:Subject:Message-Id; b=DY9K6bR7VIQZUHpt8qq1tKweQs7oU1uUifrtYxoyNRH8KLrskfkU8Pc4k+5WaemPTI5E1eF/Ebltql1j9dXI8neQRWP1+T+hK0oGXLchPrx8TKlnrMVihdhVCWco+FKEuvb1CRD4N9AD038ldavdGa8UhYvSlYfOdQ2qf+F2gEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H8e9wZU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H8e9wZU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74AE1F000FF;
	Tue, 15 Sep 2026 21:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789508175;
	bh=0y2b35i+xNJE1gC0n3DoyGYvUDBdWhGnWirGkH3w3HA=;
	h=Date:To:From:Subject;
	b=H8e9wZU9V+kBKo4SrbayaM13ZzkCX8P66SY1NwWRriOT1zEzSRLiUvPIYiFJoPKsN
	 JWfKMwLv+ZhQa7VkziGMXNVhQf2dls+sllJVdkS1XVMGEfkkj3LTl/wMTOXeszdqj1
	 CKGq55UhARzmJZ7f8YlASlgypknQ2PPiiHDc9u9M=
Date: Tue, 15 Sep 2026 14:36:14 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-avoid-implicit-padding-in-uapi.patch added to mm-hotfixes-unstable branch
Message-Id: <20260915213614.E74AE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: avoid implicit padding in uapi
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-avoid-implicit-padding-in-uapi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-avoid-implicit-padding-in-uapi.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: alloc_tag: avoid implicit padding in uapi
Date: Tue, 15 Sep 2026 22:23:47 +0200

The impliied padding causes a harmless warning when testing the uapi
headers with -Wpadded that could in theory indicate incompatibilies or
data leaks:

./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to alignment boundary with 7 bytes [-Werror=padded]

The code here is fine, but it's better to make the padding explicit and
avoid the warning here.

Link: https://lore.kernel.org/20260915202404.3568029-1-arnd@kernel.org
Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 include/uapi/linux/alloc_tag.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-avoid-implicit-padding-in-uapi
+++ a/include/uapi/linux/alloc_tag.h
@@ -38,6 +38,7 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
+	__u8 pad[7];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
_

Patches currently in -mm which might be from arnd@arndb.de are

alloc_tag-avoid-implicit-padding-in-uapi.patch

