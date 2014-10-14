From: akpm@linux-foundation.org
Subject: [merged] ib_srpt-replace-strnicmp-with-strncasecmp.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:22:22 -0700
Message-ID: <543d69de.QtwIGew4R2gKKAZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaJNSWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, nab@linux-iscsi.org, roland@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ib_srpt: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     ib_srpt-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: ib_srpt: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Roland Dreier <roland@kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/ulp/srpt/ib_srpt.c~ib_srpt-replace-strnicmp-with-strncasecmp drivers/infiniband/ulp/srpt/ib_srpt.c
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c~ib_srpt-replace-strnicmp-with-strncasecmp
+++ a/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3574,7 +3574,7 @@ static int srpt_parse_i_port_id(u8 i_por
 	int ret, rc;
 
 	p = name;
-	if (strnicmp(p, "0x", 2) == 0)
+	if (strncasecmp(p, "0x", 2) == 0)
 		p += 2;
 	ret = -EINVAL;
 	len = strlen(p);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

