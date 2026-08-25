Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA669370D5A
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622901; cv=none; b=tDgyxiajVEIGH6wFhhaNbjqLbTEPBEuMbkpveh8O1Iduo8bpIQo/vpc/SM7PWiSVs+JvSX3+Mus7iB7mb3fAFDBzVxWgZqZ+UrxTizy4d16Ct7s3TwjFVCK9Z26Jr6zPesFl4czhnTLOOspur1+SDCjLEXP1yu3PdZhALc7+Gug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622901; c=relaxed/simple;
	bh=kZGfgpHTfOv9zBZlVVeAhMeLx1MuXi4gckHDQ4SS9Ec=;
	h=Date:To:From:Subject:Message-Id; b=ZnKjQEsmNYbtg94mim4PbiaqopPz8R5dsFeFiMPDe93+YJl9Uyl0yCwrdToFBIIv1VzsIhTUldis18dEhiIIA7AZIK9T8dZtisjQE5Z4TVaICsRvJmiHFDh7VzPkSplVPhzmb7Or+cVPXeq11uSwganMyxV3uY/uudz/2LyHJvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/nhLxEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/nhLxEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1096F1F00A3D;
	Tue, 25 Aug 2026 01:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622899;
	bh=/J6D/szNjUFiaRFUpmgMDmc3HmqOUKzAHpSeni0HLyA=;
	h=Date:To:From:Subject;
	b=a/nhLxEtQhEWsNDbccztiy4hkCCKfh0XNSUhw4qI4pDZCXTbR7Gq+GkpCFPZDQBkk
	 Pd4VMV19MB6EKL3dIRC37gc0oFteHrv61JSVAzRlAUWtIN8HAg8y0tPO0Govcuhznr
	 PTMVR/FhuYoEt4f0qRs/ZF1/maQoM3KJw+QitCfw=
Date: Mon, 24 Aug 2026 18:54:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch removed from -mm tree
Message-Id: <20260825015459.1096F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: remove stray newline from auto-generated CMA area name
has been removed from the -mm tree.  Its filename was
     mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/cma: remove stray newline from auto-generated CMA area name
Date: Mon, 10 Aug 2026 17:32:15 +0800

When no name is supplied, cma_new_area() generates names with format
"cma%d\n", introducing an unintended newline character ('\n') in the CMA
name.

Most CMA regions are created with explicit names, so this path is seldom
hit.  The newline only creates cosmetic noise in debug logs, traces and
debugfs with no functional impact.

Link: https://lore.kernel.org/20260810093215.91419-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-remove-stray-newline-from-auto-generated-cma-area-name
+++ a/mm/cma.c
@@ -242,7 +242,7 @@ static int __init cma_new_area(const cha
 	if (name)
 		strscpy(cma->name, name);
 	else
-		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
 
 	cma->available_count = cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

