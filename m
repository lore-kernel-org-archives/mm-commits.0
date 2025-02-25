Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0A6212FB6
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523208; cv=none; b=Uoa3ByIwp+xVdnYm8Fr0YwRcUjliJOIMFwEFQh38iWg7waogyE/IPE+8WhdC0I2oA1qP8/hgqAu0uiraoJtakhMY0sR+NkaQK5CY7AFqekW4pLsFOreMdB6J/18SEpcZC7jGWYY1BnnrCnofBxO68KXO32NeIaaqF9wZRSC7k+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523208; c=relaxed/simple;
	bh=d/rHBcOAKJlH3KJtwi279iW6c93sYvY0dYFpZOae8Eo=;
	h=Date:To:From:Subject:Message-Id; b=qgKVDOQnYsmkw2+eMVq+m3+AEJNXWqYl/s43MGGnzW1X6BN9SAMeRRoTYAA/DhC7UrWW/pIH3Jg2u9XiTwj9MeFWljfoHFknkiiCQH5HSp3JuJ0PvtMilvy+c64iwhJvdoPCkSxtp/MQwlx9Gg+7TF4PZn/R2+4gPJWW/NY9vnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wF9VnjQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wF9VnjQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1FBC4CEDD;
	Tue, 25 Feb 2025 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740523207;
	bh=d/rHBcOAKJlH3KJtwi279iW6c93sYvY0dYFpZOae8Eo=;
	h=Date:To:From:Subject:From;
	b=wF9VnjQGGSYFiAQzpMxcCBohunSFgHaDAFDmT15hmTvpk+OhyPeMxIFDlK9S0Wy3u
	 TtcC7PEiCDW3zLzqaCSlIct69NE7+2wY3j6a5Pyms+zuTyoRBveBBcknI2LtBQZGtT
	 tlZ83SF2hsoxnO8KkOAoi0WWbadxrx8GkR12b0Gw=
Date: Tue, 25 Feb 2025 14:40:06 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch added to mm-nonmm-unstable branch
Message-Id: <20250225224007.4B1FBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: accel/habanalabs: convert timeouts to secs_to_jiffies()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch

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
Subject: accel/habanalabs: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:17 +0000

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

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-3-a43967e36c88@linux.microsoft.com
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

 drivers/accel/habanalabs/common/command_submission.c |    2 +-
 drivers/accel/habanalabs/common/debugfs.c            |    2 +-
 drivers/accel/habanalabs/common/device.c             |    2 +-
 drivers/accel/habanalabs/common/habanalabs_drv.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/accel/habanalabs/common/command_submission.c~accel-habanalabs-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/accel/habanalabs/common/command_submission.c
@@ -2586,7 +2586,7 @@ int hl_cs_ioctl(struct drm_device *ddev,
 		cs_seq = args->in.seq;
 
 	timeout = flags & HL_CS_FLAGS_CUSTOM_TIMEOUT
-			? msecs_to_jiffies(args->in.timeout * 1000)
+			? secs_to_jiffies(args->in.timeout)
 			: hpriv->hdev->timeout_jiffies;
 
 	switch (cs_type) {
--- a/drivers/accel/habanalabs/common/debugfs.c~accel-habanalabs-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/accel/habanalabs/common/debugfs.c
@@ -1403,7 +1403,7 @@ static ssize_t hl_timeout_locked_write(s
 		return rc;
 
 	if (value)
-		hdev->timeout_jiffies = msecs_to_jiffies(value * 1000);
+		hdev->timeout_jiffies = secs_to_jiffies(value);
 	else
 		hdev->timeout_jiffies = MAX_SCHEDULE_TIMEOUT;
 
--- a/drivers/accel/habanalabs/common/device.c~accel-habanalabs-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/accel/habanalabs/common/device.c
@@ -2091,7 +2091,7 @@ int hl_device_cond_reset(struct hl_devic
 	dev_dbg(hdev->dev, "Device is going to be hard-reset in %u sec unless being released\n",
 		hdev->device_release_watchdog_timeout_sec);
 	schedule_delayed_work(&hdev->device_release_watchdog_work.reset_work,
-				msecs_to_jiffies(hdev->device_release_watchdog_timeout_sec * 1000));
+				secs_to_jiffies(hdev->device_release_watchdog_timeout_sec));
 	hdev->reset_info.watchdog_active = 1;
 out:
 	spin_unlock(&hdev->reset_info.lock);
--- a/drivers/accel/habanalabs/common/habanalabs_drv.c~accel-habanalabs-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/accel/habanalabs/common/habanalabs_drv.c
@@ -386,7 +386,7 @@ static int fixup_device_params(struct hl
 	hdev->fw_comms_poll_interval_usec = HL_FW_STATUS_POLL_INTERVAL_USEC;
 
 	if (tmp_timeout)
-		hdev->timeout_jiffies = msecs_to_jiffies(tmp_timeout * MSEC_PER_SEC);
+		hdev->timeout_jiffies = secs_to_jiffies(tmp_timeout);
 	else
 		hdev->timeout_jiffies = MAX_SCHEDULE_TIMEOUT;
 
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

