From: akpm@linux-foundation.org
Subject: + documentation-filesystems-proctxt-improve-smaps-field-documentation.patch added to -mm tree
Date: Mon, 23 Aug 2010 15:55:35 -0700
Message-ID: <201008232255.o7NMtZv8019531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab0HWWzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 18:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, knikanth@suse.de


The patch titled
     Documentation/filesystems/proc.txt: improve smaps field documentat=
ion
has been added to the -mm tree.  Its filename is
     documentation-filesystems-proctxt-improve-smaps-field-documentatio=
n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Documentation/filesystems/proc.txt: improve smaps field docume=
ntation
=46rom: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN Documentation/filesystems/proc.txt~documentation-filesystems-=
proctxt-improve-smaps-field-documentation Documentation/filesystems/pro=
c.txt
--- a/Documentation/filesystems/proc.txt~documentation-filesystems-proc=
txt-improve-smaps-field-documentation
+++ a/Documentation/filesystems/proc.txt
@@ -374,13 +374,14 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
=20
-The first  of these lines shows  the same information  as is displayed=
 for the
-mapping in /proc/PID/maps.  The remaining lines show  the size of the =
mapping,
-the amount of the mapping that is currently resident in RAM, the "prop=
ortional
-set size=E2=80=9D (divide each shared page by the number of processes =
sharing it), the
-number of clean and dirty shared pages in the mapping, and the number =
of clean
-and dirty private pages in the mapping.  The "Referenced" indicates th=
e amount
-of memory currently marked as referenced or accessed.
+The first of these lines shows the same information as is displayed
+for the mapping in /proc/PID/maps. The remaining lines show the size
+of the mapping (size), the amount of the mapping that is currently
+resident in RAM (RSS), the process' proportional share of this mapping
+(PSS), the number of clean and dirty shared pages in the mapping, and
+the number of clean and dirty private pages in the mapping. The
+"Referenced" indicates the amount of memory currently marked as
+referenced or accessed.
=20
 This file is only present if the CONFIG_MMU kernel configuration optio=
n is
 enabled.
_

Patches currently in -mm which might be from mpm@selenic.com are

documentation-filesystems-proctxt-improve-smaps-field-documentation.pat=
ch
mm-smaps-export-mlock-information.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
