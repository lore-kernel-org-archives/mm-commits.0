Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5CD1292D7
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 20:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709671657; cv=none; b=VR7i4/AsztwbmQVfmkdEKBLE2DEkwWnAENmHPp3hjMkZY5vABpoLppNN6v4Mo7QBOnjRqj1m3jfrLNkNJNcsMgEqTy1zNpn8MawDXOs31RUx0UIMDOfs4mGKdrPXUUImhWn1aHD+Sq9oz8GfHfzPAyb+X+tFYRoMXtI3widwWes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709671657; c=relaxed/simple;
	bh=Xv/Xz1LEY5tFisxK8oxoPgB/FRbng0EOhGAX9KValFw=;
	h=Date:To:From:Subject:Message-Id; b=uuINRsSkjzgc9Gj9uMJLQ3fMVXQe+WPqL8Rxg8jbBH4DnZKCMpjoe/Ij013V0xv6PTpyPwFvxGjD86L0Odf2noIr98m6ByHMbY+Ao3HygWK2nF5czpfiOM4kdvOU65kPtTivnlOffEEkqboRfuiAYSdS1/AWnsWSu616dQGA5fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ysPBszrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ysPBszrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214DDC43390;
	Tue,  5 Mar 2024 20:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709671657;
	bh=Xv/Xz1LEY5tFisxK8oxoPgB/FRbng0EOhGAX9KValFw=;
	h=Date:To:From:Subject:From;
	b=ysPBszrdVP1c8jNSBoQetavdKn60mrSpV8ogE4r4P/xklu4Q+OusRBP9Ae2hQgQf8
	 kKdxojXHLckqAa18PDGUMw26X9d9pdT4YXq7VNKcUITDLiVDvwT47ovYgUdApDV810
	 I8ULYqn+2jA8SXUi0H6p7wNvH0vWD+187Mr1R2zY=
Date: Tue, 05 Mar 2024 12:47:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,broonie@kernel.org,ardb@kernel.org,aishwarya.tcv@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-__dump_folio-fix-3-fix.patch removed from -mm tree
Message-Id: <20240305204737.214DDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-__dump_folio-fix-3-fix
has been removed from the -mm tree.  Its filename was
     mm-add-__dump_folio-fix-3-fix.patch

This patch was dropped because it was folded into mm-add-__dump_folio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-__dump_folio-fix-3-fix
Date: Mon Mar  4 11:15:25 AM PST 2024

s/printk/pr_warn/

Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-add-__dump_folio-fix-3-fix
+++ a/mm/debug.c
@@ -139,7 +139,7 @@ again:
 	if (idx > nr_pages) {
 		if (loops-- > 0)
 			goto again;
-		printk("page does not match folio\n");
+		pr_warn("page does not match folio\n");
 		precise.compound_head &= ~1UL;
 		foliop = (struct folio *)&precise;
 		idx = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-__dump_folio.patch

