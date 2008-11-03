From: akpm@linux-foundation.org
Subject: + scripts-improve-the-decodecode-script.patch added to -mm tree
Date: Mon, 03 Nov 2008 14:11:43 -0800
Message-ID: <200811032211.mA3MBhUs029419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbYKCWMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 17:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, sam@ravnborg.org, wangcong@zeuux.org


The patch titled
     scripts: improve the decodecode script
has been added to the -mm tree.  Its filename is
     scripts-improve-the-decodecode-script.patch

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
Subject: scripts: improve the decodecode script
From: Arjan van de Ven <arjan@linux.intel.com>

kerneloops.org has been using an improved "decodecode" script,
specifically it has a special marker that shows which line in the assembly
the oops happened at, like this:

  20:	83 e0 03             	and    $0x3,%eax
  23:	09 d8                	or     %ebx,%eax
  25:	85 db                	test   %ebx,%ebx
  27:	89 02                	mov    %eax,(%edx)
  29:	74 0f                	je     0x3a
  2b:*	3b 73 04             	cmp    0x4(%ebx),%esi     <-- trapping instruction
  2e:	75 05                	jne    0x35
  30:	89 53 04             	mov    %edx,0x4(%ebx)
  33:	eb 07                	jmp    0x3c
  35:	89 53 08             	mov    %edx,0x8(%ebx)

this patch updates the kernel copy to also have this functionality.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff -puN scripts/decodecode~scripts-improve-the-decodecode-script scripts/decodecode
--- a/scripts/decodecode~scripts-improve-the-decodecode-script
+++ a/scripts/decodecode
@@ -7,7 +7,7 @@
 # AFLAGS=--32 decodecode < 386.oops
 
 cleanup() {
-	rm -f $T $T.s $T.o
+	rm -f $T $T.s $T.o $T.oo $T.aa  $T.aaa
 	exit 1
 }
 
@@ -44,21 +44,33 @@ if [ $marker -eq 0 ]; then
 	marker=`expr index "$code" "\("`
 fi
 
+touch $T.oo
 if [ $marker -ne 0 ]; then
-	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
+	echo All code >> $T.oo
+	echo ======== >> $T.oo
+	beforemark=`echo "$code"`
 	echo -n "	.byte 0x" > $T.s
-	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
-	as $AFLAGS -o $T.o $T.s
-	objdump -S $T.o
-	rm $T.o $T.s
+	echo $beforemark | sed -e 's/ /,0x/g' | sed -e 's/<//g' | sed -e 's/>//g' >> $T.s
+	as $AFLAGS -o $T.o $T.s &> /dev/null
+	objdump -S $T.o | grep -v "/tmp" | grep -v "Disassembly" | grep -v "\.text" | grep -v "^$" &> $T.ooo
+	cat $T.ooo >> $T.oo
+	rm -f $T.o $T.s  $T.ooo
 
 # and fix code at-and-after marker
 	code=`echo "$code" | cut -c$((${marker} + 1))-`
 fi
-
+echo Code starting with the faulting instruction  > $T.aa
+echo =========================================== >> $T.aa
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
 echo -n "	.byte 0x" > $T.s
 echo $code >> $T.s
-as $AFLAGS -o $T.o $T.s
-objdump -S $T.o
-rm $T $T.s $T.o
+as $AFLAGS -o $T.o $T.s &> /dev/null
+objdump -S $T.o | grep -v "Disassembly" | grep -v "/tmp" | grep -v "\.text" | grep -v "^$" &> $T.aaa
+cat $T.aaa >> $T.aa
+
+faultline=`cat $T.aaa | head -1 | cut -d":" -f2`
+
+cat $T.oo | sed -e "s/\($faultline\)/\*\1     <-- trapping instruction/g"
+echo
+cat $T.aa
+cleanup
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-use-pci_ioremap_bar-in-drivers-mmc.patch
pci-uninline-pci_ioremap_bar.patch
mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch

