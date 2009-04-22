From: akpm@linux-foundation.org
Subject: [merged] sgi-xp-sgi-gru-allow-modules-to-load-on-non-uv-systems.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:46 -0700
Message-ID: <200904221830.n3MIUkas006364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbZDVStw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp/sgi-gru: allow modules to load on non-uv systems
has been removed from the -mm tree.  Its filename was
     sgi-xp-sgi-gru-allow-modules-to-load-on-non-uv-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp/sgi-gru: allow modules to load on non-uv systems
From: Robin Holt <holt@sgi.com>

For an upcoming distro release, we need to have the xp kernel module
loadable even when not on UV equipment.  The xpc module will not load. 
This will allow one set of modules dependent upon xp to work on either UV
or non-UV equipment.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    2 +-
 drivers/misc/sgi-xp/xp_main.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~sgi-xp-sgi-gru-allow-modules-to-load-on-non-uv-systems drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-xp-sgi-gru-allow-modules-to-load-on-non-uv-systems
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -375,7 +375,7 @@ static int __init gru_init(void)
 	void *gru_start_vaddr;
 
 	if (!is_uv_system())
-		return -ENODEV;
+		return 0;
 
 #if defined CONFIG_IA64
 	gru_start_paddr = 0xd000000000UL; /* ZZZZZZZZZZZZZZZZZZZ fixme */
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-sgi-gru-allow-modules-to-load-on-non-uv-systems drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-sgi-gru-allow-modules-to-load-on-non-uv-systems
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -248,19 +248,19 @@ xp_init(void)
 	enum xp_retval ret;
 	int ch_number;
 
+	/* initialize the connection registration mutex */
+	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++)
+		mutex_init(&xpc_registrations[ch_number].mutex);
+
 	if (is_shub())
 		ret = xp_init_sn2();
 	else if (is_uv())
 		ret = xp_init_uv();
 	else
-		ret = xpUnsupported;
+		ret = 0;
 
 	if (ret != xpSuccess)
-		return -ENODEV;
