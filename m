From: akpm@linux-foundation.org
Subject: - missing-null-termination-in-one-wire-uevent.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:42:42 -0700
Message-ID: <200709270142.l8R1ggPh013895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbXI0Bm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     missing null termination in one wire uevent
has been removed from the -mm tree.  Its filename was
     missing-null-termination-in-one-wire-uevent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: missing null termination in one wire uevent
From: Stephen Hemminger <shemminger@linux-foundation.org>

Need to null terminate environment.  Found by inspection while looking for
similar problems to platform uevent bug

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/w1.c~missing-null-termination-in-one-wire-uevent drivers/w1/w1.c
--- a/drivers/w1/w1.c~missing-null-termination-in-one-wire-uevent
+++ a/drivers/w1/w1.c
@@ -431,6 +431,7 @@ static int w1_uevent(struct device *dev,
 	err = add_uevent_var(envp, num_envp, &cur_index, buffer, buffer_size,
 			&cur_len, "W1_SLAVE_ID=%024LX",
 			(unsigned long long)sl->reg_num.id);
+	envp[cur_index] = NULL;
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
