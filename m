Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7692192E2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189555; cv=none; b=j/iiUdzzhyWmwP6pe3WvYZLBVV8yWyHK1fhFoeUl5ZSnMlzRZhq8sq4EGMhbMyPYsv4B8d8/z/AYnOyq9wwidc9X6kiAngF9cQiCUYxHV1CDI71YywjEr+xfTxDlMAx0jBXee7JxKgeRdOhUM8hcEmRf39c3XQaqw+W0HqG8Ov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189555; c=relaxed/simple;
	bh=Jsq2/ooA7CTD4Z0WbveIootoLpMYloLB7tTcEp9aWcU=;
	h=Date:To:From:Subject:Message-Id; b=VmYGCSTV2AotTbRL+jbq4xPBUtdoDEGx87xqkPGiyvQJhhVc6n9bGnRb9HZ66n9ADhFta5s4sBhRpckS7BZDlZ/DF1W8V+pCg/9khln2Ak45KnS2xAAJ1SrDWfmNaU+Fv3/rP4TLKh/wIJ8CVtGgBRsk0yd/eiPO9VGcA3v38SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvSjGKNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvSjGKNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB19FC4CEEC;
	Mon, 17 Mar 2025 05:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189555;
	bh=Jsq2/ooA7CTD4Z0WbveIootoLpMYloLB7tTcEp9aWcU=;
	h=Date:To:From:Subject:From;
	b=nvSjGKNWrVyeA8DSZmdnbwvrhlNab73aRDx+VBZQ9RspOCsN6NlJJEAPjq5VTO2wz
	 ImTvQxjGaFB6RejpxHGTzDl+TpWiTnYvJUVKGSEcAEREidaMk4fwmycpxcvZtdeT1o
	 VkessSTrOiLWsHClBszX7iiRd8a6jRsRDBEtcTVQ=
Date: Sun, 16 Mar 2025 22:32:34 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xfs-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250317053234.EB19FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xfs: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     xfs-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


