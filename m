From: akpm@linux-foundation.org
Subject: + memblock-add-no_bootmem-config-symbol.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:58:27 -0700
Message-ID: <201108232058.p7NKwRoX006191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab1HWU6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, hpa@zytor.com, tj@kernel.org, yinghai@kernel.org


The patch titled
     memblock: add NO_BOOTMEM config symbol
has been added to the -mm tree.  Its filename is
     memblock-add-no_bootmem-config-symbol.patch

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
Subject: memblock: add NO_BOOTMEM config symbol
From: Sam Ravnborg <sam@ravnborg.org>

With the NO_BOOTMEM symbol added architectures may now use the following
syntax to tell that they do not need bootmem:

	select NO_BOOTMEM

This is much more convinient than adding a new kconfig symbol which was
otherwise required.

Adding this symbol does not conflict with the architctures that already
define their own symbol.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/Kconfig~memblock-add-no_bootmem-config-symbol mm/Kconfig
--- a/mm/Kconfig~memblock-add-no_bootmem-config-symbol
+++ a/mm/Kconfig
@@ -131,6 +131,9 @@ config SPARSEMEM_VMEMMAP
 config HAVE_MEMBLOCK
 	boolean
 
+config NO_BOOTMEM
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
_

Patches currently in -mm which might be from sam@ravnborg.org are

linux-next.patch
memblock-add-no_bootmem-config-symbol.patch

