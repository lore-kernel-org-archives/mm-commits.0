Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C845BC00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiHKAp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiHKApZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0FD642F6
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA36661152
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E87C433D6;
        Thu, 11 Aug 2022 00:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660178722;
        bh=AbewYyhdcX6TzLMi7/d5mRH541SL2St+Q+b+bSZzXfE=;
        h=Date:To:From:Subject:From;
        b=NcHDaa5BzN3lR25HCL6XK2x7frUKKDaeiSr5atd42OAehwKm13TO0g6zBponNsxQi
         uYsUa5YBMUm17WP3S/TKtL76FGk681wY9nczKh1B4qNoILflpUk7qSjlW7367Wsajs
         Rtwz28O//A47LnaqgtENn4MdKLxHilz4cYmHuFyY=
Date:   Wed, 10 Aug 2022 17:45:21 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, maz@kernel.org,
        bp@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decodecode-improve-faulting-line-determination.patch added to mm-nonmm-unstable branch
Message-Id: <20220811004522.28E87C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: improve faulting line determination
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decodecode-improve-faulting-line-determination.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decodecode-improve-faulting-line-determination.patch

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
From: Borislav Petkov <bp@suse.de>
Subject: scripts/decodecode: improve faulting line determination
Date: Mon, 8 Aug 2022 10:59:28 +0200

There are cases where the IP pointer in a Code: line in an oops doesn't
point at the beginning of an instruction:

Code: 0f bd c2 e9 a0 cd b5 e4 48 0f bd c2 e9 97 cd b5 e4 0f 1f 80 00 00 00 00 \
	  e9 8b cd b5 e4 0f 1f 00 66 0f a3 d0 e9 7f cd b5 e4 0f 1f <80> 00 00 00 \
	  00 0f a3 d0 e9 70 cd b5 e4 48 0f a3 d0 e9 67 cd b5

  e9 7f cd b5 e4          jmp    0xffffffffe4b5cda8
  0f 1f 80 00 00 00 00    nopl   0x0(%rax)
	^^

and the current way of determining the faulting instruction line doesn't
work because disassembled instructions are counted from the IP byte to
the end and when that thing points in the middle, the trailing bytes can
be interpreted as different insns:

  Code starting with the faulting instruction
  ===========================================
     0:   80 00 00                addb   $0x0,(%rax)
     3:   00 00                   add    %al,(%rax)

whereas, this is part of

0f 1f 80 00 00 00 00    nopl   0x0(%rax)

     5:   0f a3 d0                bt     %edx,%eax
     ...

leading to:

  1d:   0f 1f 00                nopl   (%rax)
  20:   66 0f a3 d0             bt     %dx,%ax
  24:*  e9 7f cd b5 e4          jmp    0xffffffffe4b5cda8               <-- trapping instruction
  29:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
  30:   0f a3 d0                bt     %edx,%eax

which is the wrong faulting instruction.

Change the way the faulting line number is determined by matching the
opcode bytes from the beginning, leading to correct output:

  1d:   0f 1f 00                nopl   (%rax)
  20:   66 0f a3 d0             bt     %dx,%ax
  24:   e9 7f cd b5 e4          jmp    0xffffffffe4b5cda8
  29:*  0f 1f 80 00 00 00 00    nopl   0x0(%rax)                <-- trapping instruction
  30:   0f a3 d0                bt     %edx,%eax

While at it, make decodecode use bash as the interpreter - that thing
should be present on everything by now. It simplifies the code a lot
too.

Link: https://lkml.kernel.org/r/20220808085928.29840-1-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |  120 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 105 insertions(+), 15 deletions(-)

--- a/scripts/decodecode~scripts-decodecode-improve-faulting-line-determination
+++ a/scripts/decodecode
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 # Disassemble the Code: line in Linux oopses
 # usage: decodecode < oops.file
@@ -8,6 +8,8 @@
 # AFLAGS=--32 decodecode < 386.oops
 # PC=hex - the PC (program counter) the oops points to
 
