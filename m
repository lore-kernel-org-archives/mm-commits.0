From: akpm@linux-foundation.org
Subject: + drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch added to -mm tree
Date: Wed, 13 Jan 2010 12:54:39 -0800
Message-ID: <201001132054.o0DKsdC3027886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717Ab0AMUz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 15:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, James.Bottomley@HansenPartnership.com, ketuzsezr@darnok.org, michaelc@cs.wisc.edu, pjones@redhat.com


The patch titled
     drivers/firmware/iscsi_ibft.c: remove NIPQUAD_FMT, use %pI4
has been added to the -mm tree.  Its filename is
     drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/firmware/iscsi_ibft.c: remove NIPQUAD_FMT, use %pI4
From: Joe Perches <joe@perches.com>

Convert netmask to __be32 and format it with %pI4

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Konrad Rzeszutek <ketuzsezr@darnok.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/firmware/iscsi_ibft.c~drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4 drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4
+++ a/drivers/firmware/iscsi_ibft.c
@@ -380,7 +380,7 @@ static ssize_t ibft_attr_show_nic(struct
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
 	char *str = buf;
-	int val;
+	__be32 val;
 
 	if (!nic)
 		return 0;
@@ -396,10 +396,8 @@ static ssize_t ibft_attr_show_nic(struct
 		str += sprintf_ipaddr(str, nic->ip_addr);
 		break;
 	case ibft_eth_subnet_mask:
-		val = ~((1 << (32-nic->subnet_mask_prefix))-1);
-		str += sprintf(str, NIPQUAD_FMT,
-			       (u8)(val >> 24), (u8)(val >> 16),
-			       (u8)(val >> 8), (u8)(val));
+		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
+		str += sprintf(str, "%pI4", &val);
 		break;
 	case ibft_eth_origin:
 		str += sprintf(str, "%d\n", nic->origin);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch

