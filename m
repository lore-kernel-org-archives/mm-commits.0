Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB235C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9E664F9D
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhBFDa1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhBFD05 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:26:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B9964FB5;
        Fri,  5 Feb 2021 22:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564746;
        bh=N2dUSHciI8/To0eAiuJO1/WmnoRqwq1RMHWEQVq5u4o=;
        h=Date:From:To:Subject:From;
        b=XfGPUQySoeTTZsWtV0Jpj5J0KKWqamlDHK74bym/8RyhcVCxttE+8CexMe7FNfVXq
         fHEVrzKoMI1hkJXBXmeXPtczF5+swX9yK7cAwFFte/j0OdFE10PE+h14Cc+qHDCw52
         bowWItBP8v5xk3fhuLVCEuk+/nLOPhwVf5YXdkVU=
Date:   Fri, 05 Feb 2021 14:39:05 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net,
        lucien.xin@gmail.com, luto@kernel.org, marcelo.leitner@gmail.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.de,
        nhorman@tuxdriver.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, vyasevich@gmail.com
Subject:  + net-fix-iteration-for-sctp-transport-seq_files.patch
 added to -mm tree
Message-ID: <20210205223905.Y7pj6FJq5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: fix iteration for sctp transport seq_files
has been added to the -mm tree.  Its filename is
     net-fix-iteration-for-sctp-transport-seq_files.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/net-fix-iteration-for-sctp-transport-seq_files.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/net-fix-iteration-for-sctp-transport-seq_files.patch

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
Subject: net: fix iteration for sctp transport seq_files

The sctp transport seq_file iterators take a reference to the transport in
the ->start and ->next functions and releases the reference in the ->show
function.  The preferred handling for such resources is to release them in
the subsequent ->next or ->stop function call.

Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
code and interface") there is no guarantee that ->show will be called
after ->next, so this function can now leak references.

So move the sctp_transport_put() call to ->next and ->stop.

Link: https://lkml.kernel.org/r/161248539022.21478.17038123892954492263.stgit@noble1
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Xin Long <lucien.xin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/proc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/sctp/proc.c~net-fix-iteration-for-sctp-transport-seq_files
+++ a/net/sctp/proc.c
@@ -215,6 +215,12 @@ static void sctp_transport_seq_stop(stru
 {
 	struct sctp_ht_iter *iter = seq->private;
 
+	if (v && v != SEQ_START_TOKEN) {
+		struct sctp_transport *transport = v;
+
+		sctp_transport_put(transport);
+	}
+
 	sctp_transport_walk_stop(&iter->hti);
 }
 
@@ -222,6 +228,12 @@ static void *sctp_transport_seq_next(str
 {
 	struct sctp_ht_iter *iter = seq->private;
 
+	if (v && v != SEQ_START_TOKEN) {
+		struct sctp_transport *transport = v;
+
+		sctp_transport_put(transport);
+	}
+
 	++*pos;
 
 	return sctp_transport_get_next(seq_file_net(seq), &iter->hti);
@@ -277,8 +289,6 @@ static int sctp_assocs_seq_show(struct s
 		sk->sk_rcvbuf);
 	seq_printf(seq, "\n");
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 
@@ -354,8 +364,6 @@ static int sctp_remaddr_seq_show(struct
 		seq_printf(seq, "\n");
 	}
 
-	sctp_transport_put(transport);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from neilb@suse.de are

seq_file-document-how-per-entry-resources-are-managed.patch
x86-fix-seq_file-iteration-for-pat-memtypec.patch
net-fix-iteration-for-sctp-transport-seq_files.patch