+faultlinenum=1
+
 cleanup() {
 	rm -f $T $T.s $T.o $T.oo $T.aa $T.dis
 	exit 1
@@ -102,28 +104,125 @@ disas() {
 		grep -v "/tmp\|Disassembly\|\.text\|^$" > $t.dis 2>&1
 }
 
+# Match the maximum number of opcode bytes from @op_bytes contained within
+# @opline
+#
+# Params:
+# @op_bytes: The string of bytes from the Code: line
+# @opline: The disassembled line coming from objdump
+#
+# Returns:
+# The max number of opcode bytes from the beginning of @op_bytes which match
+# the opcode bytes in the objdump line.
+get_substr_opcode_bytes_num()
+{
+	local op_bytes=$1
+	local opline=$2
+
+	local retval=0
+	substr=""
+
+	for opc in $op_bytes;
+	do
+		substr+="$opc"
+
+		# return if opcode bytes do not match @opline anymore
+		if ! echo $opline | grep -q "$substr";
+		then
+			break
+		fi
+
+		# add trailing space
+		substr+=" "
+		retval=$((retval+1))
+	done
+
+	return $retval
+}
+
+# Return the line number in objdump output to where the IP marker in the Code:
+# line points to
+#
+# Params:
+# @all_code: code in bytes without the marker
+# @dis_file: disassembled file
+# @ip_byte: The byte to which the IP points to
+get_faultlinenum()
+{
+	local all_code="$1"
+	local dis_file="$2"
+
+	# num bytes including IP byte
+	local num_bytes_ip=$(( $3 + 1 * $width ))
+
+	# Add the two header lines (we're counting from 1).
+	local retval=3
+
+	# remove marker
+	all_code=$(echo $all_code | sed -e 's/[<>()]//g')
+
+	while read line
+	do
+		get_substr_opcode_bytes_num "$all_code" "$line"
+		ate_opcodes=$?
+
+		if ! (( $ate_opcodes )); then
+			continue
+		fi
+
+		num_bytes_ip=$((num_bytes_ip - ($ate_opcodes * $width) ))
+		if (( $num_bytes_ip <= 0 )); then
+			break
+		fi
+
+		# Delete matched opcode bytes from all_code. For that, compute
+		# how many chars those opcodes are represented by and include
+		# trailing space.
+		#
+		# a byte is 2 chars, ate_opcodes is also the number of trailing
+		# spaces
+		del_chars=$(( ($ate_opcodes * $width * 2) + $ate_opcodes ))
+
+		all_code=$(echo $all_code | sed -e "s!^.\{$del_chars\}!!")
+
+		let "retval+=1"
+
+	done < $dis_file
+
+	return $retval
+}
+
 marker=`expr index "$code" "\<"`
 if [ $marker -eq 0 ]; then
 	marker=`expr index "$code" "\("`
 fi
 
-
 touch $T.oo
 if [ $marker -ne 0 ]; then
-	# 2 opcode bytes and a single space
-	pc_sub=$(( $marker / 3 ))
+	# How many bytes to subtract from the program counter
+	# in order to get to the beginning virtual address of the
+	# Code:
+	pc_sub=$(( (($marker - 1) / (2 * $width + 1)) * $width ))
 	echo All code >> $T.oo
 	echo ======== >> $T.oo
 	beforemark=`echo "$code"`
 	echo -n "	.$type 0x" > $T.s
+
 	echo $beforemark | sed -e 's/ /,0x/g; s/[<>()]//g' >> $T.s
+
 	disas $T $pc_sub
+
 	cat $T.dis >> $T.oo
-	rm -f $T.o $T.s $T.dis
 
-# and fix code at-and-after marker
+	get_faultlinenum "$code" "$T.dis" $pc_sub
+	faultlinenum=$?
+
+	# and fix code at-and-after marker
 	code=`echo "$code" | cut -c$((${marker} + 1))-`
+
+	rm -f $T.o $T.s $T.dis
 fi
+
 echo Code starting with the faulting instruction  > $T.aa
 echo =========================================== >> $T.aa
 code=`echo $code | sed -e 's/\r//;s/ [<(]/ /;s/[>)] / /;s/ /,0x/g; s/[>)]$//'`
@@ -132,15 +231,6 @@ echo $code >> $T.s
 disas $T 0
 cat $T.dis >> $T.aa
 
-# (lines of whole $T.oo) - (lines of $T.aa, i.e. "Code starting") + 3,
-# i.e. the title + the "===..=" line (sed is counting from 1, 0 address is
-# special)
-faultlinenum=$(( $(wc -l $T.oo  | cut -d" " -f1) - \
-		 $(wc -l $T.aa  | cut -d" " -f1) + 3))
-
-faultline=`cat $T.dis | head -1 | cut -d":" -f2-`
-faultline=`echo "$faultline" | sed -e 's/\[/\\\[/g; s/\]/\\\]/g'`
-
 cat $T.oo | sed -e "${faultlinenum}s/^\([^:]*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
 echo
 cat $T.aa
_

Patches currently in -mm which might be from bp@suse.de are

scripts-decodecode-improve-faulting-line-determination.patch

