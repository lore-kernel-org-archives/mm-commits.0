Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F932CCC0
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742154; cv=none; b=u46ofc0aoPEIslAMeBT/DrbgYsME6ywvmkLWFXM+ATgZ63Sq83L/43P1Rb8lja9G8M5HBig5DyjIVIzyIgLy7188ILe69PvzsZd9seY/aSjUPypYg/z8E2MXAh7GbM3Po7YZxgj+2uJF+tTGbvrX/APN/Ia+0P05rw4ybKFIrUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742154; c=relaxed/simple;
	bh=/LGq/VWcUFTYCmQlwL109ie9ZMsFKYXPxFDBS5GaQ8A=;
	h=Date:To:From:Subject:Message-Id; b=bQ9pDgrMgrtv2MaDDA5Psp1Yi6q0nSCc9cZMB7tiYY75hOPTl9hxUyvdno3VNzq6ecQvsczpa9GsA3d1SnUcUeC+A8dx1fbpmnKDTQyLD1MSyB06gYprgBvhWLx9ZJjqeercEEjhr6PpIb6D28/4I8kqpa5Si6jRE1b+2R/x3uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RGWvQQWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RGWvQQWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0773C4CED6;
	Mon, 13 Jan 2025 04:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742154;
	bh=/LGq/VWcUFTYCmQlwL109ie9ZMsFKYXPxFDBS5GaQ8A=;
	h=Date:To:From:Subject:From;
	b=RGWvQQWVNEBjGgNdGqjuhchCtz/FggFrGhXDGPCDOgVJc9JTQ0wq9W58oLqUCdzro
	 o/cR+sCild4d1elS/PZM/WHrBK+byVUradmk31z54hLqfUzNliWK97xqc20jPzPDsw
	 agJA/zWmGGC/YJTZtw4+vv8u1l1R0Fye3VrlkwL8=
Date: Sun, 12 Jan 2025 20:22:33 -0800
To: mm-commits@vger.kernel.org,xiubli@redhat.com,tzimmermann@suse.de,tiwai@suse.com,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,simona@ffwll.ch,shailend@google.com,sbranden@broadcom.com,roger.pau@citrix.com,rodrigo.vivi@intel.com,robert.jarzmik@free.fr,rjui@broadcom.com,quic_jjohnson@quicinc.com,pmladek@suse.com,pkaligineedi@google.com,perex@perex.cz,pablo@netfilter.org,pabeni@redhat.com,ogabbay@kernel.org,obitton@habana.ai,npiggin@gmail.com,nicolas.palix@imag.fr,naveen@kernel.org,mripard@kernel.org,mpe@ellerman.id.au,mbenes@suse.cz,martin.petersen@oracle.com,marcel@holtmann.org,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,luiz.dentz@gmail.com,lucas.demarchi@intel.com,louis.peens@corigine.com,linux@armlinux.org.uk,kvalo@kernel.org,kuba@kernel.org,kadlec@netfilter.org,julia.lawall@inria.fr,jpoimboe@kernel.org,johan.hedberg@gmail.com,joe.lawrence@redhat.com,jjohnson@kernel.org,jinpu.wang@cloud.ionos.com,jikos@kernel.org,jeroendb@google.com,james.smart@broadcom.com,James.Bottomley@HansenPartnership.com,idryomov@gmail.com,horms@kernel.org,hca@linux.ibm.com,haojian.zhuang@gmail.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,florian.fainelli@broadcom.com,edumazet@google.com,dick.kennedy@broadcom.com,davem@davemloft.net,daniel@zonque.org,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,axboe@kernel.dk,anna-maria@linutronix.de,andrew+netdev@lunn.ch,airlied@gmail.com,agordeev@linux.ibm.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] netfilter-conntrack-cleanup-timeout-definitions.patch removed from -mm tree
Message-Id: <20250113042233.F0773C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: netfilter: conntrack: cleanup timeout definitions
has been removed from the -mm tree.  Its filename was
     netfilter-conntrack-cleanup-timeout-definitions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: netfilter: conntrack: cleanup timeout definitions
Date: Tue, 10 Dec 2024 22:02:32 +0000

Patch series "Converge on using secs_to_jiffies()", v3.

This is a series that follows up on my previous series to introduce
secs_to_jiffies() and convert a few initial users.[1] In the review for
that series, Anna-Maria requested converting other users with Coccinelle. 
[2] This is part 1 that converts users of msecs_to_jiffies() that use the
multiply pattern of either of:

- msecs_to_jiffies(N*1000), or
- msecs_to_jiffies(N*MSEC_PER_SEC)

where N is a constant, to avoid the multiplication.

The entire conversion is made with Coccinelle in the script added in
patch 2. Some changes suggested by Coccinelle have been deferred to
later parts that will address other possible variant patterns.

[1] https://lore.kernel.org/all/20241030-open-coded-timeouts-v3-0-9ba123facf88@linux.microsoft.com/
[2] https://lore.kernel.org/all/8734kngfni.fsf@somnus/


This patch (of 19):

None of the higher order definitions are used anymore, so remove
definitions for minutes, hours, and days timeouts.  Convert the seconds
denominated timeouts to secs_to_jiffies()

Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com
Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-1-ddfefd7e9f2a@linux.microsoft.com
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
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>:
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marcel Holtmann <marcel@holtmann.org>:
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
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_proto_sctp.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_sctp.c~netfilter-conntrack-cleanup-timeout-definitions
+++ a/net/netfilter/nf_conntrack_proto_sctp.c
@@ -39,20 +39,15 @@ static const char *const sctp_conntrack_
 	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= "HEARTBEAT_SENT",
 };
 
-#define SECS  * HZ
-#define MINS  * 60 SECS
-#define HOURS * 60 MINS
-#define DAYS  * 24 HOURS
-
 static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
-	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
-	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
-	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
-	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
-	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 3 SECS,
-	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 3 SECS,
-	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
-	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
+	[SCTP_CONNTRACK_CLOSED]			= secs_to_jiffies(10),
+	[SCTP_CONNTRACK_COOKIE_WAIT]		= secs_to_jiffies(3),
+	[SCTP_CONNTRACK_COOKIE_ECHOED]		= secs_to_jiffies(3),
+	[SCTP_CONNTRACK_ESTABLISHED]		= secs_to_jiffies(210),
+	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= secs_to_jiffies(3),
+	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= secs_to_jiffies(3),
+	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= secs_to_jiffies(3),
+	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= secs_to_jiffies(30),
 };
 
 #define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are


