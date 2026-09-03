Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D34FDE67
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458196; cv=none; b=CIQyOTs1cXSe9r38Nv4kP1rC3KwPNYyy2CMyXbmFQK8bcnp246hy1/PsoxOz1U+NvyisNvIdSmCQy8kKTRmTZo96Z0pAIq1upxWGZtz64sKA2s9v/G/WtLeasNcmp++8oDX1x49GJtTyNal4sNUrt+4MF/qUdEzz+zhxFgZtjhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458196; c=relaxed/simple;
	bh=S6RaoIw4Jn/eu+wr5K+EKB7SKTXvIE9GVF1pumPUd9w=;
	h=Date:To:From:Subject:Message-Id; b=hlEtNagCIoixeNzcCRWTjO5GTHohjkR86FLp0JRbszOljXJGQQTRitMcqgePWFB/UZ0SlZdcQxPbEWVySlBOkD3I/Yy2ztsd1Yl9Yuvt0K7ao+h4US0uWzIxSJE99cnFRZsfaLhAobuJ1ENYFkxS8JvZVldWrA2Br673mOIvbw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I/ZiQnqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I/ZiQnqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844331F00A3D;
	Thu,  3 Sep 2026 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788458194;
	bh=KYc19l9EU8hEoOTSe35cvo+OmnQePpbo+p5bc1/RpmU=;
	h=Date:To:From:Subject;
	b=I/ZiQnqJ0vqqZowrxY5lrVGNfwIvEXKzc8GSNIHBdh2slrXxYdMfyKnvqc08o0nlE
	 KYRIW5F8O6yWGrxF3m7PekxwSM4kRCTgU43MRz7puUw7sDMaV3s2AG6cxV0vn4zc9S
	 9Lzkf7hB4dfCEsAPdKwos10oHr3EQRAHZUyTEDGU=
Date: Thu, 03 Sep 2026 10:56:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,sj@kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-a-thp-reviewer.patch removed from -mm tree
Message-Id: <20260903175634.844331F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Kiryl as a THP reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-thp-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: MAINTAINERS: add Kiryl as a THP reviewer
Date: Thu, 27 Aug 2026 11:34:35 +0100

I have been working on transparent hugepages since 2012, starting with the
huge zero page and file-backed THP.  A lot of the code that causes pain
now traces back to me.  It is only fair if I share the review load for
THP.

Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
well.  It is also my commitment to be more active in reviewing this code.

Link: https://lore.kernel.org/20260827103435.1371882-1-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: SJ Park <sj@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -17421,6 +17421,7 @@ R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
 R:	Lance Yang <lance.yang@linux.dev>
 R:	Usama Arif <usama.arif@linux.dev>
+R:	Kiryl Shutsemau <kas@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch

