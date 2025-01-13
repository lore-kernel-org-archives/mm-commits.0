Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A602154C0F
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742169; cv=none; b=q0pWMH/Asn8XiOYLbtxT4TxTXi7FNw739BMBB/ItNoy3Pw49eyLVnAx2E+IqBnEo4AtNwMfVCzM8uN2j5ghk30qUTajtqw8fXRGd5KQAS5DmYLF3geWGHRR/HLy1M0xLysRYb0Q8inL9PqpAbQ1SPFlIxIFTkXuEHFEv+z6pli8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742169; c=relaxed/simple;
	bh=+9zLpBXEcQG8F+fKPine2eYag1Wb0m10sBJ73KbEFmQ=;
	h=Date:To:From:Subject:Message-Id; b=WroJyvSI8+a7LTW7r9LyCTC3s3GGomTptSlOnpvuCPphywYqboos450eKHB7/Y/1nKfFEQd6jwTrlhtrX3KR4gPuxWsEsveVUi0mNsxpzprnrclstJOyWectZ+Gleu6KwHIbEqg0vRZMdamRTfTmbjdlbv5nLtRUhONmFxryRtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TYa49jK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TYa49jK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FA2C4CED6;
	Mon, 13 Jan 2025 04:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742169;
	bh=+9zLpBXEcQG8F+fKPine2eYag1Wb0m10sBJ73KbEFmQ=;
	h=Date:To:From:Subject:From;
	b=TYa49jK6Ex8EZN4zN40xc7FfvNT/2+SYiNIgyfBLthhn3aHZc24q5v5f6iDiCKavu
	 cJ11GkoQCjMFqnviPahRSJ1b0piIYMbQdDU2/woawI+9LoT/ucKDm5ZGN9SDe88Ejb
	 IkYHXbtyxGt57f5hBdTd9GWX8Q33sayizxF73VSo=
Date: Sun, 12 Jan 2025 20:22:48 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tzimmermann@suse.de,tiwai@suse.com,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,simona@ffwll.ch,shailend@google.com,sbranden@broadcom.com,roger.pau@citrix.com,rodrigo.vivi@intel.com,robert.jarzmik@free.fr,rjui@broadcom.com,quic_jjohnson@quicinc.com,pmladek@suse.com,pkaligineedi@google.com,perex@perex.cz,pablo@netfilter.org,pabeni@redhat.com,ogabbay@kernel.org,obitton@habana.ai,npiggin@gmail.com,nicolas.palix@imag.fr,naveen@kernel.org,mripard@kernel.org,mpe@ellerman.id.au,mbenes@suse.cz,martin.petersen@oracle.com,marcel@holtmann.org,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,luiz.dentz@gmail.com,lucas.demarchi@intel.com,louis.peens@corigine.com,linux@armlinux.org.uk,kvalo@kernel.org,kuba@kernel.org,kadlec@netfilter.org,julia.lawall@inria.fr,jpoimboe@kernel.org,johan.hedberg@gmail.com,joe.lawrence@redhat.com,jjohnson@kernel.org,jinpu.wang@cloud.ionos.com,jikos@kernel.org,jeroendb@google.com,james.smart@broadcom.com,James.Bottomley@HansenPartnership.com,idryomov@gmail.com,horms@kernel.org,hca@linux.ibm.com,haojian.zhuang@gmail.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,florian.fainelli@broadcom.com,edumazet@google.com,dick.kennedy@broadcom.com,davem@davemloft.net,daniel@zonque.org,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,axboe@kernel.dk,anna-maria@linutronix.de,andrew+netdev@lunn.ch,airlied@gmail.com,agordeev@linux.ibm.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-xe-convert-timeout-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250113042249.07FA2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/xe: convert timeout to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     drm-xe-convert-timeout-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: drm/xe: convert timeout to secs_to_jiffies()
Date: Tue, 10 Dec 2024 22:02:39 +0000

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

Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-8-ddfefd7e9f2a@linux.microsoft.com
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
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
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/xe/xe_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_device.c~drm-xe-convert-timeout-to-secs_to_jiffies
+++ a/drivers/gpu/drm/xe/xe_device.c
@@ -514,7 +514,7 @@ static int wait_for_lmem_ready(struct xe
 	drm_dbg(&xe->drm, "Waiting for lmem initialization\n");
 
 	start = jiffies;
-	timeout = start + msecs_to_jiffies(60 * 1000); /* 60 sec! */
+	timeout = start + secs_to_jiffies(60); /* 60 sec! */
 
 	do {
 		if (signal_pending(current))
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


