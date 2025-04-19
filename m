Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53821DDA1B
	for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 21:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745099694; cv=none; b=qxUINSNaDifaEOBRHFJxvB9ZZEifH9y0+ABNExbU7xENZkwCHBy52usg5W38eqj3kvpd8NqCKYy1pl0RXse+ZcAUH7KP3GDJ/a6h25ecxwJUO/tUYn3Q6ikndjkmSMpy1IlOOvo78iKcjyQ8v4Ur7JmOnZjANH9QaGrjkl2iXRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745099694; c=relaxed/simple;
	bh=p3fC4ak8cRBuTBF8+w93e2QRGoae5Sx4Rh+lD21wKzo=;
	h=Date:To:From:Subject:Message-Id; b=gyIsam+Nly5DKdEmMr12gvfen/mljbgUfWb8UrTDb1p2hl1dVOL9LI5yAufdm5kfEKEeRW/XtnTuHNQJXUa+9r9qxBOjpw7PPxpdX+iK4GYpj/XukwtHuyNE1VWAR/ziY07bWtqyuCv+/XLKECOzvY13lFcg3wpXSymc/kfJx0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yx/kTT1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yx/kTT1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEFDC4CEE7;
	Sat, 19 Apr 2025 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745099694;
	bh=p3fC4ak8cRBuTBF8+w93e2QRGoae5Sx4Rh+lD21wKzo=;
	h=Date:To:From:Subject:From;
	b=Yx/kTT1WcLlHDelmBhO35ZXOzWJ7G8u4C0HzfMgRqe/Fo3AGvh3MY3mZDr9dbIgWf
	 8WyyYCOKphO0XZCDYJmTMblJ70CzCNVCY09xANwLtNOd55rvOtOU9mjAg/hZm4v3J7
	 Oe7Susxu13L7MzYE4FNQYkqp2PPK+hIgByigeVPc=
Date: Sat, 19 Apr 2025 14:54:53 -0700
To: mm-commits@vger.kernel.org,mporter@kernel.crashing.org,alex.bou9@gmail.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-remove-some-dead-defines.patch added to mm-nonmm-unstable branch
Message-Id: <20250419215454.4DEFDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: remove some dead defines
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-remove-some-dead-defines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-remove-some-dead-defines.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: rapidio: remove some dead defines
Date: Sat, 19 Apr 2025 21:30:11 +0100

Patch series "rapidio deadcoding".

A couple of rapidio deadcoding patches.  The first of these is a repost
and was originally posted almost a year ago
https://lore.kernel.org/all/20240528002515.211366-1-linux@treblig.org/ but
got no answer.  Other than being rebased and a typo fixed, it's not
changed.


This patch (of 2):

'mport_dma_buf', 'rio_mport_dma_map' and 'MPORT_MAX_DMA_BUFS' were added
in the original commit e8de370188d0 ("rapidio: add mport char device
driver") but never used.

'rio_cm_work' was unused since the original commit b6e8d4aa1110 ("rapidio:
add RapidIO channelized messaging driver") but never used.

Remove them.

Link: https://lkml.kernel.org/r/20250419203012.429787-1-linux@treblig.org
Link: https://lkml.kernel.org/r/20250419203012.429787-2-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   20 --------------------
 drivers/rapidio/rio_cm.c                 |    6 ------
 2 files changed, 26 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-remove-some-dead-defines
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -98,18 +98,6 @@ MODULE_PARM_DESC(dbg_level, "Debugging o
 #endif
 
 /*
- * An internal DMA coherent buffer
- */
-struct mport_dma_buf {
-	void		*ib_base;
-	dma_addr_t	ib_phys;
-	u32		ib_size;
-	u64		ib_rio_base;
-	bool		ib_map;
-	struct file	*filp;
-};
-
-/*
  * Internal memory mapping structure
  */
 enum rio_mport_map_dir {
@@ -131,14 +119,6 @@ struct rio_mport_mapping {
 	struct file *filp;
 };
 
-struct rio_mport_dma_map {
-	int valid;
-	u64 length;
-	void *vaddr;
-	dma_addr_t paddr;
-};
-
-#define MPORT_MAX_DMA_BUFS	16
 #define MPORT_EVENT_DEPTH	10
 
 /*
--- a/drivers/rapidio/rio_cm.c~rapidio-remove-some-dead-defines
+++ a/drivers/rapidio/rio_cm.c
@@ -198,12 +198,6 @@ struct cm_peer {
 	struct rio_dev *rdev;
 };
 
-struct rio_cm_work {
-	struct work_struct work;
-	struct cm_dev *cm;
-	void *data;
-};
-
 struct conn_req {
 	struct list_head node;
 	u32 destid;	/* requester destID */
_

Patches currently in -mm which might be from linux@treblig.org are

rapidio-remove-some-dead-defines.patch
rapidio-remove-unused-functions.patch

