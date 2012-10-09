From: akpm@linux-foundation.org
Subject: [merged] memorytxt-remove-stray-information.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:52 -0700
Message-ID: <20121009181352.9F9A7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55090 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2JISNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:53 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so662562vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory.txt: remove stray information
has been removed from the -mm tree.  Its filename was
     memorytxt-remove-stray-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: memory.txt: remove stray information

Andi removed some outedated documentation from Documentation/memory.txt
back in 2009 by 3b2b9a875dd ("Documentation/memory.txt: remove some very
outdated recommendations"), but the resulting document is not in a nice
shape either.

It seems to me like we are not losing anything by completely removing the
file now.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory.txt |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff -puN Documentation/memory.txt~memorytxt-remove-stray-information /dev/null
--- a/Documentation/memory.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-There are several classic problems related to memory on Linux
-systems.
-
-	1) There are some motherboards that will not cache above
-	   a certain quantity of memory.  If you have one of these
-	   motherboards, your system will be SLOWER, not faster
-	   as you add more memory.  Consider exchanging your 
-           motherboard.
-
-All of these problems can be addressed with the "mem=XXXM" boot option
-(where XXX is the size of RAM to use in megabytes).  
-It can also tell Linux to use less memory than is actually installed.
-If you use "mem=" on a machine with PCI, consider using "memmap=" to avoid
-physical address space collisions.
-
-See the documentation of your boot loader (LILO, grub, loadlin, etc.) about
-how to pass options to the kernel.
-
-There are other memory problems which Linux cannot deal with.  Random
-corruption of memory is usually a sign of serious hardware trouble.
-Try:
-
-	* Reducing memory settings in the BIOS to the most conservative 
-          timings.
-
-	* Adding a cooling fan.
-
-	* Not overclocking your CPU.
