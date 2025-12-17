Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7661A76DE;
	Wed, 17 Dec 2025 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765996365; cv=none; b=mNsbduZ8xaib70oOk7O5RR4DdEwOXgXubKTV6nVJ0g2A3JsG9Tu0aFVF4IK/EmS5CA9DSwYhnHcDR6fkveuSJ2gnHzBAyQE7Jl5gcDR2BYvutdknRskAFlS9/3oCGu4U26YEsOs6Ej/kfGPvkGemScuNJYHAyDXvbrN7W31SuYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765996365; c=relaxed/simple;
	bh=DBOCxvpRAugNtGDqaNARADpWtkkdXADRu5joS2yyOHo=;
	h=Date:To:From:Subject:Message-Id; b=cqRAC4EkLvH/RtRzWRCWUvXgY1qqEjHksxxfvSb/meJlPvTevp8Us7P0hBIvSxPnZfZfjC+oXCaof7QmfosISBUxFUMOHD1Zu9cwlxGBc5GgOFFQ/R2H/yP+KKEq0VR0ZbeAxgcmrP/woNB+P4+5Loiq1WohS3Z53j62A3uk2VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wjRMzpsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wjRMzpsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BC8C4CEF5;
	Wed, 17 Dec 2025 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765996365;
	bh=DBOCxvpRAugNtGDqaNARADpWtkkdXADRu5joS2yyOHo=;
	h=Date:To:From:Subject:From;
	b=wjRMzpsEZtqkcHHjtjF2oucJ4gXNYbLWF7L6qmiXgM1pn+QsnzRONQLXyrb260ADF
	 NYlpcsJM6SfgV9d+FKqikPbLmiBNAPoLu3DKVaGiAK0xrQuT4XlfLiVh6TNdC0VCb9
	 CspE6o2yYCn1pwCjsBrmszT30qHwucSRnM13+2Iw=
Date: Wed, 17 Dec 2025 10:32:44 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,alex.bou9@gmail.com,lihaoxiang@isrc.iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net.patch added to mm-nonmm-unstable branch
Message-Id: <20251217183245.21BC8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
Date: Wed, 17 Dec 2025 17:15:48 +0800

When idtab allocation fails, net is not registered with rio_add_net() yet,
so kfree(net) is sufficient to release the memory.

Link: https://lkml.kernel.org/r/20251217091548.482358-1-lihaoxiang@isrc.iscas.ac.cn
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c~rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net
+++ a/drivers/rapidio/rio-scan.c
@@ -854,7 +854,7 @@ static struct rio_net *rio_scan_alloc_ne
 
 		if (idtab == NULL) {
 			pr_err("RIO: failed to allocate destID table\n");
-			rio_free_net(net);
+			kfree(net);
 			net = NULL;
 		} else {
 			net->enum_data = idtab;
_

Patches currently in -mm which might be from lihaoxiang@isrc.iscas.ac.cn are

rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net.patch

