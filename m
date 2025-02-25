Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52098221564
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 22:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523200; cv=none; b=Myq7d1ziF7u+ZEOELRgKdFbAl8UC+/p+t5TXURWRvvxTAIedYFmIFXi8uZwo++Ka09kxYZ+I/g7vnXz8w9MOoCPwjK6Bs7wNuYdqHpKg4bDt00U1bpaeq55tlEdBZhn6sJXqkpKoQAGRpi8smorX1+iOZBk7N9DpkiZfP9BexvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523200; c=relaxed/simple;
	bh=OyJbo2PAww3iuWnCebHusRm1YPIWFvLzyEJz5NjinSs=;
	h=Date:To:From:Subject:Message-Id; b=evuOYLdsJdwCyi2GGBXQssUO7DcNpheGJM1JyOSHCjJYD/yqJI2N9SJ13TKDf/1V7P2gvy03Mo+EKYCDy59RYl+WxuXEDPKkrYEgEeln8d4/tgNwLwHAaQLRX+IitPxG1EWkqlvkdXncHtR9o1Zk2kojoSE4eXT0TXwNhZR0yE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EDQqiFtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EDQqiFtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA131C4CEDD;
	Tue, 25 Feb 2025 22:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740523200;
	bh=OyJbo2PAww3iuWnCebHusRm1YPIWFvLzyEJz5NjinSs=;
	h=Date:To:From:Subject:From;
	b=EDQqiFtOkGWoQkdy9W/J16wqWRsgZQm9sEKYhx7za2b62BZL1JT4/uUjQStH4ye6X
	 1HCa3xj/mRH4KfuSPX/DYM0+hsaKvh5KhvFY3gW4gMZMIme8XsALPoCtiWiKsq0dMF
	 A3PayCU18fsOW9FQfkZsJMemAtbf2p1KPeSnVInY=
Date: Tue, 25 Feb 2025 14:39:59 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch added to mm-nonmm-unstable branch
Message-Id: <20250225223959.EA131C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coccinelle: misc: secs_to_jiffies: Patch expressions too
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch

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
Subject: coccinelle: misc: secs_to_jiffies: Patch expressions too
Date: Tue, 25 Feb 2025 20:17:15 +0000

Patch series "Converge on using secs_to_jiffies() part two", v3.

This is the second series that converts users of msecs_to_jiffies() that
either use the multiply pattern of either of:
- msecs_to_jiffies(N*1000) or
- msecs_to_jiffies(N*MSEC_PER_SEC)

where N is a constant or an expression, to avoid the multiplication.

The conversion is made with Coccinelle with the secs_to_jiffies() script
in scripts/coccinelle/misc.  Attention is paid to what the best change can
be rather than restricting to what the tool provides.


This patch (of 15):

Teach the script to suggest conversions for timeout patterns where the
arguments to msecs_to_jiffies() are expressions as well.

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com
Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-1-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Selvin Thyparampil Xavier <selvin.xavier@broadcom.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/misc/secs_to_jiffies.cocci |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/coccinelle/misc/secs_to_jiffies.cocci~coccinelle-misc-secs_to_jiffies-patch-expressions-too
+++ a/scripts/coccinelle/misc/secs_to_jiffies.cocci
@@ -20,3 +20,13 @@ virtual patch
 
 - msecs_to_jiffies(C * MSEC_PER_SEC)
 + secs_to_jiffies(C)
+
+@depends on patch@ expression E; @@
+
+- msecs_to_jiffies(E * 1000)
++ secs_to_jiffies(E)
+
+@depends on patch@ expression E; @@
+
+- msecs_to_jiffies(E * MSEC_PER_SEC)
++ secs_to_jiffies(E)
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

