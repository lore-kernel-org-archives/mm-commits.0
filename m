Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86394218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189569; cv=none; b=SQu/F0lQX8f2BXdj500UTpe/VD1c3Mf4fA91s7p27Gx2HdnAk7uXdrtS0s/KP8bRXk6YXrlLWFThHdhLvhoI3sst09Bxp5fa0NEJcRF+F42VE2qKSeu+PJz7k3OoW/cgqnJvKE92QwnznZ/IPHXpnVsafW10VUollmi4Ua5+nSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189569; c=relaxed/simple;
	bh=S54DfymByKwjrkXAWPZLXmSE0Qi9+FpHTpOYapwoiLg=;
	h=Date:To:From:Subject:Message-Id; b=RKfPVt7zQeNnIfizeddjqzS1/U8gJ+kkz2/dZqKyEOvn/J5hMBsEtBEFQI5isi0/ft919sh0tm8o+OeR+bOvUWpEi3Hk89MB72T9BfYK7AJ65nERW0HfkjcL5VMlnaOa5gAzQgXvZ8fdRnI9GUl+UhtjJZW9yr7kClaWZx73+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mad0SDS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mad0SDS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAC7C4CEEC;
	Mon, 17 Mar 2025 05:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189569;
	bh=S54DfymByKwjrkXAWPZLXmSE0Qi9+FpHTpOYapwoiLg=;
	h=Date:To:From:Subject:From;
	b=mad0SDS7fUrmgaEOmNcrOqwPXWuAqMiXcJGlQzwUrQU4/vpOFMhb4Cp8NTAc2MEsC
	 krHMWleW/FM0Ps81qDjohqX96ka8hRviDssYgfbUNQDKqjuZPJsXQWJlY+KZzf55aD
	 vDJoW7U6tVvKd8Sgefh6nWXURC0MENlUTrlxa/g4=
Date: Sun, 16 Mar 2025 22:32:48 -0700
To: mm-commits@vger.kernel.org,linux@weissschuh.net,kbingham@kernel.org,jan.kiszka@siemens.com,antonio@mandelbit.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs.patch removed from -mm tree
Message-Id: <20250317053249.5BAC7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/linux/symbols.py: address changes to module_sect_attrs
has been removed from the -mm tree.  Its filename was
     scripts-gdb-linux-symbolspy-address-changes-to-module_sect_attrs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


