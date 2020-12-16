Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45377C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A35923356
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgLPEpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgLPEpr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:47 -0500
Date:   Tue, 15 Dec 2020 20:45:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093906;
        bh=gn8hBR/tg+S0MZDVFfPQ1EyCt/JFxG+LqU3T2Puwtrw=;
        h=From:To:Subject:In-Reply-To:From;
        b=iQTYN5WilBWR1v4dk7GmnluC3ZAIsPBlSDQ9x4gUyZleEUn5QJ3RWrCtMOS2TOtUl
         JDM8y11x5rZsMoLV3rvtd+vvicayQW4YjAMkAP35QmzcY7oUSIVC2KBtJeW2ee/U+4
         XS3yTxBzRsD5q4d71Za9bw1eVhlsGyIIrhs3gWvI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yashsri421@gmail.com
Subject:  [patch 51/95] checkpatch: add fix option for
 ASSIGNMENT_CONTINUATIONS
Message-ID: <20201216044506.d-ZdYl_09%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Aditya Srivastava <yashsri421@gmail.com>
Subject: checkpatch: add fix option for ASSIGNMENT_CONTINUATIONS

Currently, checkpatch warns us if an assignment operator is placed at the
start of a line and not at the end of previous line.

E.g., running checkpatch on commit 8195b1396ec8 ("hv_netvsc: fix
deadlock on hotplug") reports:

CHECK: Assignment operator '=' should be on the previous line
+	struct netvsc_device *nvdev
+		= container_of(w, struct netvsc_device, subchan_work);

Provide a simple fix by appending assignment operator to the previous
line and removing from the current line, if both the lines are additions
(ie start with '+')

Link: https://lkml.kernel.org/r/20201121120407.22942-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-assignment_continuations
+++ a/scripts/checkpatch.pl
@@ -3533,8 +3533,14 @@ sub process {
 
 # check for assignments on the start of a line
 		if ($sline =~ /^\+\s+($Assignment)[^=]/) {
-			CHK("ASSIGNMENT_CONTINUATIONS",
-			    "Assignment operator '$1' should be on the previous line\n" . $hereprev);
+			my $operator = $1;
+			if (CHK("ASSIGNMENT_CONTINUATIONS",
+				"Assignment operator '$1' should be on the previous line\n" . $hereprev) &&
+			    $fix && $prevrawline =~ /^\+/) {
+				# add assignment operator to the previous line, remove from current line
+				$fixed[$fixlinenr - 1] .= " $operator";
+				$fixed[$fixlinenr] =~ s/\Q$operator\E\s*//;
+			}
 		}
 
 # check for && or || at the start of a line
_
