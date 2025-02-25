Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB70A221574
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523236; cv=none; b=EJjc0X1kz3rtNjl0QRSiZHmEbZh1OfbpbzRdnZIOmX+SsPSlwm4t7D+iNWrChnjSsHonwTaPJu9AEDY8R1gyrGYZgSoQFlNWCsEAEm6jNi4V/+y95w/V+blIk+2F2NPSBn32+c6LTG2kH+ItswQfupvmfE+XdbbCKdPMp5NGjR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523236; c=relaxed/simple;
	bh=KV5b5vCxKGWsLPAdmGTuelPvse3W2eG3HGCseK3EIpo=;
	h=Date:To:From:Subject:Message-Id; b=euOTCusbNqoTpqW8xFFXzeu17VVUMaI/2P/dUEiPJIQg9n7N2CAOXM3+yX8R2SxVrqTabTm/LUatdWiAwczbDBO8lNu3AvmRf8nCTv/ZjYIcXKszQwa/k/XIhhZcUGWYfblQQX/F87TcRx5D63IoDah8AykSNeZTQpkAb2NDJkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5zk5Ycc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5zk5Ycc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408EEC4CEDD;
	Tue, 25 Feb 2025 22:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740523236;
	bh=KV5b5vCxKGWsLPAdmGTuelPvse3W2eG3HGCseK3EIpo=;
	h=Date:To:From:Subject:From;
	b=c5zk5Ycc6f4azQJBjL4XWccJe6XFi2CO3VvsyS+iJtGofB/J12Q2D+gBpTBtccqNR
	 2SmEwc9qTVEIbZLkrCO0yfh/ngInF8MxF0vd+67asadxMQZ38Xfr+Nt/odNGbfrFMZ
	 OoVPJJINvQjL5uBK+yk4BIFVRXPlSN3N+eQx7bk8=
Date: Tue, 25 Feb 2025 14:40:35 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies.patch added to mm-nonmm-unstable branch
Message-Id: <20250225224036.408EEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: platform/x86: thinkpad_acpi: convert timeouts to secs_to_jiffies()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies.patch

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
Subject: platform/x86: thinkpad_acpi: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:29 +0000

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

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-15-a43967e36c88@linux.microsoft.com
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

 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c~platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -8513,7 +8513,7 @@ static void fan_watchdog_reset(void)
 	if (fan_watchdog_maxinterval > 0 &&
 	    tpacpi_lifecycle != TPACPI_LIFE_EXITING)
 		mod_delayed_work(tpacpi_wq, &fan_watchdog_task,
-			msecs_to_jiffies(fan_watchdog_maxinterval * 1000));
+			secs_to_jiffies(fan_watchdog_maxinterval));
 	else
 		cancel_delayed_work(&fan_watchdog_task);
 }
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

