Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EF021D5A7
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523213; cv=none; b=AiCUmtICMsfl74mRRLa/Tx/YENlIXQCiz9SeqVMtuTodMrE4K9SWwQAzB7KURia6pa/gQ7fT7U+Tmsx0Ouvb0zTisfLGIZ2YkTdhL1LJ9jgFgnXbG4UhylbZnkTVCPK821gN6MXHIQ+1K/dH7U3p/bDWlVPKUOa69k19EU7dVsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523213; c=relaxed/simple;
	bh=nRf4VckzYNwNqVDq2O6R7fzQPvj1r+SX4ZoLpIi/HeU=;
	h=Date:To:From:Subject:Message-Id; b=XMthrS4YWCC8VHrnhwt5QIbODEWTJq4STvdk1vlQJZ4j2Pnrlb27UM4yYCV7evVEdO+TbwAwNVIcKX59bVoSICBvZr6RGJ5bq1JXjhRzGPTAbVp5vs+K8D83BLLCeHDlnYQNp0dJsqHdOnfM8bXU7zrqrO6vlpo2iW6MpKLb4PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hdTgHUw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hdTgHUw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E0EC4CEDD;
	Tue, 25 Feb 2025 22:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740523213;
	bh=nRf4VckzYNwNqVDq2O6R7fzQPvj1r+SX4ZoLpIi/HeU=;
	h=Date:To:From:Subject:From;
	b=hdTgHUw93UQ8BYgrKrs3W0pYi3b1GYzqy2x5C9mQl74PFxFftpUfbW35exuNY5bJI
	 Ol7iYpZEbNfyg2dx/WrOWJdZI4NPWUPp+Dp1/qPLRELWGB3xlDl1IPN0+4ObM4MYA5
	 HA2v+UmUL3fkOITdV7kYkcc+LPKsMMWOPTBXxdZk=
Date: Tue, 25 Feb 2025 14:40:12 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-convert-timeouts-to-secs_to_jiffies.patch added to mm-nonmm-unstable branch
Message-Id: <20250225224013.34E0EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: btrfs: convert timeouts to secs_to_jiffies()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     btrfs-convert-timeouts-to-secs_to_jiffies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-convert-timeouts-to-secs_to_jiffies.patch

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
Subject: btrfs: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:19 +0000

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

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-5-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
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

 fs/btrfs/disk-io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/disk-io.c~btrfs-convert-timeouts-to-secs_to_jiffies
+++ a/fs/btrfs/disk-io.c
@@ -1568,7 +1568,7 @@ static int transaction_kthread(void *arg
 
 	do {
 		cannot_commit = false;
-		delay = msecs_to_jiffies(fs_info->commit_interval * 1000);
+		delay = secs_to_jiffies(fs_info->commit_interval);
 		mutex_lock(&fs_info->transaction_kthread_mutex);
 
 		spin_lock(&fs_info->trans_lock);
@@ -1583,9 +1583,9 @@ static int transaction_kthread(void *arg
 		    cur->state < TRANS_STATE_COMMIT_PREP &&
 		    delta < fs_info->commit_interval) {
 			spin_unlock(&fs_info->trans_lock);
-			delay -= msecs_to_jiffies((delta - 1) * 1000);
+			delay -= secs_to_jiffies(delta - 1);
 			delay = min(delay,
-				    msecs_to_jiffies(fs_info->commit_interval * 1000));
+				    secs_to_jiffies(fs_info->commit_interval));
 			goto sleep;
 		}
 		transid = cur->transid;
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

