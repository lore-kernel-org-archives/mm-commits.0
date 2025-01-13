Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F5D25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742231; cv=none; b=hws+DZMvYFngX4WrDbvPQZRB5w6stcru8wDwmjqrAE1VL5LFFU4z+ejD6R6NsTCoFHsjrhuM1xApvB9zX/cucb2DkOTZA1fKEtLKQhtlpwERiNzxooYvX8E+ieNRSF02YENpbttGVgBAv0s1s+ZH2n2T4B2dYpnvB2E2mnuT6VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742231; c=relaxed/simple;
	bh=y5/aOp8Qa8ZxlrSlHq+iHksKeMB/qYoaNYPC6KdyrxE=;
	h=Date:To:From:Subject:Message-Id; b=VFhLQKgyFDGyQ/bxpfN61dZbsy7O1M2nY2D5XTrRY7nWyGytM6OhLlq9MqZRSNGCMxw5Ig5Jecs4epADEcGTM7p2/eF6D1oWosTjAnJdK7hRWUKLb3opQbvvbS6w+wojNLVM9eJL8CZ/6RRWk/fWgfBrYLrGZglBSnvWspHZ4n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YzkiDYCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YzkiDYCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41691C4CED6;
	Mon, 13 Jan 2025 04:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742231;
	bh=y5/aOp8Qa8ZxlrSlHq+iHksKeMB/qYoaNYPC6KdyrxE=;
	h=Date:To:From:Subject:From;
	b=YzkiDYCj/1ylRDjE6KlbCTI+osKPsn6e1P66MZibtBdBC33pkdAgabEbxkPMfZFwu
	 CmsvUZhmH938tVUoPq8GxS7cBIOoHog2NRNhRLJ+ppcyCA6UDkbgplUrOAMDMnDP6K
	 5Z4Ai7adm48PqNL7yBQB0thzYHGsmESBUsU7emNg=
Date: Sun, 12 Jan 2025 20:23:50 -0800
To: mm-commits@vger.kernel.org,joel.granados@kernel.org,hch@lst.de,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-fix-removal-warning-for-deprecated-initrd-loading.patch removed from -mm tree
Message-Id: <20250113042351.41691C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: fix removal warning for deprecated initrd loading
has been removed from the -mm tree.  Its filename was
     init-fix-removal-warning-for-deprecated-initrd-loading.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: init: fix removal warning for deprecated initrd loading
Date: Wed, 18 Dec 2024 12:36:38 +0000

This won't be removed in 2021, no matter how hard we try.

Link: https://lkml.kernel.org/r/20241218123638.34907-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_initrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts_initrd.c~init-fix-removal-warning-for-deprecated-initrd-loading
+++ a/init/do_mounts_initrd.c
@@ -89,7 +89,7 @@ static void __init handle_initrd(char *r
 	extern char *envp_init[];
 	int error;
 
-	pr_warn("using deprecated initrd support, will be removed in 2021.\n");
+	pr_warn("using deprecated initrd support, will be removed soon.\n");
 
 	real_root_dev = new_encode_dev(ROOT_DEV);
 	create_dev("/dev/root.old", Root_RAM0);
_

Patches currently in -mm which might be from martink@posteo.de are


