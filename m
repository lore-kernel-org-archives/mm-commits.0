From: akpm@linux-foundation.org
Subject: + scripts-decodecode-remove-bashisms.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:52:25 -0700
Message-ID: <201006042252.o54MqPR3023059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab0FDWx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin@rab.in, mmarek@suse.cz, randy.dunlap@oracle.com


The patch titled
     scripts: decodecode: remove bashisms
has been added to the -mm tree.  Its filename is
     scripts-decodecode-remove-bashisms.patch

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
Subject: scripts: decodecode: remove bashisms
From: Rabin Vincent <rabin@rab.in>

Remove bashisms to make scripts/decodecode work with other shells.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN scripts/decodecode~scripts-decodecode-remove-bashisms scripts/decodecode
--- a/scripts/decodecode~scripts-decodecode-remove-bashisms
+++ a/scripts/decodecode
@@ -40,7 +40,7 @@ echo $code
 code=`echo $code | sed -e 's/.*Code: //'`
 
 width=`expr index "$code" ' '`
-width=$[($width-1)/2]
+width=$((($width-1)/2))
 case $width in
 1) type=byte ;;
 2) type=2byte ;;
@@ -48,10 +48,10 @@ case $width in
 esac
 
 disas() {
-	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s &> /dev/null
+	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s > /dev/null 2>&1
 
-	if [ "$ARCH" == "arm" ]; then
-		if [ $width == 2 ]; then
+	if [ "$ARCH" = "arm" ]; then
+		if [ $width -eq 2 ]; then
 			OBJDUMPFLAGS="-M force-thumb"
 		fi
 
@@ -59,7 +59,7 @@ disas() {
 	fi
 
 	${CROSS_COMPILE}objdump $OBJDUMPFLAGS -S $1.o | \
-		grep -v "/tmp\|Disassembly\|\.text\|^$" &> $1.dis
+		grep -v "/tmp\|Disassembly\|\.text\|^$" > $1.dis 2>&1
 }
 
 marker=`expr index "$code" "\<"`
_

Patches currently in -mm which might be from rabin@rab.in are

origin.patch
scripts-decodecode-remove-bashisms.patch

