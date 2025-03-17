Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ED92192E2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189551; cv=none; b=r7OMF1eG8rbnfEKMNO+Cprij1ADjyr7dtcuD7JTkuciAAYeVQZY6XudbTj/FGiiDIy2d1MMVfk8f6Z6Q6rqm6ILxU8Rq5t0aqycsAqpFo1ZztwK2ZxfSC8O6w5+zwvxMbSCNJIROeJRGx8sOpLczx2WJq9utIXmw0Ka2SCW+w/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189551; c=relaxed/simple;
	bh=MJEsj5rm58y0zQoMc672RNzSVpkqtnOSS9zg7e9GUyc=;
	h=Date:To:From:Subject:Message-Id; b=YARktI8+iCQVTrZ0VDo8Qtm+RfJLBs0p1ctwhS42dCjv7TX3ESzs/C4x1q1tYKr6v1UCt27+WzARsJCg39oQI2ZaHx2RoN+s9GB3YWxwMKd1ultjGZCZ/83mW4cDTa0UMxDceSl8qVHZCy4Cu8ELOQk49oOJONM4X0Ay0LLnb0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uojY1hla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uojY1hla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84315C4CEEC;
	Mon, 17 Mar 2025 05:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189551;
	bh=MJEsj5rm58y0zQoMc672RNzSVpkqtnOSS9zg7e9GUyc=;
	h=Date:To:From:Subject:From;
	b=uojY1hla7XZRj2By4UbvTxxn4IQHOKm/zdhODAtvT8pvE3UEvU2Leo5y6alEVDEGj
	 33pOf4sXD2urWcd5K2dS7JUWxgTryiUOIKi9fdlp4TG/M2VhO6xhkFnjAnDbS7XFcG
	 RMAYI9WDXKrldFjyUuU86mKdktbcHRiy2A/mWb5w=
Date: Sun, 16 Mar 2025 22:32:31 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tiwai@suse.de,tiwai@suse.com,sre@kernel.org,Shyam-sundar.S-k@amd.com,shawnguo@kernel.org,s.hauer@pengutronix.de,selvin.xavier@broadcom.com,sagi@grimberg.me,perex@perex.cz,ogabbay@kernel.org,nicolas.palix@imag.fr,mkl@pengutronix.de,martin.petersen@oracle.com,leon@kernel.org,kbusch@kernel.org,kalesh-anakkur.purayil@broadcom.com,julia.lawall@inria.fr,josef@toxicpanda.com,jgg@ziepe.ca,james.smart@broadcom.com,james.bottomley@HansenPartnership.com,ilpo.jarvinen@linux.intel.com,idryomov@gmail.com,hmh@hmh.eng.br,hdegoede@redhat.com,hch@lst.de,frank.li@nxp.com,festevam@gmail.com,dsterba@suse.com,dongsheng.yang@easystack.cn,dlemoal@kernel.org,djwong@kernel.org,dick.kennedy@broadcom.com,cmaiolino@redhat.com,clm@fb.com,cem@kernel.org,cassel@kernel.org,broonie@kernel.org,axboe@kernel.dk,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] libceph-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250317053231.84315C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: libceph: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     libceph-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: libceph: convert timeouts to secs_to_jiffies()
Date: Tue, 25 Feb 2025 20:17:21 +0000

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies() to avoid the
multiplication

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@depends on patch@ expression E; @@

-msecs_to_jiffies(E * 1000)
+secs_to_jiffies(E)

@depends on patch@ expression E; @@

-msecs_to_jiffies(E * MSEC_PER_SEC)
+secs_to_jiffies(E)

While here, remove the no-longer necessary checks for range since there's
no multiplication involved.

Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-7-a43967e36c88@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Acked-by: Ilya Dryomov <idryomov@gmail.com>
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

 include/linux/ceph/libceph.h |   12 ++++++------
 net/ceph/ceph_common.c       |   18 ++++++------------
 net/ceph/osd_client.c        |    3 +--
 3 files changed, 13 insertions(+), 20 deletions(-)

--- a/include/linux/ceph/libceph.h~libceph-convert-timeouts-to-secs_to_jiffies
+++ a/include/linux/ceph/libceph.h
@@ -72,15 +72,15 @@ struct ceph_options {
 /*
  * defaults
  */
-#define CEPH_MOUNT_TIMEOUT_DEFAULT	msecs_to_jiffies(60 * 1000)
-#define CEPH_OSD_KEEPALIVE_DEFAULT	msecs_to_jiffies(5 * 1000)
-#define CEPH_OSD_IDLE_TTL_DEFAULT	msecs_to_jiffies(60 * 1000)
+#define CEPH_MOUNT_TIMEOUT_DEFAULT	secs_to_jiffies(60)
+#define CEPH_OSD_KEEPALIVE_DEFAULT	secs_to_jiffies(5)
+#define CEPH_OSD_IDLE_TTL_DEFAULT	secs_to_jiffies(60)
 #define CEPH_OSD_REQUEST_TIMEOUT_DEFAULT 0  /* no timeout */
 #define CEPH_READ_FROM_REPLICA_DEFAULT	0  /* read from primary */
 
-#define CEPH_MONC_HUNT_INTERVAL		msecs_to_jiffies(3 * 1000)
-#define CEPH_MONC_PING_INTERVAL		msecs_to_jiffies(10 * 1000)
-#define CEPH_MONC_PING_TIMEOUT		msecs_to_jiffies(30 * 1000)
+#define CEPH_MONC_HUNT_INTERVAL		secs_to_jiffies(3)
+#define CEPH_MONC_PING_INTERVAL		secs_to_jiffies(10)
+#define CEPH_MONC_PING_TIMEOUT		secs_to_jiffies(30)
 #define CEPH_MONC_HUNT_BACKOFF		2
 #define CEPH_MONC_HUNT_MAX_MULT		10
 
--- a/net/ceph/ceph_common.c~libceph-convert-timeouts-to-secs_to_jiffies
+++ a/net/ceph/ceph_common.c
@@ -527,29 +527,23 @@ int ceph_parse_param(struct fs_parameter
 
 	case Opt_osdkeepalivetimeout:
 		/* 0 isn't well defined right now, reject it */
-		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
+		if (result.uint_32 < 1)
 			goto out_of_range;
-		opt->osd_keepalive_timeout =
-		    msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_keepalive_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_osd_idle_ttl:
 		/* 0 isn't well defined right now, reject it */
-		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
+		if (result.uint_32 < 1)
 			goto out_of_range;
-		opt->osd_idle_ttl = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_idle_ttl = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_mount_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (result.uint_32 > INT_MAX / 1000)
-			goto out_of_range;
-		opt->mount_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->mount_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_osd_request_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (result.uint_32 > INT_MAX / 1000)
-			goto out_of_range;
-		opt->osd_request_timeout =
-		    msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_request_timeout = secs_to_jiffies(result.uint_32);
 		break;
 
 	case Opt_share:
--- a/net/ceph/osd_client.c~libceph-convert-timeouts-to-secs_to_jiffies
+++ a/net/ceph/osd_client.c
@@ -4989,8 +4989,7 @@ int ceph_osdc_notify(struct ceph_osd_cli
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
 	if (!ret)
-		ret = linger_notify_finish_wait(lreq,
-				 msecs_to_jiffies(2 * timeout * MSEC_PER_SEC));
+		ret = linger_notify_finish_wait(lreq, secs_to_jiffies(2 * timeout));
 	else
 		dout("lreq %p failed to initiate notify %d\n", lreq, ret);
 
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


