Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE42218AC3
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189549; cv=none; b=DWd80+dIJdkR8eaaRzRMyyDGfrbprhch92Tj3e30wGWDq83rs3ctYKc0lJC17f3JOtNyYd8INPrFQMYKgMIMmh/iBvtDncu278uG7LZ2yqdOfwZlcMBcv8cxQyyGz2XO1wQ5nXaYv/jAsbjGmugqSIkP4c3VGA6rHNObA9+d9vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189549; c=relaxed/simple;
	bh=YQlOkODlh/K4JKfNNn8Id2lRZBc7c66V2yyg0Mph0kc=;
	h=Date:To:From:Subject:Message-Id; b=guqzm0NvuzrRpgJ64Xc3QSCCrXqoPmZkXZ6ps2yABFkZnB4+EjBUqhFDzPCMKUnnRVaFmc7nDjjOXLpryo4lu+YY5//ym4ki1a2wNR3IMAD+PvRBtY5a/bQcEGANNli7tlw2lz9kszdNCfArqPGRRWJU8eIUmFN3WH+/XRkj+1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdyGve5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdyGve5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F63C4CEEC;
	Mon, 17 Mar 2025 05:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189549;
	bh=YQlOkODlh/K4JKfNNn8Id2lRZBc7c66V2yyg0Mph0kc=;
	h=Date:To:From:Subject:From;
	b=gdyGve5TcD5snyb5e9+uDsAPZc8caHI6Ir5ju8FCO5yLSf9qCECixA5FN+Kr+HDSb
	 D7v3WtzOoFD8zCBhUjOGsFZkC4HY0CfvSCrhxjabVnaOXvrIZuy+LUSvlcA8svu9KI
	 srKjrVzxDzB182lmVLy+ItsuEjQYP61igkx4OtN0=
Date: Sun, 16 Mar 2025 22:32:29 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] btrfs-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250317053229.A6F63C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: btrfs: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     btrfs-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


