From: akpm@linux-foundation.org
Subject: + proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch added to -mm tree
Date: Mon, 20 Sep 2010 12:19:39 -0700
Message-ID: <201009201919.o8KJJdRx008284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757238Ab0ITTY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 15:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com


The patch titled
     Document the new Anonymous field in smaps
has been added to the -mm tree.  Its filename is
     proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.=
patch

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
Subject: Document the new Anonymous field in smaps
=46rom: Nikanth Karthikesan <knikanth@suse.de>

Document the new Anonymous field in smaps, and also the Swap field.=20
Explain what smaps means by shared and private, which differs from
MAP_SHARED and MAP_PRIVATE.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-pid-smaps-export-amou=
nt-of-anonymous-memory-in-a-mapping-doc Documentation/filesystems/proc.=
txt
--- a/Documentation/filesystems/proc.txt~proc-pid-smaps-export-amount-o=
f-anonymous-memory-in-a-mapping-doc
+++ a/Documentation/filesystems/proc.txt
@@ -370,17 +370,24 @@ Shared_Dirty:          0 kB
 Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
+Anonymous:             0 kB
 Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
=20
-The first  of these lines shows  the same information  as is displayed=
 for the
-mapping in /proc/PID/maps.  The remaining lines show  the size of the =
mapping,
+The first of these lines shows the same information as is displayed fo=
r the
+mapping in /proc/PID/maps. The remaining lines show the size of the ma=
pping,
 the amount of the mapping that is currently resident in RAM, the "prop=
ortional
 set size=E2=80=9D (divide each shared page by the number of processes =
sharing it), the
 number of clean and dirty shared pages in the mapping, and the number =
of clean
-and dirty private pages in the mapping.  The "Referenced" indicates th=
e amount
-of memory currently marked as referenced or accessed.
+and dirty private pages in the mapping. Note that even a page which is=
 part of
+a MAP_SHARED mapping, but has only a single pte mapped, i.e. is curren=
tly used
+by only one process, is accounted as private and not as shared. "Refer=
enced"
+indicates the amount of memory currently marked as referenced or acces=
sed.
+"Anonymous" shows the amount of memory that does not belong to any fil=
e. Even
+a mapping associated with a file may contain anonymous pages: when MAP=
_PRIVATE
+and a page is modified, the file page is replaced by a private anonymo=
us copy.
+"Swap" shows how much would-be-anonymous memory is also used, but out =
on swap.
=20
 This file is only present if the CONFIG_MMU kernel configuration optio=
n is
 enabled.
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.pat=
ch
mm-smaps-export-mlock-information.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
