Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81F43EBF1D;
	Sun,  1 Feb 2026 00:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905018; cv=none; b=uQCu2htLCU45pai5St3KWJbDnR005jCEmbpzMiWp4dxXGnDCMH+gNuDGJYExnIDZ4tnSZq/U6w3v5nV6vx8dnoqMtRNaobLbGyG6kLRnRXa8QCxRiOED0hEmb9Jr1Vqbk9yNGff2EBdHbe5pZ0bY3a35NxeCwA8m9Wwiaguo3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905018; c=relaxed/simple;
	bh=6RctTLQPf4+7ZsKzFgIFE++ROKMSz2MHCHxRh3Q0AGU=;
	h=Date:To:From:Subject:Message-Id; b=cfrtFDL3fec283xKmZz43p9IfYG/1RGPJMdVH96iSCLQ84CGEz6MR5IlrhFTVzDOdwRLVqRL/2bl7gDeV4+eB9Hs90pYwymDVIo3XZFnsII8Mgide1HqpV6/1xxhUl1u324YCtJ2kEAzeWFYFiLYXVW6DC6eoNr4d5WzSl7mwL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jKjVjSeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jKjVjSeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AC3C4CEF1;
	Sun,  1 Feb 2026 00:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905018;
	bh=6RctTLQPf4+7ZsKzFgIFE++ROKMSz2MHCHxRh3Q0AGU=;
	h=Date:To:From:Subject:From;
	b=jKjVjSeZQfFKUGRzuC5MinfU6k5+sbEhaNKXl03W4MRaOitN+1eVZyGlvk0fqq1CP
	 9gcQXGcF7Sw6LpIYwTV+K6Tk/0e3UxyrfTcxobbam5d39Wbptd7BsPiqTV7fam2akq
	 mrslyi+V5BRgkqV/f5TbU2ptA49mw9bD/exMZcWo=
Date: Sat, 31 Jan 2026 16:16:58 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,alex.bou9@gmail.com,akpm@linux-foundation.org,lihaoxiang@isrc.iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net-v2.patch removed from -mm tree
Message-Id: <20260201001658.86AC3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
has been removed from the -mm tree.  Its filename was
     rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net-v2.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
Date: Wed, 21 Jan 2026 09:35:08 +0800

When idtab allocation fails, net is not registered with rio_add_net() yet,
so kfree(net) is sufficient to release the memory.  Set mport->net to NULL
to avoid dangling pointer.

Link: https://lkml.kernel.org/r/20260121013508.195836-1-lihaoxiang@isrc.iscas.ac.cn
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c~rapidio-replace-rio_free_net-with-kfree-in-rio_scan_alloc_net-v2
+++ a/drivers/rapidio/rio-scan.c
@@ -854,7 +854,8 @@ static struct rio_net *rio_scan_alloc_ne
 
 		if (idtab == NULL) {
 			pr_err("RIO: failed to allocate destID table\n");
-			rio_free_net(net);
+			kfree(net);
+			mport->net = NULL;
 			net = NULL;
 		} else {
 			net->enum_data = idtab;
_

Patches currently in -mm which might be from lihaoxiang@isrc.iscas.ac.cn are


