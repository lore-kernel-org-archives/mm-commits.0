Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F1E218AC3
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189548; cv=none; b=ipNbcIoBP8ts4VLwawp2TR33RGdVqNs5T1nHXOlm3eLtLiuB8rwF6WALcunvwlMrmaJ40SsMkPmrcfbe/YELtudk5mKuIBvNAxEyZIPTEfXEUcoDXagyzvHWFfbE6Ho1ipfVQyAOYli46w4osG5uzifcWeJUsvNEGH1BHi9wsGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189548; c=relaxed/simple;
	bh=/WrvAs8fFk0dHBplPWeh58lFTbHQps2hQbZF0ZnLQ1o=;
	h=Date:To:From:Subject:Message-Id; b=FfPUvyvXmlWw3NIGiwz8qwaW4zvLdMwWJog84xO02Wf0BK4DNiPvM828YI1emwoc1pkzRP3zeJ10DZWtYOcxIWItThYMnGw5kEZQC3VlPN/CtxuIJPs9iCFOVhbJKD+BYN91tYy03IJxELp7/m+d+2wR1pzFPAztaDc4lU2bPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7HPK78n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7HPK78n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C827BC4CEEC;
	Mon, 17 Mar 2025 05:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189547;
	bh=/WrvAs8fFk0dHBplPWeh58lFTbHQps2hQbZF0ZnLQ1o=;
	h=Date:To:From:Subject:From;
	b=K7HPK78nzqhAtz2omW3gLXc4MbS1cjZ9uksV+mkdjQ1w/jKGXQLfe9TpgMG9khbWD
	 GpjXcSs6qU0gV996xhVcdD42OVV/qsKKFExnVPamvEH/hyX5roqnHpDRDEDs59gf+c
	 /VX62a2YVagsNfPur1beW/1PZCmLygXnW+34yjbU=
Date: Sun, 16 Mar 2025 22:32:27 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] alsa-ac97-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250317053227.C827BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ALSA: ac97: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     alsa-ac97-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: ALSA: ac97: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:18 +0000

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

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-4-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
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
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ac97/ac97_codec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/ac97/ac97_codec.c~alsa-ac97-convert-timeouts-to-secs_to_jiffies
+++ a/sound/pci/ac97/ac97_codec.c
@@ -2461,8 +2461,7 @@ int snd_ac97_update_power(struct snd_ac9
 		 * (for avoiding loud click noises for many (OSS) apps
 		 *  that open/close frequently)
 		 */
-		schedule_delayed_work(&ac97->power_work,
-				      msecs_to_jiffies(power_save * 1000));
+		schedule_delayed_work(&ac97->power_work, secs_to_jiffies(power_save));
 	else {
 		cancel_delayed_work(&ac97->power_work);
 		update_power_regs(ac97);
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


