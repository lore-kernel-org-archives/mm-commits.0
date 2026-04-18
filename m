Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013DF36E476
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498973; cv=none; b=Jk8RuW5l+av/ZvpyVN2easTURpweKixz+zY8cqRJ3RnKiqWqMlhFXFHLELI7AAA2HnadCxIzpgTM/JYekdA9dJZC/FMD7qK1HW9WKtTrfj0n+N5m1npXymUGsdtaEQl5WavJQxJc50oRf4k5w+Xyxw+fbwwTE6RRql0GRNlN85w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498973; c=relaxed/simple;
	bh=rGtT6OwGnhBIDT49bNcihKuRQ+35WcGy5KzUKyTx9S4=;
	h=Date:To:From:Subject:Message-Id; b=pyKUDzxuDOi5RIp2Fcknz3kjnxmNR7q9ObfQUKDrSOl24x99QJn/xpkF/tHaxCeMrDKBjsdQCrB7IF59+ba7QbMkZJ/3wJN7DXKHfTJTuZxopKQNVeIRyK0KY++eacACn30L3OlMtIVP+My8xZM6RcdxbX3lFRGmIpVCHVqtBfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=it9O9l80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="it9O9l80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D4DC19424;
	Sat, 18 Apr 2026 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498972;
	bh=rGtT6OwGnhBIDT49bNcihKuRQ+35WcGy5KzUKyTx9S4=;
	h=Date:To:From:Subject:From;
	b=it9O9l80+ANesKrIMVDnLTHVbrdS+ATYpqAsqS+Hj1QWyR5C58N8p5AJfqHTuZbrt
	 6FwMEyjGK+bn5KWBVVnMCVXOerK9LnqUoIO1hyl/jC3i7WS1QK3kKYLI7yYKHJMeQu
	 Hv21hvT1XSNKfv+sUZ61S33/XG6bP0Ye9xFIeyuw=
Date: Sat, 18 Apr 2026 00:56:08 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch removed from -mm tree
Message-Id: <20260418075612.52D4DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd_luo: remove unnecessary memset in zero-size memfd path
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: remove unnecessary memset in zero-size memfd path
Date: Thu, 26 Mar 2026 16:47:23 +0800

The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
file handling path is unnecessary because the allocation of the ser
structure already uses the __GFP_ZERO flag, ensuring the memory is already
zero-initialized.

Link: https://lore.kernel.org/20260326084727.118437-4-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path
+++ a/mm/memfd_luo.c
@@ -105,7 +105,6 @@ static int memfd_luo_preserve_folios(str
 	if (!size) {
 		*nr_foliosp = 0;
 		*out_folios_ser = NULL;
-		memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
 		return 0;
 	}
 
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are


