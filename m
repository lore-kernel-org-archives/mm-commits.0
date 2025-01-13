Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A8615624B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742182; cv=none; b=S0reyXvYym2m/D/LCwHeTg7Wc+M062YNLliGC6kTigmCKitKH/Cj+IYPrF6zlePgdNTQK03z0vZqKEY4znFkxzY7IFKQBqFZWhgX0YLwR1xWdpIhv0X7xjsg9mgCYQUIqSmWb2njPVeRIuMPjqjYRaglyBg/he/OEA+eO3hnuAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742182; c=relaxed/simple;
	bh=5C1uEyeMltFtGrvCgyxW8acSQ5BVNGQA4BDISPbLQn0=;
	h=Date:To:From:Subject:Message-Id; b=qFeSe3norPn9BaChHyc/Rb/Q679GTM9+U9JHc18V2CbyFIMlWmWP5YZ5df5FY+EQBkI1S3646SRVqofbbayPtWlcApXNXZLq5E0j5xdoNxWFb1RpROfj4ic0T9ksmWG1yoWXC+cWvnt33j2wSK8HEKx0j/25rBJiCazBAYXNcWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BjEzeggu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BjEzeggu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393F4C4CED6;
	Mon, 13 Jan 2025 04:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742182;
	bh=5C1uEyeMltFtGrvCgyxW8acSQ5BVNGQA4BDISPbLQn0=;
	h=Date:To:From:Subject:From;
	b=BjEzeggu7s/v0Ccqk9Xe6lqPkwFyeItaIUrJCtqr8zp51a3cU0AXmdFJgppWiCrv9
	 7ZjCwdYLzuiJ49k41OBGBpA3djTuoGCVtjc3XpUdYcYVcV68xFJbh3z6UFxWEhg2hZ
	 vm/AkpDpS00w0h5pVvty9kqP6LdaQFLEL6E9sJRE=
Date: Sun, 12 Jan 2025 20:23:01 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tzimmermann@suse.de,tiwai@suse.com,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,simona@ffwll.ch,shailend@google.com,sbranden@broadcom.com,roger.pau@citrix.com,rodrigo.vivi@intel.com,robert.jarzmik@free.fr,rjui@broadcom.com,quic_jjohnson@quicinc.com,pmladek@suse.com,pkaligineedi@google.com,perex@perex.cz,pablo@netfilter.org,pabeni@redhat.com,ogabbay@kernel.org,obitton@habana.ai,npiggin@gmail.com,nicolas.palix@imag.fr,naveen@kernel.org,mripard@kernel.org,mpe@ellerman.id.au,mbenes@suse.cz,martin.petersen@oracle.com,marcel@holtmann.org,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,luiz.dentz@gmail.com,lucas.demarchi@intel.com,louis.peens@corigine.com,linux@armlinux.org.uk,kvalo@kernel.org,kuba@kernel.org,kadlec@netfilter.org,julia.lawall@inria.fr,jpoimboe@kernel.org,johan.hedberg@gmail.com,joe.lawrence@redhat.com,jjohnson@kernel.org,jinpu.wang@cloud.ionos.com,jikos@kernel.org,jeroendb@google.com,james.smart@broadcom.com,James.Bottomley@HansenPartnership.com,idryomov@gmail.com,horms@kernel.org,hca@linux.ibm.com,haojian.zhuang@gmail.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,florian.fainelli@broadcom.com,edumazet@google.com,dick.kennedy@broadcom.com,davem@davemloft.net,daniel@zonque.org,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,axboe@kernel.dk,anna-maria@linutronix.de,andrew+netdev@lunn.ch,airlied@gmail.com,agordeev@linux.ibm.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] staging-vc04_services-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250113042302.393F4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: staging: vc04_services: convert timeouts to secs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     staging-vc04_services-convert-timeouts-to-secs_to_jiffies.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: staging: vc04_services: convert timeouts to secs_to_jiffies()
Date: Tue, 10 Dec 2024 22:02:47 +0000

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

Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-16-ddfefd7e9f2a@linux.microsoft.com
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

 drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c~staging-vc04_services-convert-timeouts-to-secs_to_jiffies
+++ a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c
@@ -59,7 +59,7 @@ static int bcm2835_audio_send_msg_locked
 
 	if (wait) {
 		if (!wait_for_completion_timeout(&instance->msg_avail_comp,
-						 msecs_to_jiffies(10 * 1000))) {
+						 secs_to_jiffies(10))) {
 			dev_err(instance->dev,
 				"vchi message timeout, msg=%d\n", m->type);
 			return -ETIMEDOUT;
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


