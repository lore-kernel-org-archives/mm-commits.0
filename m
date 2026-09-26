Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D7749D5AD
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456141; cv=none; b=ECqp5M3bZcWxV3xp2Td+lP8Wecp2jvGsyJE9RBOY7Ob2lX3c2ZaHLja6+BhuOz2AaAuxCNz2ZxUIDpKWIcCeQAbhbbWQzAxEibznmH8olntItRHSTkJ7OJx8HTnPHO+C4XpkgkDklmcxmkKnFBRjQ8N7UaK890wkqTItwEpExHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456141; c=relaxed/simple;
	bh=tG2tw0JGx1gPCnL/bSPPKRrkSNpZPvHwZUNKwG/lr18=;
	h=Date:To:From:Subject:Message-Id; b=Rt2DZR4UFYyAYQh/8rnX6Oi2DE8MyWL8W3XusPDSs0YA6oqLwvaqBBu0or0NYh42HtQUynokxxloxe2aI9c8AYXWz0que7GMeMeM1+TPjxpznE/jowtKTIxhZjlijDhPDcyGZEtud0pB50hh+lRyTaIIZ0xFQwr9fVtYLk9J2+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=COWEPBqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="COWEPBqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990731F000FF;
	Sat, 26 Sep 2026 20:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456139;
	bh=Rvecxr10YSE158IszMESa3HgXfFvEYyouT44PefIw8s=;
	h=Date:To:From:Subject;
	b=COWEPBqk8PYHNGmbtE38uOWW1IAgMdioghlQ6Ga6QKPeuns13CukP36lb7tzRkEZ5
	 BOXa69gj1/MlC2YPiKmDsH76cI+4GPsk8ayn1Dr5oOFf6ZD1ypMBVqJv5nfq1tpeZZ
	 H6DiSyuTriiGU1F08PwId0+d+hZpbcelTsg+jSd8=
Date: Sat, 26 Sep 2026 13:55:39 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,hao.ge@linux.dev,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-avoid-implicit-padding-in-uapi.patch removed from -mm tree
Message-Id: <20260926205539.990731F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: avoid implicit padding in uapi
has been removed from the -mm tree.  Its filename was
     alloc_tag-avoid-implicit-padding-in-uapi.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: alloc_tag: avoid implicit padding in uapi
Date: Tue, 15 Sep 2026 22:23:47 +0200

The implied padding causes a harmless warning when testing the uapi
headers with -Wpadded that could in theory indicate incompatibilities
or data leaks:

./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to alignment boundary with 7 bytes [-Werror=padded]

The code here is fine, but it's better to make the padding explicit and
avoid the warning here.

Link: https://lore.kernel.org/20260916065830.1619425-1-arnd@kernel.org
Link: https://lore.kernel.org/20260915202404.3568029-1-arnd@kernel.org
Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Hao Ge <hao.ge@linux.dev>
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

mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch

