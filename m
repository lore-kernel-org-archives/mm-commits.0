Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECCBC43381
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 475B564E26
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhBFDaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229705AbhBFD04 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:26:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6922964FC0;
        Fri,  5 Feb 2021 22:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564740;
        bh=sal1+2qi345yQ/V2aB9HDAIpCpTFQTyfPoe3wtIMMMY=;
        h=Date:From:To:Subject:From;
        b=hsVXD3smIHMXC4PgCb5ksiOZhzaiZe6uWncd64DD0dnIAE0fQTr8Pq7RV3NEbC+9O
         cS93T2hB/ISzJVuiPP0LlHgWkWox7Z9cazxAr1bYUkY1oCJb0FCiDrQ1yNP6bgy0wU
         SANYfC0m7AK8dCLVQiPC3EFDneD89cIHjiQXz2ck=
Date:   Fri, 05 Feb 2021 14:38:58 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net,
        lucien.xin@gmail.com, luto@kernel.org, marcelo.leitner@gmail.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.de,
        nhorman@tuxdriver.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, vyasevich@gmail.com
Subject:  +
 seq_file-document-how-per-entry-resources-are-managed.patch added to -mm
 tree
Message-ID: <20210205223858.quxtsqLUV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: document how per-entry resources are managed.
has been added to the -mm tree.  Its filename is
     seq_file-document-how-per-entry-resources-are-managed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-document-how-per-entry-resources-are-managed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-document-how-per-entry-resources-are-managed.patch

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
Subject: seq_file: document how per-entry resources are managed.

Patch series "Fix some seq_file users that were recently broken".

A recent change to seq_file broke some users which were using seq_file
in a non-"standard" way ...  though the "standard" isn't documented, so
they can be excused.  The result is a possible leak - of memory in one
case, of references to a 'transport' in the other.

These three patches:
 1/ document and explain the problem
 2/ fix the problem user in x86
 3/ fix the problem user in net/sctp


This patch (of 3):

Users of seq_file will sometimes find it convenient to take a resource,
such as a lock or memory allocation, in the ->start or ->next operations. 
These are per-entry resources, distinct from per-session resources which
are taken in ->start and released in ->stop.

The preferred management of these is release the resource on the
subsequent call to ->next or ->stop.

However prior to Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file
iteration code and interface") it happened that ->show would always be
called after ->start or ->next, and a few users chose to release the
resource in ->show.

This is no longer reliable.  Since the mentioned commit, ->next will
always come after a successful ->show (to ensure m->index is updated
correctly), so the original ordering cannot be maintained.

This patch updates the documentation to clearly state the required
behaviour.  Other patches will fix the few problematic users.

Link: https://lkml.kernel.org/r/161248518659.21478.2484341937387294998.stgit@noble1
Link: https://lkml.kernel.org/r/161248539020.21478.3147971477400875336.stgit@noble1
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/filesystems/seq_file.rst~seq_file-document-how-per-entry-resources-are-managed
+++ a/Documentation/filesystems/seq_file.rst
@@ -217,6 +217,12 @@ between the calls to start() and stop(),
 is a reasonable thing to do. The seq_file code will also avoid taking any
 other locks while the iterator is active.
 
+The iterater value returned by start() or next() is guaranteed to be
+passed to a subsequenct next() or stop() call.  This allows resources
+such as locks that were taken to be reliably released.  There is *no*
+guarantee that the iterator will be passed to show(), though in practice
+it often will be.
+
 
 Formatted output
 ================
_

Patches currently in -mm which might be from neilb@suse.de are

seq_file-document-how-per-entry-resources-are-managed.patch
x86-fix-seq_file-iteration-for-pat-memtypec.patch
net-fix-iteration-for-sctp-transport-seq_files.patch

