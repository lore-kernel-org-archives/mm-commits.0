Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A79A218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189568; cv=none; b=osCECwiDVyt/Cm4nN6xVmKvlgb7g35hbLXhUdzt7UAEKfG+FQQkXh2MT+1LBF423AAH+moEJtYxcbtqhZu9LLoXOh7gm8S2xsg1e+PIkVeaHCn2O2vLrJfB6qL4UPjR0RkqOTboxfb+wLbo4jRBgQupNvH5z59Cp96t5668Kn2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189568; c=relaxed/simple;
	bh=MNHmFlp2OdvovXAYYMiKzq8iJhNMVR7L6Flt4VMqFX8=;
	h=Date:To:From:Subject:Message-Id; b=M9zoqJvB0LnIrCiiswZmhJUcfxfr9IyqUTe0CB7mtL7UXFCy2zdWFSZaDpEArpJpFKpRfE9uBB0ebqWJ8jSCMx1kLnhoy6fvP5J+ma6tlBxC7W4aRYHsbE34d0kf/l+lHScD20bJN7u2B3vuv9hahCpi0AfkRwGMVErdj56chtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aZPAa3JY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZPAa3JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C5FC4CEEC;
	Mon, 17 Mar 2025 05:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189568;
	bh=MNHmFlp2OdvovXAYYMiKzq8iJhNMVR7L6Flt4VMqFX8=;
	h=Date:To:From:Subject:From;
	b=aZPAa3JYa8lSlVoOTmMwr9bnAMTylWNLChLFJ5Pm1gZGojn1gEjqR+DNFo1NJJZjF
	 xTyYhakP6VWO9bO5219VuLwCu4SQuT050RIqW0dKpVOU4RcHyPjI9NuJVGnR4xUeBv
	 MC2bwcJ0DAR8yY5s95za1BKsUJgj5Q5Ud5zfF/I4=
Date: Sun, 16 Mar 2025 22:32:47 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rdma-bnxt_re-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250317053247.E9C5FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: RDMA/bnxt_re: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     rdma-bnxt_re-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: RDMA/bnxt_re: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:30 +0000

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies() to avoid the
multiplication

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@depends on patch@
expression E;
@@

-msecs_to_jiffies
+secs_to_jiffies
(E
- * \( 1000 \| MSEC_PER_SEC \)
)

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-16-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Frank Li <frank.li@nxp.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Selvin Thyparampil Xavier <selvin.xavier@broadcom.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c~rdma-bnxt_re-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -160,7 +160,7 @@ static int __wait_for_resp(struct bnxt_q
 		wait_event_timeout(cmdq->waitq,
 				   !crsqe->is_in_used ||
 				   test_bit(ERR_DEVICE_DETACHED, &cmdq->flags),
-				   msecs_to_jiffies(rcfw->max_timeout * 1000));
+				   secs_to_jiffies(rcfw->max_timeout));
 
 		if (!crsqe->is_in_used)
 			return 0;
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


