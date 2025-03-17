Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB84140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189539; cv=none; b=OOTZlF9xKIUUfCpWMURsySq1DrxFXE++EMFlr5TDtkyCOc5J+Yl7OMfbiFrqzJ31SldUS+CcEdYkXtgYCzcITeEKGvZ1Mx+YGMbsZmI2GYOhYUq/xzurw2+b9Oefsv6tytwwy0oIgSBiB3p5hChmaDE6Ci6GtzLxRzo0JJS6f1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189539; c=relaxed/simple;
	bh=Pr8DuK5Y1DS73gCeZOdT2g4LIScmCLb1d++sv1+lhaU=;
	h=Date:To:From:Subject:Message-Id; b=PLyf/C2pGv1CZ9I8YRa519krFqPbMgVBpE3r5EyVFTBVnJYle4EyuHXyclHctuP488lD+cA9uQSBsmDEx8llDGIkirgy8EmE/Y4NzTdXgliYXS/XXdqaoav7+l/H6/r9TGHSvd0Gn0pGmhHtu9Ja7K96wsTEOkpzkeKAhXy0HRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QWyEsni0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QWyEsni0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11819C4CEEC;
	Mon, 17 Mar 2025 05:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189539;
	bh=Pr8DuK5Y1DS73gCeZOdT2g4LIScmCLb1d++sv1+lhaU=;
	h=Date:To:From:Subject:From;
	b=QWyEsni0Tn1r/FVM0SO8yyaJN9XSMe/nYKaNv2UBKJwP9c8xDDL1HrbFXlBUH4Elq
	 reKNV/JJ8C8AVZhX/eCD+Xm74EK/dtcX78hZm05EO7pXgupP7LGFedYbQucgMFMu7i
	 Y6kA6cyaBN9grgsaWwUrBjo8ga90RCMPuum5Ud24=
Date: Sun, 16 Mar 2025 22:32:18 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch removed from -mm tree
Message-Id: <20250317053219.11819C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: coccinelle: misc: secs_to_jiffies: Patch expressions too
has been removed from the -mm tree.  Its filename was
     coccinelle-misc-secs_to_jiffies-patch-expressions-too.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


This patch (of 16):

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


