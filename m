Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546F6C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE968216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881653;
	bh=l50u0W9/THu3LxMUo+Rahe4i74x/X9kwygPYgDONYPY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gS83GDUrYQD34elhSX9C8IZ8+uhHUrUZ1998ohnzTcztDcKv7xVY8E40mtDeiGmEw
	 gWUg+N/WNWLMjfKLaJzUpsGqhHXk/6qNBe1Aw5nnNcubgKTxlbFU7DKbpqLD49GyEH
	 4nA6KnMOObsTlnVPKb64zqgjVmAsxhRGCh+97948=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409232AbgJPUyM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409228AbgJPUyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD152145D;
        Fri, 16 Oct 2020 20:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881651;
        bh=l50u0W9/THu3LxMUo+Rahe4i74x/X9kwygPYgDONYPY=;
        h=Date:From:To:Subject:From;
        b=GkU+6uTNqPGkY76D948xdh/eL3VLpVYF4QZ/HDsoyQXeK+9GS/tN0D3RTwkzj7yzo
         ENHc15usUE/GMxeZIMNU+3c1nu4XK3f79zR1TFsvSBtRc2U2/wNpiaf2KHsE7Ofnin
         uBR3sT7FJfglnOMKW70XOTtyfFAiht4wIJkkK8bw=
Date:   Fri, 16 Oct 2020 13:54:11 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-emit-a-warning-on-embedded-filenames.patch removed from -mm tree
Message-ID: <20201016205411.I-ZaEV-B1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit a warning on embedded filenames
has been removed from the -mm tree.  Its filename was
     checkpatch-emit-a-warning-on-embedded-filenames.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit a warning on embedded filenames

Embedding the complete filename path inside the file isn't particularly
useful as often the path is moved around and becomes incorrect.

Emit a warning when the source contains the filename.

[akpm@linux-foundation.org: remove stray " di"]
Link: https://lkml.kernel.org/r/1fd5f9188a14acdca703ca00301ee323de672a8d.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-emit-a-warning-on-embedded-filenames
+++ a/scripts/checkpatch.pl
@@ -3271,6 +3271,12 @@ sub process {
 			}
 		}
 
+# check for embedded filenames
+		if ($rawline =~ /^\+.*\Q$realfile\E/) {
+			WARN("EMBEDDED_FILENAME",
+			     "It's generally not useful to have the filename in the file\n" . $herecurr);
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

