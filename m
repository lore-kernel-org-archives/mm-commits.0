Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46348C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2CDA22254
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708960;
	bh=3y1hUpYFvV2C/v4ELY9PKOwuUnqxU75xXyWF0uNrwXI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WaVyWy7UO+ksgQSYvx1rKKBTs54COoZWgF4uYTJDUXeyemRVGa7MePOoXUliS2G/3
	 EseGt5cgiXYpj8UzfQPTi3e+n8YTgAioZrNbApIXiq+r5EKuUNO8uI+83hlKQmsiA3
	 KumcJ2KcSJE8oM00s54V4d4lBWXXSPBNg7XjzWVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgJNUz7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNUz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE1132224E;
        Wed, 14 Oct 2020 20:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708959;
        bh=3y1hUpYFvV2C/v4ELY9PKOwuUnqxU75xXyWF0uNrwXI=;
        h=Date:From:To:Subject:From;
        b=e6GmjZbJ6g9Gs4sapwDlJDXhrqi1gtqLns9jvkZuJF7mHzXhNAD471QavnKuXoS1R
         Lbl7tJ+fWmXVcWtDV1ekwK96ERjMBWuavPlxfd3HX+6vzPN1zH/Bai4CU6FlHqYKbj
         v+tRQFkygrSf+zibwLPA1erq2f+aHexHCRxesNls=
Date:   Wed, 14 Oct 2020 13:55:58 -0700
From:   akpm@linux-foundation.org
To:     bp@suse.de, maz@misterjones.org, mm-commits@vger.kernel.org,
        rabin@rab.in, will@kernel.org
Subject:  [merged]
 scripts-decodecode-add-the-capability-to-supply-the-program-counter.patch
 removed from -mm tree
Message-ID: <20201014205558.jX62J-reJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: add the capability to supply the program counter
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-add-the-capability-to-supply-the-program-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: scripts/decodecode: add the capability to supply the program counter

So that comparing with objdump output from vmlinux can ease pinpointing
where the trapping instruction actually is.  An example is better than a
thousand words:

  $ PC=0xffffffff8329a927 ./scripts/decodecode < ~/tmp/syz/gfs2.splat
  [ 477.379104][T23917] Code: 48 83 ec 28 48 89 3c 24 48 89 54 24 08 e8 c1 b4 4a fe 48 8d bb 00 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 97 05 00 00 48 8b 9b 00 01 00 00 48 85 db 0f 84
  All code
  ========
  ffffffff8329a8fd:       48 83 ec 28             sub    $0x28,%rsp
  ffffffff8329a901:       48 89 3c 24             mov    %rdi,(%rsp)
  ffffffff8329a905:       48 89 54 24 08          mov    %rdx,0x8(%rsp)
  ffffffff8329a90a:       e8 c1 b4 4a fe          callq  0xffffffff81745dd0
  ffffffff8329a90f:       48 8d bb 00 01 00 00    lea    0x100(%rbx),%rdi
  ffffffff8329a916:       48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
  ffffffff8329a91d:       fc ff df
  ffffffff8329a920:       48 89 fa                mov    %rdi,%rdx
  ffffffff8329a923:       48 c1 ea 03             shr    $0x3,%rdx
  ffffffff8329a927:*      80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)               <-- trapping instruction
  ffffffff8329a92b:       0f 85 97 05 00 00       jne    0xffffffff8329aec8
  ffffffff8329a931:       48 8b 9b 00 01 00 00    mov    0x100(%rbx),%rbx
  ffffffff8329a938:       48 85 db                test   %rbx,%rbx
  ffffffff8329a93b:       0f                      .byte 0xf
  ffffffff8329a93c:       84                      .byte 0x84

Link: https://lkml.kernel.org/r/20200930111416.GF6810@zn.tnic
Link: https://lkml.kernel.org/r/20200929113238.GC21110@zn.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Will Deacon <will@kernel.org>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/scripts/decodecode~scripts-decodecode-add-the-capability-to-supply-the-program-counter
+++ a/scripts/decodecode
@@ -6,6 +6,7 @@
 # options: set env. variable AFLAGS=options to pass options to "as";
 # e.g., to decode an i386 oops on an x86_64 system, use:
 # AFLAGS=--32 decodecode < 386.oops
+# PC=hex - the PC (program counter) the oops points to
 
 cleanup() {
 	rm -f $T $T.s $T.o $T.oo $T.aa $T.dis
@@ -67,15 +68,19 @@ if [ -z "$ARCH" ]; then
     esac
 fi
 
+# Params: (tmp_file, pc_sub)
 disas() {
-	${CROSS_COMPILE}as $AFLAGS -o $1.o $1.s > /dev/null 2>&1
+	t=$1
+	pc_sub=$2
+
+	${CROSS_COMPILE}as $AFLAGS -o $t.o $t.s > /dev/null 2>&1
 
 	if [ "$ARCH" = "arm" ]; then
 		if [ $width -eq 2 ]; then
 			OBJDUMPFLAGS="-M force-thumb"
 		fi
 
-		${CROSS_COMPILE}strip $1.o
+		${CROSS_COMPILE}strip $t.o
 	fi
 
 	if [ "$ARCH" = "arm64" ]; then
@@ -83,11 +88,18 @@ disas() {
 			type=inst
 		fi
 
-		${CROSS_COMPILE}strip $1.o
+		${CROSS_COMPILE}strip $t.o
 	fi
 
-	${CROSS_COMPILE}objdump $OBJDUMPFLAGS -S $1.o | \
-		grep -v "/tmp\|Disassembly\|\.text\|^$" > $1.dis 2>&1
+	if [ $pc_sub -ne 0 ]; then
+		if [ $PC ]; then
+			adj_vma=$(( $PC - $pc_sub ))
+			OBJDUMPFLAGS="$OBJDUMPFLAGS --adjust-vma=$adj_vma"
+		fi
+	fi
+
+	${CROSS_COMPILE}objdump $OBJDUMPFLAGS -S $t.o | \
+		grep -v "/tmp\|Disassembly\|\.text\|^$" > $t.dis 2>&1
 }
 
 marker=`expr index "$code" "\<"`
@@ -95,14 +107,17 @@ if [ $marker -eq 0 ]; then
 	marker=`expr index "$code" "\("`
 fi
 
+
 touch $T.oo
 if [ $marker -ne 0 ]; then
+	# 2 opcode bytes and a single space
+	pc_sub=$(( $marker / 3 ))
 	echo All code >> $T.oo
 	echo ======== >> $T.oo
 	beforemark=`echo "$code"`
 	echo -n "	.$type 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g; s/[<>()]//g' >> $T.s
-	disas $T
+	disas $T $pc_sub
 	cat $T.dis >> $T.oo
 	rm -f $T.o $T.s $T.dis
 
@@ -114,7 +129,7 @@ echo ===================================
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g; s/[>)]$//'`
 echo -n "	.$type 0x" > $T.s
 echo $code >> $T.s
-disas $T
+disas $T 0
 cat $T.dis >> $T.aa
 
 # (lines of whole $T.oo) - (lines of $T.aa, i.e. "Code starting") + 3,
_

Patches currently in -mm which might be from bp@suse.de are


