From: akpm@linux-foundation.org
Subject: + sysctl-fix-null-checking-in-bin_dn_node_address.patch added to -mm tree
Date: Wed, 23 Jan 2013 14:05:48 -0800
Message-ID: <20130123220548.996515A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48324 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AWWFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 17:05:49 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so908949vbi.3
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 14:05:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, ebiederm@xmission.com, stable@vger.kernel.org


The patch titled
     Subject: sysctl: fix null checking in bin_dn_node_address()
has been added to the -mm tree.  Its filename is
     sysctl-fix-null-checking-in-bin_dn_node_address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: sysctl: fix null checking in bin_dn_node_address()

The null check of `strchr() + 1' is broken, which is always non-null,
leading to OOB read.  Instead, check the result of strchr().

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl_binary.c~sysctl-fix-null-checking-in-bin_dn_node_address kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-fix-null-checking-in-bin_dn_node_address
+++ a/kernel/sysctl_binary.c
@@ -1194,9 +1194,10 @@ static ssize_t bin_dn_node_address(struc
 
 		/* Convert the decnet address to binary */
 		result = -EIO;
-		nodep = strchr(buf, '.') + 1;
+		nodep = strchr(buf, '.');
 		if (!nodep)
 			goto out;
+		++nodep;
 
 		area = simple_strtoul(buf, NULL, 10);
 		node = simple_strtoul(nodep, NULL, 10);
_

Patches currently in -mm which might be from xi.wang@gmail.com are

drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
sysctl-fix-null-checking-in-bin_dn_node_address.patch

