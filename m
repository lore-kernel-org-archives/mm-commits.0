Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861DD212FB6
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523221; cv=none; b=Gb7zrzjp/J80vFuSLKYE4I2yaVbv7uiYOlTUucTZAGo+kSD0HIpjKwv61jy9uypYLYrchgF6bDgS0tfbFF7sRNhD5wLH8WBtotXoIeo1TcZ4ou8NFmOZTs4Ey5O8nQxj7tFERBWwHQ/3Pn4OwXtBw8LCtWcihmzyrgONP0PNjJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523221; c=relaxed/simple;
	bh=GWeCUIeV+VN1R7pslybM1kj0n0KmA6JztZoaRmxCs0I=;
	h=Date:To:From:Subject:Message-Id; b=dOXbSH772RVNgmX6QgObPIQU/riTMJj/EaCoJLXSPPbIoSE02AEPdgQRjq0uAb7q0NmvZcDpWlLBwSG7N+1vsCVbrU3UgpxQyWo7r7A2Ts/RnbpKuZJyPLpc+aC9uEZEs5lfjEN//QaY0aRTdu0UzpXz/HKUK2XrFks374BkPqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i46SsgF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i46SsgF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FC9C4CEDD;
	Tue, 25 Feb 2025 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740523221;
	bh=GWeCUIeV+VN1R7pslybM1kj0n0KmA6JztZoaRmxCs0I=;
	h=Date:To:From:Subject:From;
	b=i46SsgF7z4B7gChahxMg0AAk1DELsfBnwOQLbLizdN6hp+QbA0GDnudd1tVSB7ZLT
	 ijIEF4Qq3ftq4RTNQGznMwSWzzBz0/nKtGIJZgs5WpNrsRIY+1wSJKleIZoseD1da2
	 diwXx6aSDuI5qNuONAaNcuVZ1Hz7O4KBBNjwlwA0=
Date: Tue, 25 Feb 2025 14:40:20 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-convert-timeouts-to-secs_to_jiffies.patch added to mm-nonmm-unstable branch
Message-Id: <20250225224021.51FC9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xfs: convert timeouts to secs_to_jiffies()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xfs-convert-timeouts-to-secs_to_jiffies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-convert-timeouts-to-secs_to_jiffies.patch

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
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: xfs: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:23 +0000

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

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-9-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Maol <dlemoal@kernel.org>
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

 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_sysfs.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_icache.c~xfs-convert-timeouts-to-secs_to_jiffies
+++ a/fs/xfs/xfs_icache.c
@@ -230,7 +230,7 @@ xfs_blockgc_queue(
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
 		queue_delayed_work(mp->m_blockgc_wq, &pag->pag_blockgc_work,
-				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
+				   secs_to_jiffies(xfs_blockgc_secs));
 	rcu_read_unlock();
 }
 
--- a/fs/xfs/xfs_sysfs.c~xfs-convert-timeouts-to-secs_to_jiffies
+++ a/fs/xfs/xfs_sysfs.c
@@ -568,8 +568,8 @@ retry_timeout_seconds_store(
 	if (val == -1)
 		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
 	else {
-		cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
-		ASSERT(msecs_to_jiffies(val * MSEC_PER_SEC) < LONG_MAX);
+		cfg->retry_timeout = secs_to_jiffies(val);
+		ASSERT(secs_to_jiffies(val) < LONG_MAX);
 	}
 	return count;
 }
@@ -686,8 +686,8 @@ xfs_error_sysfs_init_class(
 		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
 			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
 		else
-			cfg->retry_timeout = msecs_to_jiffies(
-					init[i].retry_timeout * MSEC_PER_SEC);
+			cfg->retry_timeout =
+					secs_to_jiffies(init[i].retry_timeout);
 	}
 	return 0;
 
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are

coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch
accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch
alsa-ac97-convert-timeouts-to-secs_to_jiffies.patch
btrfs-convert-timeouts-to-secs_to_jiffies.patch
libceph-convert-timeouts-to-secs_to_jiffies.patch
ata-libata-zpodd-convert-timeouts-to-secs_to_jiffies.patch
xfs-convert-timeouts-to-secs_to_jiffies.patch
power-supply-da9030-convert-timeouts-to-secs_to_jiffies.patch
nvme-convert-timeouts-to-secs_to_jiffies.patch
spi-spi-fsl-lpspi-convert-timeouts-to-secs_to_jiffies.patch
spi-spi-imx-convert-timeouts-to-secs_to_jiffies.patch
platform-x86-amd-pmf-convert-timeouts-to-secs_to_jiffies.patch
platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies.patch
rdma-bnxt_re-convert-timeouts-to-secs_to_jiffies.patch

