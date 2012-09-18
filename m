From: akpm@linux-foundation.org
Subject: + memorytxt-remove-stray-information.patch added to -mm tree
Date: Tue, 18 Sep 2012 14:50:58 -0700
Message-ID: <20120918215059.008625C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47461 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2IRVvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 17:51:00 -0400
Received: by wibhr14 with SMTP id hr14so14132wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 14:50:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     Subject: memory.txt: remove stray information
has been added to the -mm tree.  Its filename is
     memorytxt-remove-stray-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
