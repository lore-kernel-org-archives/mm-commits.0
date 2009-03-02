From: akpm@linux-foundation.org
Subject: + acpi-check-for-pxm_to_node_map-overflow.patch added to -mm tree
Date: Mon, 02 Mar 2009 12:36:33 -0800
Message-ID: <200903022036.n22KaXVY019857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbZCBUhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 15:37:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@openvz.org, lenb@kernel.org


The patch titled
     acpi: check for pxm_to_node_map overflow
has been added to the -mm tree.  Its filename is
     acpi-check-for-pxm_to_node_map-overflow.patch

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
Subject: acpi: check for pxm_to_node_map overflow
From: Cyrill Gorcunov <gorcunov@gmail.com>

It is hardly (if ever) possible but in case of broken _PXM entry we could
reach out of pxm_to_node_map array bounds in acpi_map_pxm_to_node() call.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/numa.c~acpi-check-for-pxm_to_node_map-overflow drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-check-for-pxm_to_node_map-overflow
+++ a/drivers/acpi/numa.c
@@ -277,7 +277,7 @@ int acpi_get_node(acpi_handle *handle)
 	int pxm, node = -1;
 
 	pxm = acpi_get_pxm(handle);
-	if (pxm >= 0)
+	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
 		node = acpi_map_pxm_to_node(pxm);
 
 	return node;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

linux-next.patch
acpi-check-for-pxm_to_node_map-overflow.patch
mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch
oom_kill-dont-call-for-int_sqrt0.patch
introduce-pr_cont-macro.patch

