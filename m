Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D91279DB6
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421692; cv=none; b=nIMCtL3TJi//ndDYIuVUV0cUnogaTlF2kxbkH4cepqjkruXmnzBqpBlfras2cnAPa65VWdaDZkkxPiRuCVDT8ZfMyAC/wrG5dQQ/A/j1MKUXsmZbdP+JzXiRfSrKeEJj0MUq5N4suI+0XwMoJCdB5DHDcgNExqUf2UZDZtU7NbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421692; c=relaxed/simple;
	bh=sqXt+D3+6VxAUtrNCYlQ+Q4hZea3pX4MeRTV5m7AnG8=;
	h=Date:To:From:Subject:Message-Id; b=nTNJSGdQr2g10Y5sAzSbx33TlcyI/IWBlVBtxfwERt98lfvtj/kA4VKh8e7VUJr/3TkbfBH0J5PHbu5Bc0xYYRsuELSOfGFbnS1qyRYBCXPaodnwBtEXVMge+/5wDPg2hwbEJ9Sw9gb4PYlruneTZvCG5EEG2kdkWPdFy2adqfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bq9AHze6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bq9AHze6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EE2C116C6;
	Fri,  6 Feb 2026 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421692;
	bh=sqXt+D3+6VxAUtrNCYlQ+Q4hZea3pX4MeRTV5m7AnG8=;
	h=Date:To:From:Subject:From;
	b=bq9AHze6jMjMqOdmv7rVpDMPHz9SdwT7SCnuYbWfibpQnUKpY8iGROGeY00abZIhF
	 CT1I9jiaIJfnfcwGzUwbek73ZcqSiOVbdIhskbPXkt7b54UyL8cf+QhMFtHpdbU05M
	 Dl/UyFOBl4aaLMCW5iG34hMc9P55eNlapksVYDvE=
Date: Fri, 06 Feb 2026 15:48:11 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,sj@kernel.org,nphamcs@gmail.com,david@kernel.org,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-%pe-to-print-error-pointers.patch removed from -mm tree
Message-Id: <20260206234812.52EE2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: use %pe to print error pointers
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-%pe-to-print-error-pointers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/zswap: use %pe to print error pointers
Date: Thu, 5 Feb 2026 00:24:08 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Link: https://lkml.kernel.org/r/581a26f22fb4c6ce04aeb7ee0d703fe64454ac7f.1770230135.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-%pe-to-print-error-pointers
+++ a/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsign
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are


