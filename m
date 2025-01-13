Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA025761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742167; cv=none; b=Vzb7jkjdFqWYH7BnCqru5L8HrkENKe+vJ/FY2Uoga+yrUendH7OimQo5AtMT9Kk1lAxz+tH5okddLElQGREASql0c5s/1VlroI1SDFB80xH0HsQTZi+vU/NFYwPP6zqVXV5FBJDQ0U/rMR5Faz7iWn94z0Q+EjoHtNxUCcse8J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742167; c=relaxed/simple;
	bh=MVfQ/wYU2tlZpCZQ4/lZ95CA07uMbtplVFalS45fxGk=;
	h=Date:To:From:Subject:Message-Id; b=kIO1cW/yu073vsEhkcGtTJsmRrtHE03sUSy2KvgnaiNdhGTB78WXfDA1KRLr9MrtiLiD14BSBp9+Cqd978HbbrknZ5KJD2YNPuasco6mPCequtcS/jZUnCcx1DYXfa4Hnn/KtHwuC7T7qubtWehTN/u94ZQHC4yUd2CspyoufB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S6JgXUqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S6JgXUqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2884DC4CED6;
	Mon, 13 Jan 2025 04:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742167;
	bh=MVfQ/wYU2tlZpCZQ4/lZ95CA07uMbtplVFalS45fxGk=;
	h=Date:To:From:Subject:From;
	b=S6JgXUqsYPIPSTizxWqLYFc7ID0rHD1LUpIG5pbcLvWuF7a/Tzlg2TdrMqOkxIpqK
	 JaaruWm42IQ1zj2sCb/dGmNt3rcREzhPvJVptV5FP5jJtuaXysgMRNJw6PSlAaAUBb
	 mhFVhKJw2PEnxu86E5YsKIR69DB4tPGj0I8h8ISk=
Date: Sun, 12 Jan 2025 20:22:46 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tzimmermann@suse.de,tiwai@suse.com,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,simona@ffwll.ch,shailend@google.com,sbranden@broadcom.com,roger.pau@citrix.com,rodrigo.vivi@intel.com,robert.jarzmik@free.fr,rjui@broadcom.com,quic_jjohnson@quicinc.com,pmladek@suse.com,pkaligineedi@google.com,perex@perex.cz,pablo@netfilter.org,pabeni@redhat.com,ogabbay@kernel.org,obitton@habana.ai,npiggin@gmail.com,nicolas.palix@imag.fr,naveen@kernel.org,mripard@kernel.org,mpe@ellerman.id.au,mbenes@suse.cz,martin.petersen@oracle.com,marcel@holtmann.org,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,luiz.dentz@gmail.com,lucas.demarchi@intel.com,louis.peens@corigine.com,linux@armlinux.org.uk,kvalo@kernel.org,kuba@kernel.org,kadlec@netfilter.org,julia.lawall@inria.fr,jpoimboe@kernel.org,johan.hedberg@gmail.com,joe.lawrence@redhat.com,jjohnson@kernel.org,jinpu.wang@cloud.ionos.com,jikos@kernel.org,jeroendb@google.com,james.smart@broadcom.com,James.Bottomley@HansenPartnership.com,idryomov@gmail.com,horms@kernel.org,hca@linux.ibm.com,haojian.zhuang@gmail.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,florian.fainelli@broadcom.com,edumazet@google.com,dick.kennedy@broadcom.com,davem@davemloft.net,daniel@zonque.org,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,axboe@kernel.dk,anna-maria@linutronix.de,andrew+netdev@lunn.ch,airlied@gmail.com,agordeev@linux.ibm.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250113042247.2884DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: accel/habanalabs: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: accel/habanalabs: convert timeouts to secs_to_jiffies()
Date: Tue, 10 Dec 2024 22:02:38 +0000

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

Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-7-ddfefd7e9f2a@linux.microsoft.com
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

 drivers/accel/habanalabs/common/device.c         |    2 +-
 drivers/accel/habanalabs/common/habanalabs_drv.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/accel/habanalabs/common/device.c~accel-habanalabs-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/accel/habanalabs/common/device.c
@@ -817,7 +817,7 @@ static void device_hard_reset_pending(st
 		}
 
 		queue_delayed_work(hdev->reset_wq, &device_reset_work->reset_work,
-					msecs_to_jiffies(HL_PENDING_RESET_PER_SEC * 1000));
+					secs_to_jiffies(HL_PENDING_RESET_PER_SEC));
 	}
 }
 
--- a/drivers/accel/habanalabs/common/habanalabs_drv.c~accel-habanalabs-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/accel/habanalabs/common/habanalabs_drv.c
@@ -362,8 +362,7 @@ static void fixup_device_params_per_asic
 		 * a different default timeout for Gaudi
 		 */
 		if (timeout == HL_DEFAULT_TIMEOUT_LOCKED)
-			hdev->timeout_jiffies = msecs_to_jiffies(GAUDI_DEFAULT_TIMEOUT_LOCKED *
-										MSEC_PER_SEC);
+			hdev->timeout_jiffies = secs_to_jiffies(GAUDI_DEFAULT_TIMEOUT_LOCKED);
 
 		hdev->reset_upon_device_release = 0;
 		break;
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


