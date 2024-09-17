Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5040F130E27
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560296; cv=none; b=jBxMk1tW6rP/Sv/Y0H3qA08M89QCFhcmnvpK/how1E5RWv1NdOvtJZL6z3f3zzeSnQjq5kCiqI7aOkjyJBblH+ZERUbiNsDzfB5hH+5fAz8BdhRCIC8u9p3+IGXRkhVhZWAn/RD7zq4iQuGBV4AjqEBFw9J393e88mg2tegTJAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560296; c=relaxed/simple;
	bh=exEwIxB7lk/Ge2R0d91u2QuYlp1bkDprkvRa5g8TuVs=;
	h=Date:To:From:Subject:Message-Id; b=svszZVOVd2chL9YQiEwpQNfgS4Vk5ixanZyR78MaHgYpi6kURq9wdOkwjA8Rbmc9S6JhPsY6vyruJRcYPPFnWlGnkaJUsr+ncTrzIn06VlgZqjoIFWnB0Ob0dg0JcYTeJwK/tD3wjZj++fdm6hUDVsDl2hZPvJUuk0MreGLwy/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OiN8j2Kl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OiN8j2Kl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738E4C4CEC6;
	Tue, 17 Sep 2024 08:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560295;
	bh=exEwIxB7lk/Ge2R0d91u2QuYlp1bkDprkvRa5g8TuVs=;
	h=Date:To:From:Subject:From;
	b=OiN8j2KlVfnLF9w036prAJx+VEx/n9TwjWSp7UHomJtHhVrHUV45Np5RV3B7PwfoU
	 ztgMhmh3QNIHrplsojzfGtp7E4r4K/2GKA9/4tORlA/3f97cDefbKpSB1zDZZhbEDL
	 G/6xgnGuhfcEYbgzbOIh9wtV1h+4brM2+vNDN9bk=
Date: Tue, 17 Sep 2024 01:04:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,ice_yangxiao@163.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch removed from -mm tree
Message-Id: <20240917080455.738E4C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

This patch was dropped because it was folded into mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix
Date: Mon Sep  9 12:04:14 PM PDT 2024

fix whitespace, per Liam

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Xiao Yang <ice_yangxiao@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix
+++ a/mm/vma.c
@@ -1260,7 +1260,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 			 * split, despite we could. This is unlikely enough
 			 * failure that it's not worth optimizing it for.
 			 */
-			error = userfaultfd_unmap_prep(next, vms->start, vms->end, vms->uf);
+			error = userfaultfd_unmap_prep(next, vms->start,
+						       vms->end, vms->uf);
 			if (error)
 				goto userfaultfd_error;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas.patch

