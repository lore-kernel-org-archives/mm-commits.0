Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60483C433E6
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264B564F9D
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhBFDaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBFD04 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:26:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E6FF64FD5;
        Fri,  5 Feb 2021 22:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564743;
        bh=67/PHkJjMIrHcJkqi6Nyl5WbfOT974u8DimvjvrcGdg=;
        h=Date:From:To:Subject:From;
        b=XvFls34pCVo/HXe/G2dTRu1YO8IExRxrHv/9bsn1KKV/TsVCdvhvrvagWZeTMX6gN
         64AQRh5wE4uC/2HmKT6NfGm5NKjEkpbbbKg9vJFsA427iEesWkrkGuO/25t9P0hK12
         jD8Cvl0Hb/67JQRUbs2l7fAUBQQPGsaRLTaX1pRg=
Date:   Fri, 05 Feb 2021 14:39:02 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net,
        lucien.xin@gmail.com, luto@kernel.org, marcelo.leitner@gmail.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.de,
        nhorman@tuxdriver.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, vyasevich@gmail.com
Subject:  + x86-fix-seq_file-iteration-for-pat-memtypec.patch added
 to -mm tree
Message-ID: <20210205223902.hZvy0vZ6e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: fix seq_file iteration for pat/memtype.c
has been added to the -mm tree.  Its filename is
     x86-fix-seq_file-iteration-for-pat-memtypec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-fix-seq_file-iteration-for-pat-memtypec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-fix-seq_file-iteration-for-pat-memtypec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: x86: fix seq_file iteration for pat/memtype.c

The memtype seq_file iterator allocates a buffer in the ->start and ->next
functions and frees it in the ->show function.  The preferred handling for
such resources is to free them in the subsequent ->next or ->stop function
call.

Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
code and interface") there is no guarantee that ->show will be called
after ->next, so this function can now leak memory.

So move the freeing of the buffer to ->next and ->stop.

Link: https://lkml.kernel.org/r/161248539022.21478.13874455485854739066.stgit@noble1
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-fix-seq_file-iteration-for-pat-memtypec
+++ a/arch/x86/mm/pat/memtype.c
@@ -1164,12 +1164,14 @@ static void *memtype_seq_start(struct se
 
 static void *memtype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	kfree(v);
 	++*pos;
 	return memtype_get_idx(*pos);
 }
 
 static void memtype_seq_stop(struct seq_file *seq, void *v)
 {
+	kfree(v);
 }
 
 static int memtype_seq_show(struct seq_file *seq, void *v)
@@ -1181,8 +1183,6 @@ static int memtype_seq_show(struct seq_f
 			entry_print->end,
 			cattr_name(entry_print->type));
 
-	kfree(entry_print);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from neilb@suse.de are

seq_file-document-how-per-entry-resources-are-managed.patch
x86-fix-seq_file-iteration-for-pat-memtypec.patch
net-fix-iteration-for-sctp-transport-seq_files.patch

