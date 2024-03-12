Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411CC1428E8
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274188; cv=none; b=uiM7TS3GMIvF2EgEclNzKCmoY2INd3DqNO1ENkp1cQTL6FKdCzakfPwoBxXvwEWgbR+iUdMImNmUJ/w/JHA33L0hjBpA/i6TQ/g63+BKZSLTQU08IzL7ud5iaawqsgIRxrO/ZxbWyRfvq3YnlihAuEGK0TVwkm6PQJT8Lg11hRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274188; c=relaxed/simple;
	bh=BxiKId9bFqSJ3Dgoe7r6Bnk17H0Dcgr/Z/BKPrTUGA4=;
	h=Date:To:From:Subject:Message-Id; b=tAjnQTIQquCzWXqpD/7edbc/wWndYRerYUuHU1DBMxHgHUt3T5NKaCgEGqkaub+ojL+qFtLmJVQyP5H40aJiStbG0SXVapv1sz/q26yXbIZ8I9n7fba/OKnMtofYxwnH8g6IosQV3lU6keiW0BIcqxAkLhOT+nsROso5zazMhdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OhzCii8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OhzCii8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0F8C433F1;
	Tue, 12 Mar 2024 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274188;
	bh=BxiKId9bFqSJ3Dgoe7r6Bnk17H0Dcgr/Z/BKPrTUGA4=;
	h=Date:To:From:Subject:From;
	b=OhzCii8ybg4pFx9PVMA03/bKAMLDwlO15ar+K4vThvkWw4y+Z7U6EMhI5hKKyuftg
	 qtLxDotMhZr7yAD72CPbqAE8l3G4XEuBo2EkdMF2JmHDV1E2hp8kL29DyDnEDB4vb/
	 H8I3OIKpmiadAumB9SGS1JhLF1XrZDOgjeJ6ZKTM=
Date: Tue, 12 Mar 2024 13:09:47 -0700
To: mm-commits@vger.kernel.org,flyingpeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] buildid-use-kmap_local_page.patch removed from -mm tree
Message-Id: <20240312200948.0D0F8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buildid: use kmap_local_page()
has been removed from the -mm tree.  Its filename was
     buildid-use-kmap_local_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Hao <flyingpeng@tencent.com>
Subject: buildid: use kmap_local_page()
Date: Wed, 6 Mar 2024 11:48:04 +0800

Use kmap_local_page() instead of kmap_atomic() which has been deprecated.

Link: https://lkml.kernel.org/r/20240306034804.62087-1-flyingpeng@tencent.com
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/buildid.c~buildid-use-kmap_local_page
+++ a/lib/buildid.c
@@ -140,7 +140,7 @@ int build_id_parse(struct vm_area_struct
 		return -EFAULT;	/* page not mapped */
 
 	ret = -EINVAL;
-	page_addr = kmap_atomic(page);
+	page_addr = kmap_local_page(page);
 	ehdr = (Elf32_Ehdr *)page_addr;
 
 	/* compare magic x7f "ELF" */
@@ -156,7 +156,7 @@ int build_id_parse(struct vm_area_struct
 	else if (ehdr->e_ident[EI_CLASS] == ELFCLASS64)
 		ret = get_build_id_64(page_addr, build_id, size);
 out:
-	kunmap_atomic(page_addr);
+	kunmap_local(page_addr);
 	put_page(page);
 	return ret;
 }
_

Patches currently in -mm which might be from flyingpeng@tencent.com are


