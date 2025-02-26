Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CAB20D4F3
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 05:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740548918; cv=none; b=BIvpEyLOvCQn0GYNhwJS6qX7vRoe5t1WQoa3GtYSoLzWyDNUr0hfKtt3Uc3S+rxPlDaiXo/kWtsUyorPhb+1quLxAESrxSs51eZSyNoWUO2/XyaVznQVv9w7A7gq3oFvK7mm/+mWngX+xvhQtObzdhuHdxDXYhspkwybdGHlUKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740548918; c=relaxed/simple;
	bh=sMeM0bsF2FWjHfszyNJV424mpU5Q289UOp+CM1sYo1Y=;
	h=Date:To:From:Subject:Message-Id; b=gzlvcKYSNuvt2l5AhDEA7lMbthQqUmhQKLzGqTUYvzbirzTRPgHLzHLHcrKQoZDQisxZreZ+/IAGXh3q9kOIIzPulOTrZvpdueQVPQ+RAW4PSvKOnufG0l9nuRRJ6IGp5EV4IsNSAOsMKOntZBsReJu022ATsgnC+Tmaxid1Fp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17e8PcID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17e8PcID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5924C4CED6;
	Wed, 26 Feb 2025 05:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740548917;
	bh=sMeM0bsF2FWjHfszyNJV424mpU5Q289UOp+CM1sYo1Y=;
	h=Date:To:From:Subject:From;
	b=17e8PcIDOti5wy3nEOl2ts2XNPaaeGKcXzV8ngWrAW/KNKgBfYLgp52wjpSyXQJqw
	 +d/whZaUmwcZfx6ADK8qfdc9X1LQTVccQ5bQeu79AG8iYExZKLikhL+h12sWBFPWsK
	 pn/h/PXZEsw5XjoK6JNCag0B3XmzvGnCnVE767Yo=
Date: Tue, 25 Feb 2025 21:48:37 -0800
To: mm-commits@vger.kernel.org,linux@weissschuh.net,kbingham@kernel.org,jan.kiszka@siemens.com,antonio@mandelbit.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs.patch added to mm-nonmm-unstable branch
Message-Id: <20250226054837.A5924C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/linux/symbols.py: address changes to module_sect_attrs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Antonio Quartulli <antonio@mandelbit.com>
Subject: scripts/gdb/linux/symbols.py: address changes to module_sect_attrs
Date: Fri, 21 Feb 2025 21:40:34 +0100

When loading symbols from kernel modules we used to iterate
from 0 to module_sect_attrs::nsections, in order to
retrieve their name and address.

However module_sect_attrs::nsections has been removed from
the struct by a previous commit.

Re-arrange the iteration by accessing all items in
module_sect_attrs::grp::bin_attrs[] until NULL is found
(it's a NULL terminated array).

At the same time the symbol address cannot be extracted
from module_sect_attrs::attrs[]::address anymore because
it has also been deleted. Fetch it from
module_sect_attrs::grp::bin_attrs[]::private as described
in 4b2c11e4aaf7.

Link: https://lkml.kernel.org/r/20250221204034.4430-1-antonio@mandelbit.com
Fixes: d8959b947a8d ("module: sysfs: Drop member 'module_sect_attrs::nsections'")
Fixes: 4b2c11e4aaf7 ("module: sysfs: Drop member 'module_sect_attr::address'")
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs
+++ a/scripts/gdb/linux/symbols.py
@@ -15,6 +15,7 @@ import gdb
 import os
 import re
 
+from itertools import count
 from linux import modules, utils, constants
 
 
@@ -95,10 +96,14 @@ lx-symbols command."""
         except gdb.error:
             return str(module_addr)
 
-        attrs = sect_attrs['attrs']
-        section_name_to_address = {
-            attrs[n]['battr']['attr']['name'].string(): attrs[n]['address']
-            for n in range(int(sect_attrs['nsections']))}
+        section_name_to_address = {}
+        for i in count():
+            # this is a NULL terminated array
+            if sect_attrs['grp']['bin_attrs'][i] == 0x0:
+                break
+
+            attr = sect_attrs['grp']['bin_attrs'][i].dereference()
+            section_name_to_address[attr['attr']['name'].string()] = attr['private']
 
         textaddr = section_name_to_address.get(".text", module_addr)
         args = []
_

Patches currently in -mm which might be from antonio@mandelbit.com are

scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs.patch

