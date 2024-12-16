Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F961153BE4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734319088; cv=none; b=luc8i6BeyN4xCyelVM6VLIgPi2tR1uvz87c62hnhUf+0kXeluWPq6LTg+P7kWkNFYV915AEOGbYB7rXO0vuTXWZobjwAyqY01KvwXiou8qQTMW7wxqg0knADeqqQ4Zsb1zEXYooVGXkZGiGwb0HpoUrYVV4GnO2jKxd/lyumOD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734319088; c=relaxed/simple;
	bh=JSV3BCJvkkY0NJxt87jKMQ5V5somzLlu359n1rZgYHY=;
	h=Date:To:From:Subject:Message-Id; b=Hzhg3nvQlFGlZAE6rJ3urhGDJMzH/+cUvFyVZCpFZalfdWKHvTAkNB/BH2TP6L8+KDbOcHy9lPaUYXgsX2OTosGEVrlhVwl5uH7rOgGFsyqjG5bPWwqjE4f3jMgUzITYWVgBPy5MGUjibx3a/Mg0N5ZeMD38RGHa77bA+MGLdTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rgHUxs3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rgHUxs3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D980C4CED0;
	Mon, 16 Dec 2024 03:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734319087;
	bh=JSV3BCJvkkY0NJxt87jKMQ5V5somzLlu359n1rZgYHY=;
	h=Date:To:From:Subject:From;
	b=rgHUxs3DwKlmNWHoqUzHixVK3pthcNZa6s8sNSMPVd+HE//Zr0CUgoFqEOh7zdj8D
	 Sw1l85wua1R88+Jr4obpgTTFumF5Vui7QzVTjbenLrM6grgZsHkTAsPwQ+Et/yRYnL
	 Eww2IfnMp7OSpzQ4Wa1mR78MgLBWNu+4gHOUgL18=
Date: Sun, 15 Dec 2024 19:18:06 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tzimmermann@suse.de,tiwai@suse.com,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,simona@ffwll.ch,shailend@google.com,sbranden@broadcom.com,roger.pau@citrix.com,rodrigo.vivi@intel.com,robert.jarzmik@free.fr,rjui@broadcom.com,quic_jjohnson@quicinc.com,pmladek@suse.com,pkaligineedi@google.com,perex@perex.cz,pablo@netfilter.org,pabeni@redhat.com,ogabbay@kernel.org,obitton@habana.ai,npiggin@gmail.com,nicolas.palix@imag.fr,naveen@kernel.org,mripard@kernel.org,mpe@ellerman.id.au,mbenes@suse.cz,martin.petersen@oracle.com,marcel@holtmann.org,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,luiz.dentz@gmail.com,lucas.demarchi@intel.com,louis.peens@corigine.com,linux@armlinux.org.uk,kvalo@kernel.org,kuba@kernel.org,kadlec@netfilter.org,julia.lawall@inria.fr,jpoimboe@kernel.org,johan.hedberg@gmail.com,joe.lawrence@redhat.com,jjohnson@kernel.org,jinpu.wang@cloud.ionos.com,jikos@kernel.org,jeroendb@google.com,james.smart@broadcom.com,James.Bottomley@HansenPartnership.com,idryomov@gmail.com,horms@kernel.org,hca@linux.ibm.com,haojian.zhuang@gmail.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,florian.fainelli@broadcom.com,edumazet@google.com,dick.kennedy@broadcom.com,davem@davemloft.net,daniel@zonque.org,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,axboe@kernel.dk,anna-maria@linutronix.de,andrew+netdev@lunn.ch,airlied@gmail.com,agordeev@linux.ibm.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] gve-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20241216031807.9D980C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gve: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     gve-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: gve: convert timeouts to secs_to_jiffies()
Date: Tue, 10 Dec 2024 22:02:44 +0000

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@@ constant C; @@

- msecs_to_jiffies(C * 1000)
+ secs_to_jiffies(C)

@@ constant C; @@

- msecs_to_jiffies(C * MSEC_PER_SEC)
+ secs_to_jiffies(C)

Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-13-ddfefd7e9f2a@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Mack <daniel@zonque.org>
Cc: David Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Ofir Bitton <obitton@habana.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Praveen Kaligineedi <pkaligineedi@google.com>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Roger Pau Monné <roger.pau@citrix.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Shailend Chand <shailend@google.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Simon Horman <horms@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/google/gve/gve_tx_dqo.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c~gve-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -1146,8 +1146,7 @@ static void gve_handle_miss_completion(s
 	/* jiffies can wraparound but time comparisons can handle overflows. */
 	pending_packet->timeout_jiffies =
 			jiffies +
-			msecs_to_jiffies(GVE_REINJECT_COMPL_TIMEOUT *
-					 MSEC_PER_SEC);
+			secs_to_jiffies(GVE_REINJECT_COMPL_TIMEOUT);
 	add_to_list(tx, &tx->dqo_compl.miss_completions, pending_packet);
 
 	*bytes += pending_packet->skb->len;
@@ -1191,8 +1190,7 @@ static void remove_miss_completions(stru
 		pending_packet->state = GVE_PACKET_STATE_TIMED_OUT_COMPL;
 		pending_packet->timeout_jiffies =
 				jiffies +
-				msecs_to_jiffies(GVE_DEALLOCATE_COMPL_TIMEOUT *
-						 MSEC_PER_SEC);
+				secs_to_jiffies(GVE_DEALLOCATE_COMPL_TIMEOUT);
 		/* Maintain pending packet in another list so the packet can be
 		 * unallocated at a later time.
 		 */
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are

netfilter-conntrack-cleanup-timeout-definitions.patch
coccinelle-misc-add-secs_to_jiffies-script.patch
arm-pxa-convert-timeouts-to-use-secs_to_jiffies.patch
s390-kernel-convert-timeouts-to-use-secs_to_jiffies.patch
powerpc-papr_scm-convert-timeouts-to-secs_to_jiffies.patch
mm-kmemleak-convert-timeouts-to-secs_to_jiffies.patch
accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch
drm-xe-convert-timeout-to-secs_to_jiffies.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch
scsi-arcmsr-convert-timeouts-to-secs_to_jiffies.patch
scsi-pm8001-convert-timeouts-to-secs_to_jiffies.patch
xen-blkback-convert-timeouts-to-secs_to_jiffies.patch
wifi-ath11k-convert-timeouts-to-secs_to_jiffies.patch
bluetooth-mgmt-convert-timeouts-to-secs_to_jiffies.patch
staging-vc04_services-convert-timeouts-to-secs_to_jiffies.patch
ceph-convert-timeouts-to-secs_to_jiffies.patch
livepatch-convert-timeouts-to-secs_to_jiffies.patch
alsa-line6-convert-timeouts-to-secs_to_jiffies.patch

