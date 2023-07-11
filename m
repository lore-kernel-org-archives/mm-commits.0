Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535CDEB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 20:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjGKU5v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjGKU5v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 16:57:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED47171C
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 13:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A51E5615FC
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 20:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005D9C433C9;
        Tue, 11 Jul 2023 20:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689109068;
        bh=iq53qbYeNumhVdix3uVIGBtuBcFaxiMeo5yAACeJbtM=;
        h=Date:To:From:Subject:From;
        b=uUY0fHZJuq1dALzxn0OyfiOh/XDlts/oyIZKAAcr7pyrDwQSmdoiMWfrI/ftpGeIG
         5P+rDoh8QIKBte+jsXTp+LzKCijorpH27wtNxjzm52JCEFn77aF2ucCRlnwA7QG3sZ
         /sZCa8BWBcV6DyBlHkZI8A9n3xrNl+F6lImWDUSQ=
Date:   Tue, 11 Jul 2023 13:57:47 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-add-in_range-macro-fix-3.patch added to mm-unstable branch
Message-Id: <20230711205748.005D9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm mm-unstable branch.  Its filename is
     minmax-add-in_range-macro-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-add-in_range-macro-fix-3.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a
Date: Tue Jul 11 01:50:03 PM PDT 2023

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_nat_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_nat_core.c~minmax-add-in_range-macro-fix-3
+++ a/net/netfilter/nf_nat_core.c
@@ -327,7 +327,7 @@ static bool l4proto_in_range(const struc
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_conntrack_tuple *tuple,
+static int tuple_in_range(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
@@ -376,7 +376,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, range))
+			if (tuple_in_range(result, range))
 				return 1;
 		}
 	}
@@ -607,7 +607,7 @@ get_unique_tuple(struct nf_conntrack_tup
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(orig_tuple, range)) {
+		if (tuple_in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
minmax-add-in_range-macro-fix.patch
minmax-add-in_range-macro-fix-fix.patch
minmax-add-in_range-macro-fix-3.patch
minmax-add-in_range-macro-fix-4.patch
minmax-add-in_range-macro-fix-5.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

